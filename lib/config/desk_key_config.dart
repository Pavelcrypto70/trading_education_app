import 'package:flutter/foundation.dart';

/// Desk Club key: free access to lessons 15–58 for a Tiger.com account
/// registered through our link. Values come from --dart-define
/// (see dart_defines.example.json); empty value = that part is hidden.
class DeskKeyConfig {
  DeskKeyConfig._();

  /// Store builds must not mention the broker, so the free key exists only on the web build.
  static bool get enabled => kIsWeb;

  /// One-tap / local-owner unlock for QA. Web only — never in Play/Galaxy APK.
  static bool get ownerUnlockEnabled => kIsWeb;

  static const refLink = String.fromEnvironment('TIGER_REF_LINK');
  static const refCode = String.fromEnvironment('TIGER_REF_CODE');

  /// Private Telegram chat with the mentor. The User ID must never go to the public hub.
  static const reviewUrl = String.fromEnvironment('KEY_REVIEW_TG_URL');

  /// Shared with tools/desk_key_code.py, which the owner uses to issue codes.
  static const codeSalt = String.fromEnvironment('KEY_SALT');

  static const tigerSupportEmail = 'broker.support@tiger.com';
}
