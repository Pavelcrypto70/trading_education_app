/// Global product configuration: trial, admin, community, pricing.
///
/// Store variants: see [BuildFlags] (`play` with billing vs `galaxy` free).
class AppConfig {
  AppConfig._();

  /// Five trial lessons for the new linear start:
  /// 1–3 spot, 7 spot vs futures, 10 green/red candles.
  static const trialLessonIds = {1, 2, 3, 7, 10};

  /// Full admin access — all lessons, premium features, no paywall.
  /// Override via `--dart-define=ADMIN_EMAILS=a@x.com,b@y.com`.
  static Set<String> get adminEmails {
    const raw = String.fromEnvironment(
      'ADMIN_EMAILS',
      defaultValue: 'pavelcryptoclub@gmail.com',
    );
    return raw
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

  // ── Lifetime pricing: entry ~$10 for LATAM + global ──
  static const marketPriceUsd = 14.99;
  static const lifetimePriceUsd = 9.99;
  static const marketPriceRub = 1190;
  static const lifetimePriceRub = 790;
  static const marketPriceBrl = 39.90;
  static const lifetimePriceBrl = 29.90;
  /// Soft MXN labels for LATAM (IAP still resolves local currency in store).
  static const marketPriceMxn = 249.0;
  static const lifetimePriceMxn = 179.0;

  static const lifetimeProductId = 'trade_master_lifetime_full';

  static double get discountPercent =>
      ((marketPriceUsd - lifetimePriceUsd) / marketPriceUsd * 100).roundToDouble();
}
