import 'package:flutter/foundation.dart' show kIsWeb;

/// Supabase + Stripe keys via `--dart-define` (never commit secrets).
class BackendConfig {
  BackendConfig._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Where magic-link / email confirm redirects land (production web).
  static const authSiteUrl = String.fromEnvironment(
    'AUTH_SITE_URL',
    defaultValue: 'https://pavelcrypto70.github.io',
  );

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Prefer current web origin unless it's localhost (dev) — then use [authSiteUrl].
  static String get emailRedirectTo {
    if (kIsWeb) {
      final origin = Uri.base.origin;
      if (origin.contains('localhost') || origin.contains('127.0.0.1')) {
        return authSiteUrl;
      }
      return origin;
    }
    return authSiteUrl;
  }
}
