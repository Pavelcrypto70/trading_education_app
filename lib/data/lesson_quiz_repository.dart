import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/lesson_quiz_question.dart';
import '../services/locale_service.dart';

class LessonQuizRepository {
  static List<LessonQuizQuestion>? _cache;

  static Future<List<LessonQuizQuestion>> loadAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/lesson_quizzes.json');
    final list = jsonDecode(raw) as List;
    final lang = LocaleService.instance.languageCode;
    _cache = list
        .map((e) => LessonQuizQuestion.fromJson(Map<String, dynamic>.from(e as Map), lang))
        .toList();
    return _cache!;
  }

  static Future<List<LessonQuizQuestion>> forLesson(int lessonId) async {
    final all = await loadAll();
    return all.where((q) => q.lessonId == lessonId).toList();
  }
}
