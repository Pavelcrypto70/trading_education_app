import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../config/backend_config.dart';
import 'backend_service.dart';

enum AuthResult {
  success,
  invalidEmail,
  otpSent,
  notConfigured,
  error,
}

/// Supabase Auth (email OTP). Falls back to read-only offline identity when backend is off.
class AuthService {
  static const _legacyEmailKey = 'authEmail';
  static const _legacyDisplayNameKey = 'authDisplayName';
  static const _legacyProviderKey = 'authProvider';

  static User? get currentUser =>
      BackendService.isAvailable ? BackendService.client.auth.currentUser : null;

  static bool get isSignedIn {
    if (BackendService.isAvailable) {
      return currentUser != null;
    }
    return false;
  }

  static bool _isAdminEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final lower = email.trim().toLowerCase();
    return AppConfig.adminEmails.any((e) => e.toLowerCase() == lower);
  }

  static Future<String?> getEmail() async {
    if (BackendService.isAvailable && currentUser != null) {
      return currentUser!.email;
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_legacyEmailKey);
  }

  static Future<String?> getDisplayName() async {
    if (BackendService.isAvailable && currentUser != null) {
      return currentUser!.userMetadata?['display_name'] as String? ??
          currentUser!.email?.split('@').first;
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_legacyDisplayNameKey);
  }

  static Future<bool> isAdmin() async {
    if (!BackendService.isAvailable || currentUser == null) return false;

    // Hardcoded allow-list (always unlock full course for owner accounts).
    if (_isAdminEmail(currentUser!.email)) return true;

    try {
      final row = await BackendService.client
          .from('user_profiles')
          .select('is_admin')
          .eq('id', currentUser!.id)
          .maybeSingle();
      return row?['is_admin'] == true;
    } catch (_) {
      return false;
    }
  }

  /// Sends a one-time code to email (magic link / OTP).
  static Future<AuthResult> sendEmailOtp(String rawEmail) async {
    final email = rawEmail.trim().toLowerCase();
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      return AuthResult.invalidEmail;
    }
    if (!BackendService.isAvailable) {
      return AuthResult.notConfigured;
    }
    try {
      await BackendService.client.auth.signInWithOtp(
        email: email,
        emailRedirectTo: BackendConfig.emailRedirectTo,
      );
      return AuthResult.otpSent;
    } catch (_) {
      return AuthResult.error;
    }
  }

  /// Verifies 6-digit OTP from email.
  static Future<AuthResult> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    if (!BackendService.isAvailable) return AuthResult.notConfigured;
    try {
      await BackendService.client.auth.verifyOTP(
        type: OtpType.email,
        email: email.trim().toLowerCase(),
        token: token.trim(),
      );
      return AuthResult.success;
    } catch (_) {
      return AuthResult.error;
    }
  }

  static Future<void> signOut() async {
    if (BackendService.isAvailable) {
      await BackendService.client.auth.signOut();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_legacyEmailKey);
    await prefs.remove(_legacyDisplayNameKey);
    await prefs.remove(_legacyProviderKey);
  }

  static Stream<AuthState> get authStateChanges {
    if (!BackendService.isAvailable) {
      return const Stream.empty();
    }
    return BackendService.client.auth.onAuthStateChange;
  }
}
