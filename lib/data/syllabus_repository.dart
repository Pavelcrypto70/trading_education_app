import 'dart:convert';

import 'package:flutter/services.dart';

class SyllabusRepository {
  static Map<String, dynamic>? _cache;

  static Future<Map<String, dynamic>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/syllabus.json');
    _cache = jsonDecode(raw) as Map<String, dynamic>;
    return _cache!;
  }

  static String text(Map<String, dynamic>? map, String lang) {
    if (map == null) return '';
    return (map[lang] ?? map['en'] ?? '') as String;
  }
}
