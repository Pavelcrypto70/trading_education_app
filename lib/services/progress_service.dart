import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'analytics_service.dart';
import 'club_service.dart';
import 'gamification_service.dart';
import 'streak_service.dart';
import 'sync_service.dart';

class ProgressService {
  static const _completedLessonsKey = 'completedLessons';
  static const _quizHistoryKey = 'quizHistory';
  static const _lastActiveKey = 'lastActive';
  static const _balanceKey = 'virtualBalance';
  static const _positionKey = 'position';
  static const _positionSizeKey = 'positionSize';
  static const _entryPriceKey = 'entryPrice';
  static const _priceHistoryKey = 'priceHistory';
  static const _currentPriceKey = 'currentPrice';
  static const _dailyChallengeDateKey = 'dailyChallengeDate';
  static const _dailyChallengeDoneKey = 'dailyChallengeDone';
  static const _dailyChallengeScoreKey = 'dailyChallengeScore';
  static const _flashcardsReviewedKey = 'flashcardsReviewed';
  static const _dailyActivityKey = 'dailyActivity';
  static const _moduleScoresKey = 'moduleQuizScores';
  static const _homeworkSubmitKey = 'homeworkSubmitCounts';
  static const _lessonStepPrefix = 'lessonStep_';

  static Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  static Future<void> saveLessonStep(int lessonId, int step) async {
    final prefs = await _prefs();
    await prefs.setInt('$_lessonStepPrefix$lessonId', step);
  }

  static Future<int> getLessonStep(int lessonId) async {
    final prefs = await _prefs();
    return prefs.getInt('$_lessonStepPrefix$lessonId') ?? 0;
  }

  static Future<void> clearLessonStep(int lessonId) async {
    final prefs = await _prefs();
    await prefs.remove('$_lessonStepPrefix$lessonId');
  }

  static Future<void> recordActivity() async {
    final prefs = await _prefs();
    if (prefs.getString(_lastActiveKey) == _todayKey()) return;
    await StreakService.light();
    SyncService.schedulePush();
  }

  /// Live streak: 0 once a missed day was not covered by a freeze.
  static Future<int> getStreak() => StreakService.currentDays();

  static Future<Set<int>> getCompletedLessons() async {
    final prefs = await _prefs();
    final raw = prefs.getStringList(_completedLessonsKey) ?? [];
    return raw.map(int.parse).toSet();
  }

  static Future<void> markLessonComplete(int lessonId) async {
    final prefs = await _prefs();
    final completed = await getCompletedLessons();
    completed.add(lessonId);
    await prefs.setStringList(
      _completedLessonsKey,
      completed.map((e) => e.toString()).toList(),
    );
    await prefs.remove('$_lessonStepPrefix$lessonId');
    await recordActivity();
    await recordDailyActivity();
    AnalyticsService.lessonComplete(lessonId);
    SyncService.schedulePush();
  }

  /// Marks several lessons complete without per-lesson analytics spam (placement skip).
  static Future<void> markLessonsComplete(Iterable<int> lessonIds) async {
    final ids = lessonIds.toSet();
    if (ids.isEmpty) return;
    final prefs = await _prefs();
    final completed = await getCompletedLessons();
    completed.addAll(ids);
    await prefs.setStringList(
      _completedLessonsKey,
      completed.map((e) => e.toString()).toList(),
    );
    for (final id in ids) {
      await prefs.remove('$_lessonStepPrefix$id');
    }
    await recordActivity();
    await recordDailyActivity();
    SyncService.schedulePush();
  }

  static Future<bool> isLessonComplete(int lessonId) async {
    final completed = await getCompletedLessons();
    return completed.contains(lessonId);
  }

  static Future<int> getCompletedCount() async {
    final completed = await getCompletedLessons();
    return completed.length;
  }

  static Future<void> saveQuizResult({
    required String title,
    required int score,
    required int total,
  }) async {
    final prefs = await _prefs();
    final history = prefs.getStringList(_quizHistoryKey) ?? [];
    history.insert(
      0,
      jsonEncode({
        'title': title,
        'score': score,
        'total': total,
        'date': DateTime.now().toIso8601String(),
      }),
    );
    if (history.length > 50) history.removeLast();
    await prefs.setStringList(_quizHistoryKey, history);
    await recordActivity();
    SyncService.schedulePush();
  }

  static Future<List<Map<String, dynamic>>> getQuizHistory() async {
    final prefs = await _prefs();
    final history = prefs.getStringList(_quizHistoryKey) ?? [];
    return history
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }

  static Future<double> getVirtualBalance() async {
    final prefs = await _prefs();
    return prefs.getDouble(_balanceKey) ?? 10000.0;
  }

  static Future<void> setVirtualBalance(double balance) async {
    final prefs = await _prefs();
    await prefs.setDouble(_balanceKey, balance);
  }

  static Future<String?> getPosition() async {
    final prefs = await _prefs();
    return prefs.getString(_positionKey);
  }

  static Future<double> getPositionSize() async {
    final prefs = await _prefs();
    return prefs.getDouble(_positionSizeKey) ?? 0;
  }

  static Future<double> getEntryPrice() async {
    final prefs = await _prefs();
    return prefs.getDouble(_entryPriceKey) ?? 0;
  }

  static Future<double> getCurrentPrice() async {
    final prefs = await _prefs();
    return prefs.getDouble(_currentPriceKey) ?? 100.0;
  }

  static Future<List<double>> getPriceHistory() async {
    final prefs = await _prefs();
    final raw = prefs.getStringList(_priceHistoryKey);
    if (raw == null || raw.isEmpty) return [100.0];
    return raw.map(double.parse).toList();
  }

  static Future<void> saveTradingState({
    required double balance,
    required double currentPrice,
    required List<double> priceHistory,
    String? position,
    double positionSize = 0,
    double entryPrice = 0,
    bool recordActivityOnSave = true,
  }) async {
    final prefs = await _prefs();
    await prefs.setDouble(_balanceKey, balance);
    await prefs.setDouble(_currentPriceKey, currentPrice);
    await prefs.setStringList(
      _priceHistoryKey,
      priceHistory.map((e) => e.toString()).toList(),
    );
    if (position == null) {
      await prefs.remove(_positionKey);
    } else {
      await prefs.setString(_positionKey, position);
    }
    await prefs.setDouble(_positionSizeKey, positionSize);
    await prefs.setDouble(_entryPriceKey, entryPrice);
    if (recordActivityOnSave) {
      await recordActivity();
    }
    SyncService.schedulePush();
  }

  static Future<bool> isDailyChallengeDone() async {
    final prefs = await _prefs();
    final date = prefs.getString(_dailyChallengeDateKey);
    return date == _todayKey() && (prefs.getBool(_dailyChallengeDoneKey) ?? false);
  }

  static Future<int?> getDailyChallengeScore() async {
    final prefs = await _prefs();
    if (prefs.getString(_dailyChallengeDateKey) != _todayKey()) return null;
    return prefs.getInt(_dailyChallengeScoreKey);
  }

  static Future<void> completeDailyChallenge(int score, int total) async {
    final prefs = await _prefs();
    await prefs.setString(_dailyChallengeDateKey, _todayKey());
    await prefs.setBool(_dailyChallengeDoneKey, true);
    await prefs.setInt(_dailyChallengeScoreKey, score);
    await saveQuizResult(title: 'Daily Challenge', score: score, total: total);
    SyncService.schedulePush();
  }

  static Future<int> getFlashcardsReviewed() async {
    final prefs = await _prefs();
    return prefs.getInt(_flashcardsReviewedKey) ?? 0;
  }

  static Future<void> incrementFlashcardsReviewed() async {
    final prefs = await _prefs();
    final count = prefs.getInt(_flashcardsReviewedKey) ?? 0;
    await prefs.setInt(_flashcardsReviewedKey, count + 1);
    await GamificationService.award(PointsReason.flashcard);
    SyncService.schedulePush();
  }

  static Future<bool> isPremium() async {
    // Deprecated: use PremiumService.isPremium(). Kept for compatibility.
    final prefs = await _prefs();
    return prefs.getBool('serverPremium') ?? false;
  }

  @Deprecated('Premium is granted server-side via PurchaseService')
  static Future<void> setPremium(bool value) async {
    // No-op: premium cannot be set locally anymore.
  }

  static Future<void> recordDailyActivity({int amount = 1}) async {
    final prefs = await _prefs();
    final raw = prefs.getString(_dailyActivityKey);
    final map = raw != null
        ? Map<String, dynamic>.from(jsonDecode(raw) as Map)
        : <String, dynamic>{};
    final today = _todayKey();
    map[today] = (map[today] as int? ?? 0) + amount;
    final cutoff = DateTime.now().subtract(const Duration(days: 14));
    map.removeWhere((key, _) {
      final parts = key.split('-');
      if (parts.length != 3) return true;
      final d = DateTime.tryParse(key);
      return d != null && d.isBefore(cutoff);
    });
    await prefs.setString(_dailyActivityKey, jsonEncode(map));
    await recordActivity();
  }

  static Future<List<int>> getWeeklyActivity() async {
    final prefs = await _prefs();
    final raw = prefs.getString(_dailyActivityKey);
    final map = raw != null
        ? Map<String, dynamic>.from(jsonDecode(raw) as Map)
        : <String, dynamic>{};
    final result = <int>[];
    for (var i = 6; i >= 0; i--) {
      final day = DateTime.now().subtract(Duration(days: i));
      final key = '${day.year}-${day.month}-${day.day}';
      result.add(map[key] as int? ?? 0);
    }
    return result;
  }

  static Future<void> markModulePassed(String moduleId, int score, int total) async {
    final prefs = await _prefs();
    final raw = prefs.getString(_moduleScoresKey);
    final map = raw != null
        ? Map<String, dynamic>.from(jsonDecode(raw) as Map)
        : <String, dynamic>{};
    map[moduleId] = {'score': score, 'total': total, 'date': DateTime.now().toIso8601String()};
    await prefs.setString(_moduleScoresKey, jsonEncode(map));
    await recordDailyActivity();
    SyncService.schedulePush();
  }

  static Future<bool> isModulePassed(String moduleId) async {
    final score = await getModuleScore(moduleId);
    return score != null;
  }

  static Future<int?> getModuleScore(String moduleId) async {
    final prefs = await _prefs();
    final raw = prefs.getString(_moduleScoresKey);
    if (raw == null) return null;
    final map = Map<String, dynamic>.from(jsonDecode(raw) as Map);
    final entry = map[moduleId] as Map<String, dynamic>?;
    return entry?['score'] as int?;
  }

  static Future<Map<String, Map<String, dynamic>>> getModuleResults() async {
    final prefs = await _prefs();
    final raw = prefs.getString(_moduleScoresKey);
    if (raw == null) return {};
    final map = Map<String, dynamic>.from(jsonDecode(raw) as Map);
    return map.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map)));
  }

  static Future<void> incrementHomeworkSubmit(int lessonId) async {
    final prefs = await _prefs();
    final raw = prefs.getString(_homeworkSubmitKey);
    final map = raw != null
        ? Map<String, dynamic>.from(jsonDecode(raw) as Map)
        : <String, dynamic>{};
    final key = lessonId.toString();
    map[key] = (map[key] as int? ?? 0) + 1;
    await prefs.setString(_homeworkSubmitKey, jsonEncode(map));
    await recordDailyActivity();
    SyncService.schedulePush();
  }

  static Future<int> getHomeworkSubmitCount(int lessonId) async {
    final map = await getHomeworkSubmitMap();
    return map[lessonId] ?? 0;
  }

  static Future<Map<int, int>> getHomeworkSubmitMap() async {
    final prefs = await _prefs();
    final raw = prefs.getString(_homeworkSubmitKey);
    if (raw == null) return {};
    final map = Map<String, dynamic>.from(jsonDecode(raw) as Map);
    return {
      for (final e in map.entries)
        if (int.tryParse(e.key) != null)
          int.parse(e.key): (e.value as num).toInt(),
    };
  }

  /// Unique lessons with at least one homework send.
  static Future<int> getHomeworkLessonsSubmitted() async {
    final map = await getHomeworkSubmitMap();
    return map.values.where((v) => v > 0).length;
  }

  /// Who the person is and what they've already earned in the club outlive a
  /// progress reset: ladder ID, name, passed cutoffs, referral code, language.
  static const _keepOnReset = [
    ...ClubService.identityKeys,
    ClubService.studentsAtKey,
    ClubService.proAtKey,
    ClubService.studentsSeenKey,
    ClubService.proSeenKey,
    'referralMyCode',
    'referralRedeemedCode',
    'appLanguage',
    'serverPremium',
    'serverPremiumCachedAt',
  ];

  /// [wipeIdentity] is for account deletion: nothing is kept.
  static Future<void> resetAll({bool wipeIdentity = false}) async {
    final prefs = await _prefs();
    final keep = <String, Object>{};
    if (!wipeIdentity) {
      for (final k in _keepOnReset) {
        final v = prefs.get(k);
        if (v != null) keep[k] = v;
      }
    }
    await prefs.clear();
    for (final e in keep.entries) {
      final v = e.value;
      if (v is String) await prefs.setString(e.key, v);
      if (v is bool) await prefs.setBool(e.key, v);
      if (v is int) await prefs.setInt(e.key, v);
      if (v is double) await prefs.setDouble(e.key, v);
      if (v is List<String>) await prefs.setStringList(e.key, v);
    }
    if (!wipeIdentity) await SyncService.pushNow();
  }

  static String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }
}
