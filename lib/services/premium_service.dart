import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';
import 'backend_service.dart';

/// Server-authoritative premium flag (cached locally). Clients cannot self-grant.
class PremiumService {
  PremiumService._();

  static const _cacheKey = 'serverPremium';
  static const _cacheAtKey = 'serverPremiumCachedAt';

  static Future<bool> isPremium() async {
    if (BackendService.isAvailable && AuthService.isSignedIn) {
      await refreshFromServer();
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_cacheKey) ?? false;
  }

  static Future<void> refreshFromServer() async {
    if (!BackendService.isAvailable || !AuthService.isSignedIn) return;
    final user = AuthService.currentUser!;
    // Owner accounts always get full access even if DB flag is stale.
    if (await AuthService.isAdmin()) {
      await _setCached(true);
      return;
    }
    try {
      final row = await BackendService.client
          .from('user_profiles')
          .select('is_premium, is_admin')
          .eq('id', user.id)
          .maybeSingle();
      final premium = row?['is_premium'] == true || row?['is_admin'] == true;
      await _setCached(premium);
    } catch (_) {
      // Keep cached value on network error.
    }
  }

  static Future<void> applyServerPremium(bool value) async {
    await _setCached(value);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_cacheAtKey);
  }

  static Future<void> _setCached(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_cacheKey, value);
    await prefs.setString(_cacheAtKey, DateTime.now().toIso8601String());
  }
}
