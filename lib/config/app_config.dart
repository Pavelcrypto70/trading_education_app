/// Global product configuration: trial, admin, community, pricing.
///
/// Store variants: see [BuildFlags] (`play` with billing vs `galaxy` free).
class AppConfig {
  AppConfig._();

  /// Five trial lessons chosen for max conversion:
  /// 1–2 intro hook, 3 chart skill, 7 mistakes (trust), 10 first strategy (FOMO).
  static const trialLessonIds = {1, 2, 3, 7, 10};

  /// Full admin access — all lessons, premium features, no paywall.
  static const adminEmails = {
    'pavelcryptoclub@gmail.com',
  };

  /// Main EN community hub (Desk Club). Topics: general, academy, homework, etc.
  static const communityTelegramUrl = 'https://t.me/Desk_Club';
  static const communityTelegramHandle = '@Desk_Club';

  /// Homework: prefer Desk Club topic `homework`; legacy chat kept as fallback URL.
  static const homeworkTelegramUrl = 'https://t.me/Desk_Club';

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
