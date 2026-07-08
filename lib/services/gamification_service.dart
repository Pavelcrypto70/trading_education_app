import 'package:shared_preferences/shared_preferences.dart';

class GamificationService {
  static const _xpKey = 'totalXp';
  static const _levelKey = 'userLevel';

  static const int xpPerLesson = 50;
  static const int xpPerQuiz = 30;
  static const int xpPerFlashcard = 5;
  static const int xpPerDailyChallenge = 40;
  static const int xpPerCheckpoint = 20;

  static int xpForLevel(int level) => level * 100;

  static int levelFromXp(int xp) {
    var level = 1;
    var needed = 0;
    while (needed + xpForLevel(level) <= xp) {
      needed += xpForLevel(level);
      level++;
    }
    return level;
  }

  static int xpProgressInLevel(int xp) {
    final level = levelFromXp(xp);
    var spent = 0;
    for (var i = 1; i < level; i++) {
      spent += xpForLevel(i);
    }
    return xp - spent;
  }

  static int xpNeededForNextLevel(int xp) => xpForLevel(levelFromXp(xp));

  static Future<int> getXp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_xpKey) ?? 0;
  }

  static Future<int> getLevel() async {
    final xp = await getXp();
    return levelFromXp(xp);
  }

  static Future<int> addXp(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_xpKey) ?? 0;
    final updated = current + amount;
    await prefs.setInt(_xpKey, updated);
    await prefs.setInt(_levelKey, levelFromXp(updated));
    return updated;
  }

  static String levelTitle(int level, String lang) {
    final titles = {
      'en': ['Novice', 'Apprentice', 'Student', 'Analyst', 'Trader', 'Pro Trader', 'Expert', 'Master'],
      'ru': ['Новичок', 'Ученик', 'Студент', 'Аналитик', 'Трейдер', 'Про', 'Эксперт', 'Мастер'],
      'pt': ['Novato', 'Aprendiz', 'Estudante', 'Analista', 'Trader', 'Pro', 'Expert', 'Mestre'],
    };
    final list = titles[lang] ?? titles['en']!;
    final idx = (level - 1).clamp(0, list.length - 1);
    return list[idx];
  }
}
