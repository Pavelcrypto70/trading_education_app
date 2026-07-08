import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/journal_entry.dart';

class JournalService {
  static const _entriesKey = 'tradeJournalEntries';

  static Future<List<JournalEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_entriesKey) ?? [];
    return raw
        .map((e) => JournalEntry.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static Future<void> saveEntry(JournalEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getEntries();
    entries.removeWhere((e) => e.id == entry.id);
    entries.insert(0, entry);
    final encoded = entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_entriesKey, encoded);
  }

  static Future<void> deleteEntry(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getEntries();
    entries.removeWhere((e) => e.id == id);
    await prefs.setStringList(
      _entriesKey,
      entries.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static Future<int> getCount() async {
    final entries = await getEntries();
    return entries.length;
  }
}
