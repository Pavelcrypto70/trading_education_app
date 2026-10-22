import 'dart:convert';

import 'package:flutter/services.dart';

import '../config/app_config.dart';
import '../utils/external_link.dart';

import '../services/gamification_service.dart';
import '../services/locale_service.dart';
import '../services/progress_service.dart';

/// Homework submission: copy a template, open the Desk Club homework topic.
class HomeworkService {
  static const minAnswerLength = 20;

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
    String? result,
    String? unclear,
  }) {
    final l10n = LocaleService.instance.strings;
    final labels = (
      l10n.hwLabelLesson,
      l10n.hwLabelAbout,
      l10n.hwLabelResult,
      l10n.hwLabelUnclear,
      l10n.hwLabelTopic,
    );
    String v(String? s) => (s ?? '').trim().isEmpty ? '—' : s!.trim();
    return '${labels.$1} $lessonId: $lessonTitle\n'
        '${labels.$5}: ${AppConfig.homeworkTopicName} · ${AppConfig.communityTelegramHandle}\n\n'
        '${labels.$2}:\n'
        '${v(oneSentence)}\n\n'
        '${labels.$3}:\n'
        '${v(result)}\n\n'
        '${labels.$4}:\n'
        '${v(unclear)}\n\n'
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
    String? result,
    String? unclear,
  }) async {
    final text = buildTemplate(
      lessonId: lessonId,
      lessonTitle: lessonTitle,
      oneSentence: oneSentence,
      result: result,
      unclear: unclear,
    );
    await Clipboard.setData(ClipboardData(text: text));
    await ProgressService.incrementHomeworkSubmit(lessonId);
    // No reviewer acceptance flow yet: points are granted once per lesson on send.
    if ((oneSentence ?? '').trim().length >= minAnswerLength) {
      await GamificationService.award(PointsReason.homework, uniqueKey: 'hw-$lessonId');
    }
    final base = await chatUrl();
    return openExternalLink(base);
  }
}
