import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';
import '../config/build_flags.dart';
import 'auth_service.dart';
import 'backend_service.dart';
import 'premium_service.dart';

enum PurchaseResult {
  success,
  cancelled,
  notAvailable,
  notSignedIn,
  backendNotConfigured,
  error,
}

/// Mobile: Google Play / App Store via in_app_purchase.
/// Web: Stripe Checkout via Supabase Edge Function.
///
/// Galaxy / free-store builds: compile with `--dart-define=ENABLE_BILLING=false`.
/// All payment APIs become no-ops; source below stays for Play/App Store builds.
class PurchaseService {
  PurchaseService._();

  static final InAppPurchase _iap = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static bool _storeAvailable = false;
  static Completer<PurchaseResult>? _pendingPurchase;

  static bool get isStoreAvailable =>
      BuildFlags.enableBilling && _storeAvailable && !kIsWeb;

  static Future<void> initialize() async {
    if (!BuildFlags.enableBilling) return;
    if (kIsWeb) return;

    _storeAvailable = await _iap.isAvailable();
    if (!_storeAvailable) return;

    _subscription ??= _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (_) => _completePending(PurchaseResult.error),
    );
  }

  static Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  static Future<PurchaseResult> purchaseLifetime() async {
    if (!BuildFlags.enableBilling) return PurchaseResult.notAvailable;
    if (!AuthService.isSignedIn) {
      return PurchaseResult.notSignedIn;
    }
    if (!BackendService.isAvailable) {
      return PurchaseResult.backendNotConfigured;
    }

    if (kIsWeb) {
      return _purchaseViaStripe();
    }

    if (!_storeAvailable) {
      return PurchaseResult.notAvailable;
    }

    final response = await _iap.queryProductDetails(
      {AppConfig.lifetimeProductId},
    );
    if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
      return PurchaseResult.notAvailable;
    }

    _pendingPurchase = Completer<PurchaseResult>();
    final product = response.productDetails.first;
    final param = PurchaseParam(productDetails: product);
    final started = await _iap.buyNonConsumable(purchaseParam: param);
    if (!started) {
      _pendingPurchase = null;
      return PurchaseResult.error;
    }
    return _pendingPurchase!.future.timeout(
      const Duration(minutes: 5),
      onTimeout: () {
        _pendingPurchase = null;
        return PurchaseResult.cancelled;
      },
    );
  }

  static Future<PurchaseResult> restorePurchases() async {
    if (!BuildFlags.enableBilling) return PurchaseResult.notAvailable;
    if (!AuthService.isSignedIn) return PurchaseResult.notSignedIn;
    if (!BackendService.isAvailable) return PurchaseResult.backendNotConfigured;

    if (kIsWeb) {
      await PremiumService.refreshFromServer();
      return (await PremiumService.isPremium())
          ? PurchaseResult.success
          : PurchaseResult.error;
    }

    if (!_storeAvailable) return PurchaseResult.notAvailable;

    _pendingPurchase = Completer<PurchaseResult>();
    await _iap.restorePurchases();
    return _pendingPurchase!.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        _pendingPurchase = null;
        return PurchaseResult.error;
      },
    );
  }

  static Future<PurchaseResult> _purchaseViaStripe() async {
    try {
      final response = await BackendService.client.functions.invoke(
        'stripe-checkout',
      );
      final data = response.data as Map<String, dynamic>?;
      final url = data?['url'] as String?;
      if (url == null) return PurchaseResult.notAvailable;
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return PurchaseResult.success;
      }
      return PurchaseResult.error;
    } catch (_) {
      return PurchaseResult.notAvailable;
    }
  }

  static Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) continue;

      if (purchase.status == PurchaseStatus.error) {
        _completePending(PurchaseResult.error);
        continue;
      }

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        final verified = await _verifyWithServer(purchase);
        if (verified) {
          await PremiumService.refreshFromServer();
          _completePending(PurchaseResult.success);
        } else {
          _completePending(PurchaseResult.error);
        }
      }

      if (purchase.status == PurchaseStatus.canceled) {
        _completePending(PurchaseResult.cancelled);
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  static Future<bool> _verifyWithServer(PurchaseDetails purchase) async {
    if (!BackendService.isAvailable || !AuthService.isSignedIn) return false;

    final platform = _platformName();
    final transactionId = purchase.purchaseID ??
        '${purchase.productID}_${DateTime.now().millisecondsSinceEpoch}';

    try {
      final response = await BackendService.client.functions.invoke(
        'verify-purchase',
        body: {
          'productId': purchase.productID,
          'platform': platform,
          'transactionId': transactionId,
          'receiptData': purchase.verificationData.serverVerificationData,
        },
      );
      final data = response.data as Map<String, dynamic>?;
      if (data?['ok'] == true) {
        await PremiumService.applyServerPremium(true);
        return true;
      }
    } catch (_) {}
    return false;
  }

  static String _platformName() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.android:
        return 'android';
      default:
        return 'unknown';
    }
  }

  static void _completePending(PurchaseResult result) {
    if (_pendingPurchase != null && !_pendingPurchase!.isCompleted) {
      _pendingPurchase!.complete(result);
    }
    _pendingPurchase = null;
  }
}
