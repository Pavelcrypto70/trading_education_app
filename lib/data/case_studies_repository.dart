import 'dart:convert';

import 'package:flutter/services.dart';

import '../services/locale_service.dart';

class CaseStudy {
  final String id;
  final String date;
  final String title;
  final String summary;
  final List<int> lessonIds;
  final String? sourceTitle;
  final String? sourceUrl;

  const CaseStudy({
    required this.id,
    required this.date,
    required this.title,
    required this.summary,
    required this.lessonIds,
    this.sourceTitle,
    this.sourceUrl,
  });
}

class CaseStudiesRepository {
  static List<CaseStudy>? _cache;

  static Future<List<CaseStudy>> loadAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/case_studies.json');
    final list = jsonDecode(raw) as List;
    final lang = LocaleService.instance.languageCode;
    _cache = list.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      final title = m['title'] as Map<String, dynamic>? ?? {};
      final summary = m['summary'] as Map<String, dynamic>? ?? {};
      final source = m['source'] as Map<String, dynamic>?;
      return CaseStudy(
        id: m['id'] as String,
        date: m['date'] as String? ?? '',
        title: (title[lang] ?? title['en'] ?? '') as String,
        summary: (summary[lang] ?? summary['en'] ?? '') as String,
        lessonIds: List<int>.from(m['lessonIds'] as List? ?? const []),
        sourceTitle: source?['title'] as String?,
        sourceUrl: source?['url'] as String?,
      );
    }).toList();
    return _cache!;
  }

  static Future<List<CaseStudy>> forLesson(int lessonId) async {
    final all = await loadAll();
    return all.where((c) => c.lessonIds.contains(lessonId)).toList();
  }
}
