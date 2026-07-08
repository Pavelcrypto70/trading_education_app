import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _onboardingKey = 'onboardingCompleted';
  static const String _goalKey = 'userGoal';

  static Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingKey);
    await prefs.remove(_goalKey);
  }

  static Future<void> saveGoal(String goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_goalKey, goal);
  }

  static Future<String?> getGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_goalKey);
  }
}