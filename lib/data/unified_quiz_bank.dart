import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../models/quiz_question.dart';
import '../services/locale_service.dart';
import 'quiz_bank.dart';

class UnifiedQuizBank {
  static List<QuizQuestion>? _cache;
  static bool _loading = false;

  static Future<void> ensureLoaded() async {
    if (_cache != null || _loading) return;
    _loading = true;
    try {
      final raw = await rootBundle.loadString('assets/data/lesson_quizzes.json');
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
        final showChart = lessonId <= 47 && id.endsWith('Q1');
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
      final legacy = QuizBank.allQuestions
          .map(
            (q) => QuizQuestion(
              category: q.category,
              difficulty: q.difficulty,
              question: q.question,
              options: q.options,
              correctIndex: q.correctIndex,
              explanation: q.explanation,
              sourceId: 'legacy-${q.question.hashCode}',
            ),
          )
          .toList();
      _cache = [...fromLessons, ...legacy];
    } catch (_) {
      _cache = QuizBank.allQuestions;
    } finally {
      _loading = false;
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
    if (lessonId <= 7) return 'Basics';
    if ({8, 9, 19, 43, 46, 47}.contains(lessonId)) return 'Patterns';
    if ({10, 21, 23, 30, 32}.contains(lessonId)) return 'Strategy';
    if ({7, 18, 28, 31, 35, 36, 39, 40}.contains(lessonId)) return 'Risk';
    if ({11, 12, 20, 24, 25, 27, 34, 44}.contains(lessonId)) return 'Market';
    if ({13, 14, 15, 16, 17, 22, 26, 42, 45}.contains(lessonId)) return 'Chart';
    return 'Basics';
  }
}
