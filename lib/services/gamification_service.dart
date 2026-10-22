import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';
import 'locale_service.dart';
import 'streak_service.dart';
import 'sync_service.dart';

enum PointsReason { lesson, lessonQuiz, moduleTest, homework, paperTrade, exam, journal, flashcard }

class PointsAward {
  const PointsAward({required this.base, required this.awarded, required this.multiplier, required this.total});

  final int base;
  final int awarded;
  final double multiplier;
  final int total;

  bool get isZero => awarded == 0;
}

class League {
  const League(this.name, this.minPoints, this.color, {this.unlocks});

  final String name;
  final int minPoints;
  final Color color;
  final String? unlocks;
}

/// Points for learning and discipline only — never for profit, volume or deposit.
/// Thresholds equal the mandatory blocks of each stage without multiplier
/// (see Trade-Master-itog/3 mechanics doc, §2).
class GamificationService {
  static const _totalKey = 'pointsTotal';
  static const _weekPrefix = 'pointsWeek_';
  static const _dayBasePrefix = 'pointsDayBase_';
  static const _awardedKeys = 'pointsAwardedKeys';
  static const _ledgerKey = 'pointsLedger';
  static const _flashPrefix = 'pointsFlash_';
  static const _planTradesKey = 'planTradesCount';
  static const _legacyXpKey = 'totalXp';

  static const dailyCap = 400;
  static const flashcardsPerDay = 10;

  static const Map<PointsReason, int> base = {
    PointsReason.lesson: 50,
    PointsReason.lessonQuiz: 30,
    PointsReason.moduleTest: 100,
    PointsReason.homework: 100,
    PointsReason.paperTrade: 80,
    PointsReason.exam: 200,
    PointsReason.journal: 20,
    PointsReason.flashcard: 5,
  };

  static const cutoffStudents = 1400;
  static const cutoffPro = 6900;

  /// [League.name] / [League.unlocks] are stable ids — localize via AppLocalizations.leagueName / leagueUnlock.
  static const leagues = [
    League('novice', 0, AppTheme.muted),
    League('student', cutoffStudents, AppTheme.mint, unlocks: 'students_chat'),
    League('practitioner', 3600, AppTheme.sky),
    League('trader', 5500, AppTheme.peach),
    League('pro', cutoffPro, AppTheme.lavender, unlocks: 'pro_chat'),
  ];

  static League leagueFor(int points) {
    var current = leagues.first;
    for (final l in leagues) {
      if (points >= l.minPoints) current = l;
    }
    return current;
  }

  static League? nextLeague(int points) {
    for (final l in leagues) {
      if (points < l.minPoints) return l;
    }
    return null;
  }

  static String _day(DateTime d) => '${d.year}-${d.month}-${d.day}';

  static String _weekKey(DateTime d) {
    final monday = DateTime(d.year, d.month, d.day).subtract(Duration(days: d.weekday - 1));
    return _day(monday);
  }

  static Future<int> getPoints() async {
    final prefs = await SharedPreferences.getInstance();
    final total = prefs.getInt(_totalKey);
    if (total != null) return total;
    final legacy = prefs.getInt(_legacyXpKey) ?? 0;
    await prefs.setInt(_totalKey, legacy);
    return legacy;
  }

  static Future<int> getWeekPoints() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_weekPrefix${_weekKey(DateTime.now())}') ?? 0;
  }

  static Future<int> getPlanTrades() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_planTradesKey) ?? 0;
  }

  static Future<bool> wasAwarded(String uniqueKey) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_awardedKeys) ?? const []).contains(uniqueKey);
  }

  /// Awards points once per [uniqueKey]; applies the daily cap (before
  /// multiplier) and the streak multiplier. Lights today's flame.
  static Future<PointsAward> award(PointsReason reason, {String? uniqueKey}) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = _day(now);
    final total = await getPoints();

    final keys = prefs.getStringList(_awardedKeys) ?? <String>[];
    final key = uniqueKey ?? (reason == PointsReason.journal ? 'journal-$today' : null);
    if (key != null && keys.contains(key)) {
      return PointsAward(base: 0, awarded: 0, multiplier: 1, total: total);
    }
    if (reason == PointsReason.flashcard) {
      final n = prefs.getInt('$_flashPrefix$today') ?? 0;
      if (n >= flashcardsPerDay) {
        return PointsAward(base: 0, awarded: 0, multiplier: 1, total: total);
      }
      await prefs.setInt('$_flashPrefix$today', n + 1);
    }

    await StreakService.light();
    final streak = await StreakService.load();
    final usedToday = prefs.getInt('$_dayBasePrefix$today') ?? 0;
    final baseAmount = (base[reason]!).clamp(0, (dailyCap - usedToday).clamp(0, dailyCap));
    final mult = streak.multiplier;
    final awarded = (baseAmount * mult).round();

    final newTotal = total + awarded;
    await prefs.setInt(_totalKey, newTotal);
    await prefs.setInt('$_dayBasePrefix$today', usedToday + baseAmount);
    final weekKey = '$_weekPrefix${_weekKey(now)}';
    await prefs.setInt(weekKey, (prefs.getInt(weekKey) ?? 0) + awarded);
    if (key != null) {
      keys.add(key);
      await prefs.setStringList(_awardedKeys, keys);
    }
    if (reason == PointsReason.paperTrade) {
      await prefs.setInt(_planTradesKey, (prefs.getInt(_planTradesKey) ?? 0) + 1);
    }
    final ledger = prefs.getStringList(_ledgerKey) ?? <String>[];
    ledger.insert(0, jsonEncode({'r': reason.name, 'p': awarded, 'at': now.toIso8601String()}));
    if (ledger.length > 200) ledger.removeRange(200, ledger.length);
    await prefs.setStringList(_ledgerKey, ledger);
    SyncService.schedulePush();

    final result = PointsAward(base: baseAmount, awarded: awarded, multiplier: mult, total: newTotal);
    if (awarded > 0) lastAward = result;
    return result;
  }

  /// Most recent non-zero award, for result screens that render after the award.
  static PointsAward? lastAward;

  static Future<List<({String reason, int points, DateTime at})>> ledger({int limit = 20}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_ledgerKey) ?? const [];
    return raw.take(limit).map((e) {
      final m = jsonDecode(e) as Map<String, dynamic>;
      final r = PointsReason.values.firstWhere((x) => x.name == m['r'], orElse: () => PointsReason.lesson);
      return (reason: reasonLabel(r), points: m['p'] as int, at: DateTime.parse(m['at'] as String));
    }).toList();
  }

  static String reasonLabel(PointsReason r) {
    final l10n = LocaleService.instance.strings;
    return switch (r) {
      PointsReason.lesson => l10n.pointsReasonLesson,
      PointsReason.lessonQuiz => l10n.pointsReasonLessonQuiz,
      PointsReason.moduleTest => l10n.pointsReasonModuleTest,
      PointsReason.homework => l10n.pointsReasonHomework,
      PointsReason.paperTrade => l10n.pointsReasonPaperTrade,
      PointsReason.exam => l10n.pointsReasonExam,
      PointsReason.journal => l10n.pointsReasonJournal,
      PointsReason.flashcard => l10n.pointsReasonFlashcard,
    };
  }

  // ---- Legacy API kept for older screens (home_screen etc.) ----

  static const int xpPerLesson = 50;
  static const int xpPerQuiz = 30;
  static const int xpPerFlashcard = 5;
  static const int xpPerDailyChallenge = 0;
  static const int xpPerCheckpoint = 80;

  static Future<int> getXp() => getPoints();

  static Future<int> getLevel() async => leagues.indexOf(leagueFor(await getPoints())) + 1;

  static int levelFromXp(int xp) => leagues.indexOf(leagueFor(xp)) + 1;

  static int xpProgressInLevel(int xp) => xp - leagueFor(xp).minPoints;

  static int xpNeededForNextLevel(int xp) {
    final next = nextLeague(xp);
    if (next == null) return 1;
    return next.minPoints - leagueFor(xp).minPoints;
  }

  /// Points are earned only through [award]; bonus sources (referrals,
  /// certificate) no longer add points.
  static Future<int> addXp(int amount) => getPoints();

  static String levelTitle(int level, String lang) =>
      leagues[(level - 1).clamp(0, leagues.length - 1)].name;
}
