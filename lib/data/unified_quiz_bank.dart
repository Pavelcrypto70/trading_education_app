import 'dart:convert';
import 'dart:math';

import '../models/quiz_question.dart';
import '../services/locale_service.dart';
import 'localized_asset.dart';
import 'quiz_bank.dart';

/// Quiz Arena + module tests: only questions from the current 58-lesson course.
class UnifiedQuizBank {
  static List<QuizQuestion>? _cache;
  static Future<void>? _loading;

  static Future<void> ensureLoaded() async {
    if (_cache != null) return;
    if (_loading != null) {
      await _loading;
      return;
    }
    _loading = _load();
    try {
      await _loading;
    } finally {
      _loading = null;
    }
  }

  static Future<void> _load() async {
    try {
      final raw = await loadLocalizedAsset('lesson_quizzes');
      final list = jsonDecode(raw) as List;
      final lang = LocaleService.instance.languageCode;
      final fromLessons = <QuizQuestion>[];
      for (final item in list) {
        final m = Map<String, dynamic>.from(item as Map);
        final lessonId = m['lessonId'] as int;
        final q = m['question'] as Map<String, dynamic>? ?? {};
        final o = m['options'] as Map<String, dynamic>? ?? {};
        final e = m['explanation'] as Map<String, dynamic>? ?? {};
        final difficulty = _mapDifficulty(m['difficulty'] as String? ?? 'Beginner');
        final category = _categoryForLesson(lessonId);
        final id = m['id'] as String? ?? 'L$lessonId';
        // The rebuilt RU course has no generic «guess the chart» pictures in tests.
        final showChart = lang != 'ru' && id.endsWith('Q1');
        fromLessons.add(
          QuizQuestion(
            category: category,
            difficulty: difficulty,
            question: (q[lang] ?? q['en'] ?? '') as String,
            options: List<String>.from(o[lang] ?? o['en'] ?? const []),
            correctIndex: m['correctIndex'] as int? ?? 0,
            explanation: (e[lang] ?? e['en'] ?? '') as String,
            lessonId: lessonId,
            showChart: showChart,
            sourceId: id,
          ),
        );
      }
      _cache = fromLessons;
    } catch (_) {
      _cache = QuizBank.allQuestions;
    }
  }

  static List<QuizQuestion> get allQuestions => _cache ?? QuizBank.allQuestions;

  static List<String> get categories {
    final cats = allQuestions.map((q) => q.category).toSet().toList()..sort();
    return ['All', ...cats];
  }

  static List<QuizQuestion> filter({
    required String category,
    required String difficulty,
  }) {
    var list = category == 'All'
        ? allQuestions
        : allQuestions.where((q) => q.category == category).toList();
    if (difficulty != 'All') {
      list = list.where((q) => q.difficulty == difficulty).toList();
    }
    return list;
  }

  static List<QuizQuestion> dailyChallenge({int count = 5}) {
    final seed = DateTime.now().day + DateTime.now().month * 31;
    final random = Random(seed);
    final shuffled = List<QuizQuestion>.from(allQuestions)..shuffle(random);
    return shuffled.take(count).toList();
  }

  static String _mapDifficulty(String d) {
    switch (d) {
      case 'Intermediate':
        return 'Medium';
      case 'Advanced':
        return 'Hard';
      default:
        return 'Easy';
    }
  }

  static String _categoryForLesson(int lessonId) {
    // Mirrors tools/course/build.py MODULES.
    if (lessonId <= 8) return 'Basics';
    if (lessonId <= 14) return 'Strategy';
    if (lessonId <= 28) return 'Levels';
    if (lessonId <= 36) return 'Patterns';
    if (lessonId <= 46) return 'Strategy';
    if (lessonId <= 51) return 'Risk';
    return 'Market';
  }
}
