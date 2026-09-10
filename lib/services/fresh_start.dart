import 'package:shared_preferences/shared_preferences.dart';

/// One-time local wipe so every install starts at the new first-gesture onboarding.
class FreshStart {
  static const stamp = 'trade_master_fresh_20260910';

  static const _wipe = [
    'onboardingCompleted',
    'userGoal',
    'completedLessons',
    'quizHistory',
    'streak',
    'lastActive',
    'virtualBalance',
    'position',
    'positionSize',
    'entryPrice',
    'priceHistory',
    'currentPrice',
    'dailyChallengeDate',
    'dailyChallengeDone',
    'dailyChallengeScore',
    'flashcardsReviewed',
    'dailyActivity',
    'moduleQuizScores',
    'homeworkSubmitCounts',
    'totalXp',
    'userLevel',
  ];

  static Future<void> wipeIfNeeded() async {
    final p = await SharedPreferences.getInstance();
    if (p.getBool(stamp) ?? false) return;
    for (final key in _wipe) {
      await p.remove(key);
    }
    for (final key in p.getKeys().toList()) {
      if (key.startsWith('lessonStep_') || key.startsWith('practiceDone_')) {
        await p.remove(key);
      }
    }
    await p.setBool(stamp, true);
  }
}
