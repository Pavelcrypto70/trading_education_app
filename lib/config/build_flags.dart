/// Compile-time flags for store-specific builds.
///
/// Billing is OFF by default — course is free; no IAP/paywall UI.
/// Soft Desk Club / Tiger recommend lives on web only (`DeskKeyConfig`).
///
/// Play:
///   flutter build appbundle --flavor play
///
/// Galaxy:
///   flutter build appbundle --flavor galaxy --dart-define=STORE_CHANNEL=galaxy
class BuildFlags {
  BuildFlags._();

  /// Always treat billing as off in product UI. Env kept for emergency override only.
  static const enableBilling = bool.fromEnvironment(
    'ENABLE_BILLING',
    defaultValue: false,
  );

  /// `play` | `galaxy` | `web` | …
  static const storeChannel = String.fromEnvironment(
    'STORE_CHANNEL',
    defaultValue: 'play',
  );

  /// All course lessons unlocked without purchase or Tiger key.
  static const courseFree = bool.fromEnvironment(
    'COURSE_FREE',
    defaultValue: true,
  );

  static bool get isGalaxyStore => storeChannel == 'galaxy' || !enableBilling;
}
