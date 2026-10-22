import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../config/desk_key_config.dart';
import '../utils/external_link.dart';
import 'auth_service.dart';
import 'backend_service.dart';
import 'club_service.dart';
import 'locale_service.dart';
import 'premium_service.dart';

enum DeskKeyStatus { none, sent, pending, rejected, active }

class DeskKeyState {
  const DeskKeyState({
    required this.status,
    this.uid,
    this.reason,
    this.rejections = 0,
    this.viaServer = false,
  });

  final DeskKeyStatus status;
  final String? uid;
  final String? reason;
  final int rejections;

  /// True when the request sits in the database queue; false when it went to the mentor in Telegram.
  final bool viaServer;
}

/// Free Desk Club key: Tiger.com account through our link → User ID check → lessons 15–58.
///
/// With a working backend the request goes to `desk_key_submit` and approval sets
/// `is_premium`. Without it the learner sends the User ID to the mentor privately
/// and gets back a code bound to their public ID (see tools/desk_key_code.py).
class DeskKeyService {
  DeskKeyService._();

  static const _uidKey = 'deskKeyUid';
  static const _sentKey = 'deskKeySentAt';
  static const _viaServerKey = 'deskKeyViaServer';
  static const _activeKey = 'deskKeyActive';

  static final _uidRx = RegExp(r'^[0-9A-Za-z]{5,20}$');

  static String normalizeUid(String raw) => raw.replaceAll(RegExp(r'\s'), '');

  static bool isValidUid(String raw) => _uidRx.hasMatch(normalizeUid(raw));

  static Future<bool> isActive() async {
    // Store builds must not treat a web Desk Club key as Play Billing bypass.
    if (!DeskKeyConfig.enabled) return false;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_activeKey) ?? false;
  }

  static Future<DeskKeyState> load() async {
    if (!DeskKeyConfig.enabled) {
      return const DeskKeyState(status: DeskKeyStatus.none);
    }
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(_uidKey);
    if (prefs.getBool(_activeKey) ?? false) {
      return DeskKeyState(status: DeskKeyStatus.active, uid: uid);
    }
    final viaServer = prefs.getBool(_viaServerKey) ?? false;
    if (viaServer && BackendService.isAvailable && AuthService.isSignedIn) {
      try {
        final res = await BackendService.client.rpc('desk_key_status');
        if (res is Map) {
          final status = res['status'] as String?;
          final rejections = (res['rejections'] as num?)?.toInt() ?? 0;
          if (status == 'approved') {
            await _activate(prefs);
            await PremiumService.refreshFromServer();
            return DeskKeyState(status: DeskKeyStatus.active, uid: uid);
          }
          if (status == 'rejected') {
            return DeskKeyState(
              status: DeskKeyStatus.rejected,
              uid: uid,
              reason: res['reason'] as String?,
              rejections: rejections,
              viaServer: true,
            );
          }
          if (status == 'pending') {
            return DeskKeyState(status: DeskKeyStatus.pending, uid: uid, rejections: rejections, viaServer: true);
          }
        }
      } catch (_) {}
    }
    if (prefs.getString(_sentKey) != null) {
      return DeskKeyState(
        status: viaServer ? DeskKeyStatus.pending : DeskKeyStatus.sent,
        uid: uid,
        viaServer: viaServer,
      );
    }
    return DeskKeyState(status: DeskKeyStatus.none, uid: uid);
  }

  static Future<String> requestMessage(String uid) async {
    final id = await ClubService.publicId();
    return LocaleService.instance.strings.deskKeyRequestMessage(normalizeUid(uid), id);
  }

  /// Tries the database queue first, then falls back to a private Telegram message.
  /// Returns true when the request went to the database.
  static Future<bool> submit(String rawUid) async {
    if (!DeskKeyConfig.enabled) return false;
    final uid = normalizeUid(rawUid);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_uidKey, uid);
    await prefs.setString(_sentKey, DateTime.now().toIso8601String());

    if (BackendService.isAvailable && AuthService.isSignedIn) {
      try {
        final res = await BackendService.client.rpc('desk_key_submit', params: {
          'p_uid': uid,
          'p_public_id': await ClubService.publicId(),
        });
        if (res is Map && res['ok'] == true) {
          await prefs.setBool(_viaServerKey, true);
          return true;
        }
      } catch (_) {}
    }

    await prefs.setBool(_viaServerKey, false);
    await Clipboard.setData(ClipboardData(text: await requestMessage(uid)));
    final url = DeskKeyConfig.reviewUrl.trim().isNotEmpty ? DeskKeyConfig.reviewUrl : AppConfig.communityTelegramUrl;
    await openExternalLink(url);
    return false;
  }

  static Future<void> resetRequest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sentKey);
    await prefs.remove(_viaServerKey);
  }

  static String expectedCode(String publicId, String salt) {
    final digest = sha256.convert(utf8.encode('$publicId|$salt')).toString().toUpperCase();
    return '${digest.substring(0, 4)}-${digest.substring(4, 8)}';
  }

  static String _normalizeCode(String raw) => raw.toUpperCase().replaceAll(RegExp(r'[^0-9A-F]'), '');

  /// Code from the mentor. Returns true and opens lessons 15–58 if it matches this device's public ID.
  static Future<bool> redeemCode(String raw) async {
    if (!DeskKeyConfig.enabled) return false;
    final salt = DeskKeyConfig.codeSalt;
    if (salt.isEmpty) return false;
    final id = await ClubService.publicId();
    if (_normalizeCode(raw) != _normalizeCode(expectedCode(id, salt))) return false;
    await _activate(await SharedPreferences.getInstance());
    return true;
  }

  static Future<void> _activate(SharedPreferences prefs) async {
    await prefs.setBool(_activeKey, true);
    await prefs.remove(_sentKey);
  }
}
