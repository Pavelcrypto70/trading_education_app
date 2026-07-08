import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../models/quiz_question.dart';
import '../services/locale_service.dart';
import '../services/progress_service.dart';
import 'unified_quiz_bank.dart';

class ModuleQuizMeta {
  final String moduleId;
  final String title;
  final List<int> lessonIds;
  final int passPercent;
  final int questionCount;
  final int timeMin;

  const ModuleQuizMeta({
    required this.moduleId,
    required this.title,
    required this.lessonIds,
    required this.passPercent,
    required this.questionCount,
    required this.timeMin,
  });
}

class ModuleQuizRepository {
  static List<ModuleQuizMeta>? _cache;

  static Future<List<ModuleQuizMeta>> loadModules() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/module_quizzes.json');
    final list = jsonDecode(raw) as List;
    final lang = LocaleService.instance.languageCode;
    _cache = list.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      final title = m['title'] as Map<String, dynamic>? ?? {};
      return ModuleQuizMeta(
        moduleId: m['moduleId'] as String,
        title: (title[lang] ?? title['en'] ?? '') as String,
        lessonIds: List<int>.from(m['lessonIds'] as List? ?? const []),
        passPercent: m['passPercent'] as int? ?? 70,
        questionCount: m['questionCount'] as int? ?? 10,
        timeMin: m['timeMin'] as int? ?? 15,
      );
    }).toList();
    return _cache!;
  }

  static Future<List<QuizQuestion>> questionsForModule(ModuleQuizMeta module) async {
    await UnifiedQuizBank.ensureLoaded();
    final pool = UnifiedQuizBank.allQuestions
        .where((q) => q.lessonId != null && module.lessonIds.contains(q.lessonId))
        .toList();
    if (pool.isEmpty) {
      return UnifiedQuizBank.allQuestions.take(module.questionCount).toList();
    }
    final shuffled = List<QuizQuestion>.from(pool)..shuffle(Random());
    return shuffled.take(module.questionCount).toList();
  }

  static Future<bool> isModulePassed(String moduleId) async {
    return ProgressService.isModulePassed(moduleId);
  }

  static Future<int?> getModuleScore(String moduleId) async {
    return ProgressService.getModuleScore(moduleId);
  }
}
