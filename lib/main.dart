import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    await BackendService.initialize().timeout(const Duration(seconds: 5));
  } catch (e, st) {
    debugPrint('BackendService failed: $e\n$st');
  }

  try {
    await PurchaseService.initialize();
  } catch (e, st) {
    debugPrint('PurchaseService failed: $e\n$st');
  }

  // Never await network sync before first paint — DNS/auth refresh can hang web.
  if (BackendService.isAvailable) {
    AuthService.authStateChanges.listen((state) async {
      if (state.session != null) {
        unawaited(_safePull());
        unawaited(PremiumService.refreshFromServer());
      } else {
        unawaited(PremiumService.clear());
      }
    });
    unawaited(_warmupBackend());
  }

  runApp(const TradeMasterApp());
}

Future<void> _warmupBackend() async {
  try {
    await SyncService.pullAndMerge().timeout(const Duration(seconds: 6));
    BackendService.enableAutoRefresh();
  } catch (e, st) {
    debugPrint('Sync warmup failed (continuing offline): $e\n$st');
    await _quarantineDeadAuthSession();
  }
}

Future<void> _safePull() async {
  try {
    await SyncService.pullAndMerge().timeout(const Duration(seconds: 8));
  } catch (e, st) {
    debugPrint('SyncService failed: $e\n$st');
  }
}

/// Stops gotrue refresh storms when the Supabase host is NXDOMAIN / unreachable.
Future<void> _quarantineDeadAuthSession() async {
  if (!BackendService.isAvailable) return;
  try {
    final auth = BackendService.client.auth;
    auth.stopAutoRefresh();
    await auth.signOut(scope: SignOutScope.local);
    debugPrint('Cleared local auth session after backend unreachable');
  } catch (e, st) {
    debugPrint('Auth quarantine failed: $e\n$st');
  }
}
