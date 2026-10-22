import '../models/quiz_question.dart';

/// Holds quiz payload across go_router navigations (extra is easy to lose on web).
class QuizSession {
  QuizSession._();

  static String? title;
  static List<QuizQuestion>? questions;
  static bool isDailyChallenge = false;
  static String? moduleId;
  static int? passPercent;
  static bool isPlacement = false;
  static List<int> placementLessonIds = const [];

  static void set({
    required String title,
    required List<QuizQuestion> questions,
    bool isDailyChallenge = false,
    String? moduleId,
    int? passPercent,
    bool isPlacement = false,
    List<int> placementLessonIds = const [],
  }) {
    QuizSession.title = title;
    QuizSession.questions = questions;
    QuizSession.isDailyChallenge = isDailyChallenge;
    QuizSession.moduleId = moduleId;
    QuizSession.passPercent = passPercent;
    QuizSession.isPlacement = isPlacement;
    QuizSession.placementLessonIds = placementLessonIds;
  }

  static bool get hasSession => questions != null && questions!.isNotEmpty && title != null;

  static void clear() {
    title = null;
    questions = null;
    isDailyChallenge = false;
    moduleId = null;
    passPercent = null;
    isPlacement = false;
    placementLessonIds = const [];
  }
}
