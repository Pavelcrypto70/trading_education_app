import 'dart:convert';

import 'package:flutter/services.dart';
import '../utils/external_link.dart';

import '../services/locale_service.dart';
import '../services/progress_service.dart';

/// Homework submission via Telegram deep link (no bot token in client).
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
    final data = await loadRubrics();
    final tg = data['telegram'] as Map<String, dynamic>;
    return tg['chatUrl'] as String? ?? 'https://t.me/trade_master_homework';
  }

  /// Opens Telegram with pre-filled homework template for the lesson.
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
  }) async {
    final lang = LocaleService.instance.languageCode;
    final labels = switch (lang) {
      'ru' => ('Урок', 'Сетап', 'Вход', 'Стоп', 'Цель', 'Риск %'),
      'pt' => ('Lição', 'Setup', 'Entrada', 'Stop', 'Alvo', 'Risco %'),
      _ => ('Lesson', 'Setup', 'Entry', 'Stop', 'Target', 'Risk %'),
    };
    final text = Uri.encodeComponent(
      '${labels.$1} $lessonId: $lessonTitle\n'
      '${labels.$2}: \n'
      '${labels.$3}: \n'
      '${labels.$4}: \n'
      '${labels.$5}: \n'
      '${labels.$6}: \n'
      '#TradeMasterHW',
    );
    final base = await chatUrl();
    final ok = await openExternalLink('$base?text=$text');
    if (ok) await ProgressService.incrementHomeworkSubmit(lessonId);
    return ok;
  }
}
