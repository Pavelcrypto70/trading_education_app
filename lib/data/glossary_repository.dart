import 'dart:convert';

import 'package:flutter/services.dart';

import '../services/locale_service.dart';

class GlossaryEntry {
  final String term;
  final String definition;

  GlossaryEntry({required this.term, required this.definition});

  factory GlossaryEntry.fromJson(Map<String, dynamic> json, String lang) {
    final t = json['term'] as Map<String, dynamic>;
    final d = json['def'] as Map<String, dynamic>;
    return GlossaryEntry(
      term: (t[lang] ?? t['en'] ?? '') as String,
      definition: (d[lang] ?? d['en'] ?? '') as String,
    );
  }
}

class GlossaryRepository {
  static List<GlossaryEntry>? _cache;

  static Future<List<GlossaryEntry>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/glossary.json');
    final list = jsonDecode(raw) as List;
    final lang = LocaleService.instance.languageCode;
    _cache = list
        .map((e) => GlossaryEntry.fromJson(Map<String, dynamic>.from(e as Map), lang))
        .toList()
      ..sort((a, b) => a.term.compareTo(b.term));
    return _cache!;
  }
}
