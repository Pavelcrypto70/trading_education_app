import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../config/backend_config.dart';
import '../config/desk_key_config.dart';
import 'backend_service.dart';
import 'premium_service.dart';

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
    // Hardcoded allow-list: owner emails always unlock the full course
    // (Supabase session or local owner session).
    if (_isAdminEmail(currentUser?.email)) return true;
    if (_isAdminEmail(await getEmail())) return true;

    if (!BackendService.isAvailable || currentUser == null) return false;

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

  /// Local owner unlock when OTP/backend is unavailable (allow-listed emails only).
  /// Web QA only — disabled in Play/Galaxy so reviewers cannot bypass IAP.
  static Future<AuthResult> signInLocalOwner(String rawEmail) async {
    if (!DeskKeyConfig.ownerUnlockEnabled) return AuthResult.error;
    final email = rawEmail.trim().toLowerCase();
    if (email.isEmpty || !email.contains('@')) return AuthResult.invalidEmail;
    if (!_isAdminEmail(email)) return AuthResult.error;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_legacyEmailKey, email);
    await prefs.setString(_legacyDisplayNameKey, email.split('@').first);
    await prefs.setString(_legacyProviderKey, 'owner_local');
    // Belt-and-suspenders: also flip the local premium cache so every gate opens.
    await PremiumService.applyServerPremium(true);
    return AuthResult.success;
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
