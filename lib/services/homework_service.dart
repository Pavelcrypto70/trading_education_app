import 'dart:convert';

import 'package:flutter/services.dart';

import '../config/app_config.dart';
import '../utils/external_link.dart';

import '../services/locale_service.dart';
import '../services/progress_service.dart';

/// Homework submission: copy a template, open the Desk Club homework topic.
class HomeworkService {
  static Map<String, dynamic>? _rubrics;

  static Future<Map<String, dynamic>> loadRubrics() async {
    if (_rubrics != null) return _rubrics!;
    final raw = await rootBundle.loadString('assets/data/homework_rubrics.json');
    _rubrics = jsonDecode(raw) as Map<String, dynamic>;
    return _rubrics!;
  }

  static Future<String> instructions() async {
    final data = await loadRubrics();
    final tg = data['telegram'] as Map<String, dynamic>;
    final instr = tg['instructions'] as Map<String, dynamic>;
    final lang = LocaleService.instance.languageCode;
    return (instr[lang] ?? instr['en'] ?? '') as String;
  }

  static Future<String> chatUrl() async {
    return AppConfig.homeworkTelegramUrl;
  }

  static String buildTemplate({
    required int lessonId,
    required String lessonTitle,
    String? oneSentence,
  }) {
    final lang = LocaleService.instance.languageCode;
    final labels = switch (lang) {
      'ru' => (
          'Урок',
          'Одной фразой',
          'Что сделал',
          'Что ещё не ясно',
          'Топик',
        ),
      'pt' => (
          'Aula',
          'Em uma frase',
          'O que fiz',
          'O que ainda não ficou claro',
          'Tópico',
        ),
      'es' => (
          'Lección',
          'En una frase',
          'Qué hice',
          'Qué aún no está claro',
          'Tema',
        ),
      _ => (
          'Lesson',
          'In one sentence',
          'What I did',
          'Still unclear',
          'Topic',
        ),
    };
    final one = (oneSentence ?? '').trim();
    return '${labels.$1} $lessonId: $lessonTitle\n'
        '${labels.$5}: ${AppConfig.homeworkTopicName} · ${AppConfig.communityTelegramHandle}\n\n'
        '${labels.$2}:\n'
        '${one.isEmpty ? '—' : one}\n\n'
        '${labels.$3}:\n'
        '• \n\n'
        '${labels.$4}:\n'
        '• \n\n'
        '#hw-submitted #TradeMasterHW';
  }

  static Future<List<Map<String, dynamic>>> criteria() async {
    final data = await loadRubrics();
    final list = data['criteria'] as List? ?? const [];
    final lang = LocaleService.instance.languageCode;
    return list.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return {
        'id': m['id'],
        'weight': m['weight'],
        'text': (m[lang] ?? m['en'] ?? '') as String,
      };
    }).toList();
  }

  static Future<int> passScore() async {
    final data = await loadRubrics();
    return data['passScore'] as int? ?? 7;
  }

  static Future<bool> submitHomework({
    required int lessonId,
    required String lessonTitle,
    String? oneSentence,
  }) async {
    final text = buildTemplate(
      lessonId: lessonId,
      lessonTitle: lessonTitle,
      oneSentence: oneSentence,
    );
    await Clipboard.setData(ClipboardData(text: text));
    await ProgressService.incrementHomeworkSubmit(lessonId);
    final base = await chatUrl();
    return openExternalLink(base);
  }
}
