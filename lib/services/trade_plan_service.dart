import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/trade_plan.dart';

class TradePlanService {
  static const _key = 'activeTradePlan';

  static Future<void> save(TradePlan plan) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(plan.toJson()));
  }

  static Future<TradePlan?> getActive() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    return TradePlan.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  /// Returns localized error key or null if valid.
  static String? validate(TradePlan plan) {
    if (plan.entry <= 0 || plan.stop <= 0 || plan.target <= 0) {
      return 'invalidLevels';
    }
    if (plan.riskPercent < 0.25 || plan.riskPercent > 3) {
      return 'invalidRisk';
    }
    if (plan.direction == 'long') {
      if (plan.stop >= plan.entry) return 'stopAboveEntry';
      if (plan.target <= plan.entry) return 'targetBelowEntry';
    } else {
      if (plan.stop <= plan.entry) return 'stopBelowEntry';
      if (plan.target >= plan.entry) return 'targetAboveEntry';
    }
    if (plan.riskReward < 1.5) return 'lowRR';
    return null;
  }
}
