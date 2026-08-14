import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/backend_config.dart';

/// Initializes Supabase when keys are provided via --dart-define.
class BackendService {
  BackendService._();

  static bool _initialized = false;

  static bool get isAvailable => BackendConfig.isConfigured && _initialized;

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    if (!BackendConfig.isConfigured) return;
    await Supabase.initialize(
      url: BackendConfig.supabaseUrl,
      anonKey: BackendConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
    _initialized = true;
  }
}
