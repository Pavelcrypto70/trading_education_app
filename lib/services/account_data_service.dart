import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';
import 'backend_service.dart';
import 'premium_service.dart';
import 'progress_service.dart';

/// GDPR / App Store: export local data + permanently delete cloud account.
class AccountDataService {
  AccountDataService._();

  static Future<Map<String, dynamic>> collectExport() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().toList()..sort();
    final local = <String, dynamic>{};
    for (final key in keys) {
      local[key] = prefs.get(key);
    }
    return {
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'app': 'Trade Master',
      'email': await AuthService.getEmail(),
      'userId': AuthService.currentUser?.id,
      'localPreferences': local,
    };
  }

  static Future<String> exportJson() async {
    final data = await collectExport();
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  static Future<void> copyExportToClipboard() async {
    final json = await exportJson();
    await Clipboard.setData(ClipboardData(text: json));
  }

  /// Deletes cloud auth user (cascades DB rows) and wipes local prefs.
  static Future<AccountDeleteResult> deleteAccountAndWipeLocal() async {
    if (!BackendService.isAvailable || !AuthService.isSignedIn) {
      await ProgressService.resetAll(wipeIdentity: true);
      await PremiumService.clear();
      return AccountDeleteResult.localOnly;
    }

    try {
      final res = await BackendService.client.functions.invoke('delete-account');
      final data = res.data;
      final ok = data is Map && data['ok'] == true;
      if (!ok) {
        return AccountDeleteResult.failed;
      }
    } catch (_) {
      return AccountDeleteResult.failed;
    }

    await AuthService.signOut();
    await ProgressService.resetAll(wipeIdentity: true);
    await PremiumService.clear();
    return AccountDeleteResult.deleted;
  }
}

enum AccountDeleteResult { deleted, localOnly, failed }
