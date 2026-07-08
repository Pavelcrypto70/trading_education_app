import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/lesson.dart';
import '../services/locale_service.dart';
import 'app_data.dart';

class LessonsRepository {
  LessonsRepository._();
  static final LessonsRepository instance = LessonsRepository._();

  List<Lesson>? _cache;
  String? _cachedLocale;

  factory LessonsRepository() => instance;

  void clearCache() {
    _cache = null;
    _cachedLocale = null;
  }

  Future<List<Lesson>> loadLessons() async {
    final locale = LocaleService.instance.languageCode;
    if (_cache != null && _cachedLocale == locale) {
      return List<Lesson>.from(_cache!);
    }

    final assetPaths = [
      'assets/data/lessons_$locale.json',
      if (locale != 'en') 'assets/data/lessons_en.json',
      'assets/data/lessons_full.json',
    ];

    for (final path in assetPaths) {
      try {
        final jsonStr = await rootBundle.loadString(path);
        final decoded = json.decode(jsonStr) as List;
        _cache = decoded
            .map((item) => Lesson.fromJson(Map<String, dynamic>.from(item)))
            .toList();
        _cachedLocale = locale;
        return List<Lesson>.from(_cache!);
      } catch (_) {
        continue;
      }
    }

    _cache = List<Lesson>.from(appLessons);
    _cachedLocale = locale;
    return List<Lesson>.from(_cache!);
  }

  Future<Lesson?> getLessonById(int id) async {
    final lessons = await loadLessons();
    for (final lesson in lessons) {
      if (lesson.id == id) return lesson;
    }
    return null;
  }

  Future<Lesson?> getNextLesson(int currentId) async {
    final lessons = await loadLessons();
    final index = lessons.indexWhere((l) => l.id == currentId);
    if (index < 0 || index >= lessons.length - 1) return null;
    return lessons[index + 1];
  }

  List<String> getModules(List<Lesson> lessons) {
    return lessons.map((l) => l.module).toSet().toList();
  }
}
