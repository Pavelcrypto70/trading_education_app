import '../config/app_config.dart';
import 'auth_service.dart';
import 'premium_service.dart';

/// What the user can access: trial lessons, premium, or admin.
class EntitlementService {
  EntitlementService._();

  static Future<bool> hasFullAccess() async {
    if (await AuthService.isAdmin()) return true;
    return PremiumService.isPremium();
  }

  static Future<bool> isLessonUnlocked(int lessonId) async {
    if (await hasFullAccess()) return true;
    return AppConfig.trialLessonIds.contains(lessonId);
  }

  static Future<bool> isTrialLesson(int lessonId) async {
    return AppConfig.trialLessonIds.contains(lessonId);
  }

  static int get trialLessonCount => AppConfig.trialLessonIds.length;

  static Future<void> refresh() async {
    await PremiumService.refreshFromServer();
  }
}
