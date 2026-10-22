import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

/// Debug log + optional PostHog (POSTHOG_API_KEY via --dart-define).
class AnalyticsService {
  AnalyticsService._();

  static const _distinctIdKey = 'analyticsDistinctId';
  static const _apiKey = String.fromEnvironment('POSTHOG_API_KEY');
  static const _host = String.fromEnvironment(
    'POSTHOG_HOST',
    defaultValue: 'https://us.i.posthog.com',
  );

  static bool get isEnabled => _apiKey.isNotEmpty;

  static Future<void> initialize() async {
    await _distinctId();
    await _maybeTrackDay7Return();
  }

  static Future<String> _distinctId() async {
    if (AuthService.isSignedIn && AuthService.currentUser != null) {
      return AuthService.currentUser!.id;
    }
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_distinctIdKey);
    if (id == null) {
      id = 'anon_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString(_distinctIdKey, id);
    }
    return id;
  }

  static Future<void> _maybeTrackDay7Return() async {
    const key = 'analyticsFirstOpen';
    final prefs = await SharedPreferences.getInstance();
    final first = prefs.getString(key);
    final now = DateTime.now();
    if (first == null) {
      await prefs.setString(key, now.toIso8601String());
      return;
    }
    final firstDate = DateTime.tryParse(first);
    if (firstDate == null) return;
    final days = now.difference(firstDate).inDays;
    if (days >= 7 && !(prefs.getBool('analyticsDay7Sent') ?? false)) {
      await prefs.setBool('analyticsDay7Sent', true);
      track('day_7_return', {'days': days});
    }
  }

  static void track(String event, [Map<String, dynamic>? properties]) {
    if (kDebugMode) {
      debugPrint('[analytics] $event ${properties ?? {}}');
    }
    if (!isEnabled) return;
    _send(event, properties ?? {});
  }

  static Future<void> _send(String event, Map<String, dynamic> properties) async {
    try {
      final distinctId = await _distinctId();
      await http.post(
        Uri.parse('$_host/capture/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'api_key': _apiKey,
          'event': event,
          'distinct_id': distinctId,
          'properties': {
            ...properties,
            'platform': kIsWeb ? 'web' : 'mobile',
          },
        }),
      );
    } catch (_) {}
  }

  static void signUp() => track('sign_up');
  static void lessonComplete(int lessonId) => track('lesson_complete', {'lesson_id': lessonId});
  static void paywallView(int lessonId) => track('paywall_view', {'lesson_id': lessonId});
  static void purchaseStart() => track('purchase_start');
  static void purchaseSuccess(String platform) => track('purchase_success', {'platform': platform});

  /// Soft Tiger recommend (web): shown after stage 1 — lessons stay free either way.
  static void refRecommendShown({String surface = 'soft_ref'}) =>
      track('ref_recommend_shown', {'surface': surface});
  static void refCtaClick({String surface = 'soft_ref'}) =>
      track('ref_cta_click', {'surface': surface});
  static void continueWithoutRef({String surface = 'soft_ref'}) =>
      track('continue_without_ref', {'surface': surface});
  static void refVerified() => track('ref_verified');
  static void proChatEnterDenied({String reason = 'no_ref'}) =>
      track('pro_chat_enter_denied', {'reason': reason});
}
