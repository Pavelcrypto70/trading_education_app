import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const _completedLessonsKey = 'completedLessons';
  static const _quizHistoryKey = 'quizHistory';
  static const _streakKey = 'streak';
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
  static const _isPremiumKey = 'isPremium';
  static const _flashcardsReviewedKey = 'flashcardsReviewed';
  static const _dailyActivityKey = 'dailyActivity';
  static const _moduleScoresKey = 'moduleQuizScores';
  static const _homeworkSubmitKey = 'homeworkSubmitCounts';

  static Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  static Future<void> recordActivity() async {
    final prefs = await _prefs();
    final today = _todayKey();
    final lastActive = prefs.getString(_lastActiveKey);

    if (lastActive == today) return;

    var streak = prefs.getInt(_streakKey) ?? 0;
    if (lastActive == _yesterdayKey()) {
      streak += 1;
    } else if (lastActive != today) {
      streak = 1;
    }

    await prefs.setInt(_streakKey, streak);
    await prefs.setString(_lastActiveKey, today);
  }

  static Future<int> getStreak() async {
    final prefs = await _prefs();
    return prefs.getInt(_streakKey) ?? 0;
  }

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
    await recordActivity();
    await recordDailyActivity();
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
    await recordActivity();
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
  }

  static Future<int> getFlashcardsReviewed() async {
    final prefs = await _prefs();
    return prefs.getInt(_flashcardsReviewedKey) ?? 0;
  }

  static Future<void> incrementFlashcardsReviewed() async {
    final prefs = await _prefs();
    final count = prefs.getInt(_flashcardsReviewedKey) ?? 0;
    await prefs.setInt(_flashcardsReviewedKey, count + 1);
    await recordActivity();
  }

  static Future<bool> isPremium() async {
    final prefs = await _prefs();
    return prefs.getBool(_isPremiumKey) ?? false;
  }

  static Future<void> setPremium(bool value) async {
    final prefs = await _prefs();
    await prefs.setBool(_isPremiumKey, value);
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
      final d = DateTime.tryParse('$key');
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
  }

  static Future<int> getHomeworkSubmitCount(int lessonId) async {
    final prefs = await _prefs();
    final raw = prefs.getString(_homeworkSubmitKey);
    if (raw == null) return 0;
    final map = Map<String, dynamic>.from(jsonDecode(raw) as Map);
    return map[lessonId.toString()] as int? ?? 0;
  }

  static Future<void> resetAll() async {
    final prefs = await _prefs();
    await prefs.clear();
  }

  static String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  static String _yesterdayKey() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return '${yesterday.year}-${yesterday.month}-${yesterday.day}';
  }
}
