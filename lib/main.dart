import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'services/analytics_service.dart';
import 'services/backend_service.dart';
import 'services/locale_service.dart';
import 'services/purchase_service.dart';
import 'services/sync_service.dart';
import 'services/auth_service.dart';
import 'services/premium_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('PlatformError: $error\n$stack');
    return true;
  };

  try {
    await LocaleService.instance.load();
  } catch (e, st) {
    debugPrint('LocaleService.load failed: $e\n$st');
  }

  try {
    await AnalyticsService.initialize();
  } catch (e, st) {
    debugPrint('AnalyticsService failed: $e\n$st');
  }

  try {
    await BackendService.initialize();
  } catch (e, st) {
    debugPrint('BackendService failed: $e\n$st');
  }

  try {
    await PurchaseService.initialize();
  } catch (e, st) {
    debugPrint('PurchaseService failed: $e\n$st');
  }

  if (BackendService.isAvailable) {
    AuthService.authStateChanges.listen((state) async {
      if (state.session != null) {
        await SyncService.pullAndMerge();
        await PremiumService.refreshFromServer();
      } else {
        await PremiumService.clear();
      }
    });
    if (AuthService.isSignedIn) {
      try {
        await SyncService.pullAndMerge();
      } catch (e, st) {
        debugPrint('SyncService failed: $e\n$st');
      }
    }
  }

  runApp(const TradeMasterApp());
}
