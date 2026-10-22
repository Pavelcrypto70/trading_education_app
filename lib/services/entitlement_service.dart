import '../config/app_config.dart';
import '../config/build_flags.dart';
import 'auth_service.dart';
import 'desk_key_service.dart';
import 'premium_service.dart';

/// Access layers:
/// - **Lessons** — free for everyone when [BuildFlags.courseFree] (default).
/// - **Club pro path** — Tiger ref verified (`DeskKeyService`) and/or paid premium;
///   unlocks mentorship / pro-chat privileges, not lesson JSON.
class EntitlementService {
  EntitlementService._();

  /// Legacy name: “full product privileges” (ref or paid), not lesson lock.
  static Future<bool> hasFullAccess() async {
    if (await AuthService.isAdmin()) return true;
    if (await DeskKeyService.isActive()) return true;
    return PremiumService.isPremium();
  }

  /// Verified Desk Club referral (web). Used for pro-chat / stage-5 path.
  static Future<bool> hasRefAccess() async {
    if (await AuthService.isAdmin()) return true;
    return DeskKeyService.isActive();
  }

  /// Paid lifetime / future pro subscription cache.
  static Future<bool> hasPaidAccess() async {
    if (await AuthService.isAdmin()) return true;
    return PremiumService.isPremium();
  }

  static Future<bool> isLessonUnlocked(int lessonId) async {
    if (BuildFlags.courseFree) return true;
    if (await hasFullAccess()) return true;
    return AppConfig.trialLessonIds.contains(lessonId);
  }

  static Future<bool> isTrialLesson(int lessonId) async {
    if (BuildFlags.courseFree) return false;
    return AppConfig.trialLessonIds.contains(lessonId);
  }

  static int get trialLessonCount =>
      BuildFlags.courseFree ? 58 : AppConfig.trialLessonIds.length;

  static Future<void> refresh() async {
    if (await AuthService.isAdmin()) {
      await PremiumService.applyServerPremium(true);
      return;
    }
    await PremiumService.refreshFromServer();
  }
}
