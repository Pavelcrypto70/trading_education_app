import '../models/quiz_question.dart';

/// Legacy hard-coded bank removed — arena/module quizzes use lesson_quizzes.json
/// via [UnifiedQuizBank] (generated from the linear 58-lesson curriculum).
class QuizBank {
  static const List<String> categories = [
    'All',
    'Basics',
    'Chart',
    'Levels',
    'Patterns',
    'Strategy',
    'Market',
    'Risk',
  ];

  static const List<QuizQuestion> allQuestions = [];
}
