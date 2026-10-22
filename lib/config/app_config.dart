/// Global product configuration: trial badges, admin, community.
///
/// Course is free. Store variants: see [BuildFlags].
class AppConfig {
  AppConfig._();

  /// Legacy trial set (UI badges). With COURSE_FREE all lessons are open.
  static const trialLessonIds = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14};

  /// Full admin access — all lessons / club tools.
  /// Override via `--dart-define=ADMIN_EMAILS=a@x.com,b@y.com`.
  /// Empty define (common in dart_defines.json) must not wipe the owner account.
  static const _defaultAdminEmails = 'pavelcryptoclub@gmail.com';

  static Set<String> get adminEmails {
    const raw = String.fromEnvironment(
      'ADMIN_EMAILS',
      defaultValue: _defaultAdminEmails,
    );
    final parsed = raw
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toSet();
    if (parsed.isNotEmpty) return parsed;
    return _defaultAdminEmails
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toSet();
  }

  /// Main community hub (Desk Club forum).
  static const communityTelegramUrl = 'https://t.me/Desk_Club';
  static const communityTelegramHandle = '@Desk_Club';

  /// Forum topic 📝 homework / Домашки.
  /// Public topic link is https://t.me/Desk_Club/<threadId>.
  /// Empty thread id → open the hub; the homework template names the topic.
  static const homeworkTopicId = String.fromEnvironment('HW_TOPIC_ID');
  static const homeworkTopicName = 'homework';

  static String get homeworkTelegramUrl {
    final id = homeworkTopicId.trim();
    if (id.isEmpty) return communityTelegramUrl;
    return '$communityTelegramUrl/$id';
  }

  // Course is free — no IAP product / price list in the app.
}
