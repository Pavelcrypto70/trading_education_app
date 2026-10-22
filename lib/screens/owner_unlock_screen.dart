import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../services/entitlement_service.dart';
import '../services/locale_service.dart';
import '../theme.dart';

/// One-tap full unlock for the hardcoded owner email (review / QA).
class OwnerUnlockScreen extends StatefulWidget {
  const OwnerUnlockScreen({super.key});

  @override
  State<OwnerUnlockScreen> createState() => _OwnerUnlockScreenState();
}

class _OwnerUnlockScreenState extends State<OwnerUnlockScreen> {
  late String _status;

  @override
  void initState() {
    super.initState();
    _status = LocaleService.instance.strings.ownerUnlocking;
    _run();
  }

  Future<void> _run() async {
    final l10n = LocaleService.instance.strings;
    final result = await AuthService.signInLocalOwner('pavelcryptoclub@gmail.com');
    await EntitlementService.refresh();
    final ok = result == AuthResult.success && await EntitlementService.hasFullAccess();
    if (!mounted) return;
    if (!ok) {
      setState(() => _status = l10n.ownerUnlockFailed);
      return;
    }
    setState(() => _status = l10n.ownerUnlockDone);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (mounted) context.go('/learning');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(_status, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSoft, height: 1.4)),
            ],
          ),
        ),
      ),
    );
  }
}
