import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/trade_plan.dart';
import 'locale_service.dart';
import 'sim_mode.dart';

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

  /// Returns a plain-language error or null if the plan is valid.
  static String? validate(
    TradePlan plan, {
    double minRiskReward = 0,
    SimLevel level = SimLevel.spotRisk,
  }) {
    final l10n = LocaleService.instance.strings;
    if (plan.entry <= 0 || plan.stop <= 0 || plan.target <= 0) {
      return l10n.planFillStopTake;
    }
    if (plan.direction == 'long') {
      if (plan.stop >= plan.entry) return l10n.planStopBelowEntry;
      if (plan.target <= plan.entry) return l10n.planTakeAboveEntry;
    } else {
      if (plan.stop <= plan.entry) return l10n.planStopAboveEntryShort;
      if (plan.target >= plan.entry) return l10n.planTakeBelowEntryShort;
    }
    if (level == SimLevel.spot) {
      if (plan.amountUsdt < 10) return l10n.planMinBuyAmount;
    } else if (plan.riskPercent < 0.25 || plan.riskPercent > 1) {
      return l10n.planRiskRange;
    }
    if (level == SimLevel.futures) {
      if (plan.leverage < 1 || plan.leverage > 3) return l10n.planLeverageRange;
      final liq = plan.liquidationPrice;
      if (liq != null) {
        final stopBeforeLiq = plan.direction == 'long' ? plan.stop > liq : plan.stop < liq;
        if (!stopBeforeLiq) return stopPastLiquidation;
      }
    }
    if (minRiskReward > 0 && !ratioOk(plan.riskReward, minRiskReward)) {
      return l10n.planRrNeed(_fmt(ratioShown(plan.riskReward)), _fmt(minRiskReward));
    }
    return null;
  }

  static String get stopPastLiquidation => LocaleService.instance.strings.planStopPastLiq;

  /// Stop and take from current price: stop 1.5% away, take twice as far (1 to 2).
  static ({double stop, double target}) around(double price, {required bool long}) {
    final stop = double.parse((price * (long ? 0.985 : 1.015)).toStringAsFixed(2));
    final target = double.parse((price + (price - stop) * 2).toStringAsFixed(2));
    return (stop: stop, target: target);
  }

  /// Ratio text without a needless «,0»: «2», «2,5».
  static String ratioText(double ratio) => _fmt(ratioShown(ratio));

  /// Points and the lesson task need a real stop: at least 0,5% away from the entry.
  static bool stopFarEnough(double entry, double stop) => entry > 0 && (entry - stop).abs() / entry >= 0.005;

  /// Prices are rounded to cents, so 1 to 1,99 counts as 1 to 2.
  static bool ratioOk(double ratio, double min) => ratio + 0.01 >= min;

  /// Ratio as the learner should read it: one decimal, rounded down, except the rounding tolerance.
  static double ratioShown(double ratio) => ((ratio + 0.01) * 10).floor() / 10;

  static String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1).replaceAll('.', ',');
}
