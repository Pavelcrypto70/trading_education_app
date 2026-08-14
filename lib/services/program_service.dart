import 'package:shared_preferences/shared_preferences.dart';

/// 30-day learning program tracking.
class ProgramService {
  ProgramService._();

  static const _startKey = 'programStartDate';
  static const programDays = 30;

  static Future<DateTime> getStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_startKey);
    if (raw != null) {
      final parsed = DateTime.tryParse(raw);
      if (parsed != null) return parsed;
    }
    final now = DateTime.now();
    await prefs.setString(_startKey, now.toIso8601String());
    return now;
  }

  static Future<void> resetStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_startKey, DateTime.now().toIso8601String());
  }

  static Future<int> getCurrentDay() async {
    final start = await getStartDate();
    final days = DateTime.now().difference(start).inDays + 1;
    return days.clamp(1, programDays);
  }

  /// Expected lesson count by program day (linear pace).
  static int expectedLessonsByDay(int day, int totalLessons) {
    if (totalLessons <= 0) return 0;
    final d = day.clamp(1, programDays);
    return ((totalLessons / programDays) * d).ceil().clamp(1, totalLessons);
  }

  static bool isOnTrack(int completed, int day, int totalLessons) {
    return completed >= expectedLessonsByDay(day, totalLessons);
  }
}
