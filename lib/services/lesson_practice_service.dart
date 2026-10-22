import 'package:shared_preferences/shared_preferences.dart';

import 'demo_market_engine.dart';

class LessonPracticeContext {
  final int lessonId;
  final String lessonTitle;
  final String symbol;
  final String scenario;

  const LessonPracticeContext({
    required this.lessonId,
    required this.lessonTitle,
    required this.symbol,
    required this.scenario,
  });
}

class LessonPracticeService {
  static const _lessonIdKey = 'practiceLessonId';
  static const _lessonTitleKey = 'practiceLessonTitle';
  static const _symbolKey = 'practiceSymbol';
  static const _scenarioKey = 'practiceScenario';
  static const _donePrefix = 'practiceDone_';

  static Future<void> startPractice({
    required int lessonId,
    required String lessonTitle,
    String symbol = DemoMarketEngine.pair,
    String? scenario,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lessonIdKey, lessonId);
    await prefs.setString(_lessonTitleKey, lessonTitle);
    await prefs.setString(_symbolKey, symbol);
    await prefs.setString(_scenarioKey, scenario ?? '');
  }

  static Future<LessonPracticeContext?> getActive() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_lessonIdKey);
    if (id == null) return null;
    return LessonPracticeContext(
      lessonId: id,
      lessonTitle: prefs.getString(_lessonTitleKey) ?? '#$id',
      symbol: prefs.getString(_symbolKey) ?? DemoMarketEngine.pair,
      scenario: prefs.getString(_scenarioKey) ?? '',
    );
  }

  static Future<void> clearActive() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lessonIdKey);
    await prefs.remove(_lessonTitleKey);
    await prefs.remove(_symbolKey);
    await prefs.remove(_scenarioKey);
  }

  static Future<bool> isDone(int lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_donePrefix$lessonId') ?? false;
  }

  static Future<void> markDone(int lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_donePrefix$lessonId', true);
    await clearActive();
  }
}
