import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import 'gamification_service.dart';

class ReferralService {
  static const _myCodeKey = 'referralMyCode';
  static const _redeemedKey = 'referralRedeemedCode';
  static const _allRedemptionsKey = 'referralAllRedemptions';
  static const _xpAwardedCountKey = 'referralXpAwardedCount';
  static const referralXpReward = 500;
  static const redeemXpBonus = 100;

  static Future<String> getMyCode() async {
    final prefs = await SharedPreferences.getInstance();
    var code = prefs.getString(_myCodeKey);
    if (code == null || code.isEmpty) {
      code = _generateCode();
      await prefs.setString(_myCodeKey, code);
    }
    return code;
  }

  static String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random();
    final suffix = List.generate(6, (_) => chars[r.nextInt(chars.length)]).join();
    return 'TM-$suffix';
  }

  static Future<bool> hasRedeemed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_redeemedKey) != null;
  }

  static Future<String?> getRedeemedCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_redeemedKey);
  }

  static Future<int> getInviteCount() async {
    final myCode = await getMyCode();
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_allRedemptionsKey) ?? [];
    return list.where((c) => c == myCode).length;
  }

  static Future<void> syncInviteRewards() async {
    final count = await getInviteCount();
    final prefs = await SharedPreferences.getInstance();
    final awarded = prefs.getInt(_xpAwardedCountKey) ?? 0;
    if (count > awarded) {
      await GamificationService.addXp((count - awarded) * referralXpReward);
      await prefs.setInt(_xpAwardedCountKey, count);
    }
  }

  /// Returns null on success, or error token.
  static Future<String?> redeemCode(String input) async {
    final code = input.trim().toUpperCase();
    if (code.isEmpty) return 'empty';
    if (!code.startsWith('TM-')) return 'invalid';

    final myCode = await getMyCode();
    if (code == myCode) return 'own';

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_redeemedKey) != null) return 'already';

    await prefs.setString(_redeemedKey, code);
    final list = prefs.getStringList(_allRedemptionsKey) ?? [];
    list.add(code);
    await prefs.setStringList(_allRedemptionsKey, list);
    await GamificationService.addXp(redeemXpBonus);
    return null;
  }

  static Future<String> buildShareMessage(String baseMessage) async {
    final code = await getMyCode();
    return '$baseMessage\n\n🎁 $code';
  }
}
