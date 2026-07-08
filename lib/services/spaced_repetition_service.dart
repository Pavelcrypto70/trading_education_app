import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SpacedRepetitionService {
  static const _key = 'spacedReviewQueue';

  static Future<void> recordWrong({
    required String questionId,
    required String question,
    required List<String> options,
    required int correctIndex,
    required String explanation,
    required String category,
    required String difficulty,
    int? lessonId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final items = raw
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .where((e) => e['id'] != questionId)
        .toList();
    items.insert(0, {
      'id': questionId,
      'question': question,
      'options': options,
      'correctIndex': correctIndex,
      'explanation': explanation,
      'category': category,
      'difficulty': difficulty,
      if (lessonId != null) 'lessonId': lessonId,
      'due': DateTime.now().add(const Duration(hours: 4)).toIso8601String(),
      'attempts': 1,
    });
    if (items.length > 40) items.removeRange(40, items.length);
    await prefs.setStringList(_key, items.map(jsonEncode).toList());
  }

  static Future<void> recordCorrect(String questionId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final items = raw
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .where((e) => e['id'] != questionId)
        .toList();
    await prefs.setStringList(_key, items.map(jsonEncode).toList());
  }

  static Future<List<Map<String, dynamic>>> getDueItems() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final now = DateTime.now();
    return raw
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .where((e) {
          final due = DateTime.tryParse(e['due'] as String? ?? '');
          return due == null || !due.isAfter(now);
        })
        .toList();
  }

  static Future<int> getQueueCount() async {
    final items = await getDueItems();
    return items.length;
  }
}
