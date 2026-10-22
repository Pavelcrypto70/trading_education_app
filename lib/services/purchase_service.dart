/// Billing / IAP removed — course is free; Desk Club path is soft Tiger ref on web.
/// Stub kept so old imports compile; all methods are no-ops.
enum PurchaseResult {
  success,
  cancelled,
  notAvailable,
  notSignedIn,
  backendNotConfigured,
  error,
}

class PurchaseService {
  PurchaseService._();

  static bool get isStoreAvailable => false;

  static Future<void> initialize() async {}

  static Future<PurchaseResult> purchaseLifetime() async =>
      PurchaseResult.notAvailable;

  static Future<PurchaseResult> restorePurchases() async =>
      PurchaseResult.notAvailable;

  static Future<void> dispose() async {}
}
