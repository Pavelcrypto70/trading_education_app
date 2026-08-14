/// Compile-time flags for store-specific builds.
///
/// Play / full (default — billing ON):
///   flutter build appbundle --flavor play
///
/// Galaxy Store free (billing OFF, payment code not initialized):
///   flutter build appbundle --flavor galaxy --dart-define=ENABLE_BILLING=false --dart-define=STORE_CHANNEL=galaxy
class BuildFlags {
  BuildFlags._();

  /// When false: no IAP/Stripe init, no buy/restore UI, paywall → community.
  static const enableBilling = bool.fromEnvironment(
    'ENABLE_BILLING',
    defaultValue: true,
  );

  /// `play` | `galaxy` | `web` | …
  static const storeChannel = String.fromEnvironment(
    'STORE_CHANNEL',
    defaultValue: 'play',
  );

  static bool get isGalaxyStore => storeChannel == 'galaxy' || !enableBilling;
}
