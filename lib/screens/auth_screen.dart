import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/backend_config.dart';
import '../services/analytics_service.dart';
import '../services/auth_service.dart';
import '../services/locale_service.dart';
import '../services/sync_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _loading = false;
  bool _otpSent = false;
  String _pendingEmail = '';

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!BackendConfig.isConfigured) {
      _showSnack(context.l10n.backendNotConfigured);
      return;
    }
    setState(() => _loading = true);
    final result = await AuthService.sendEmailOtp(_emailController.text);
    if (!mounted) return;
    setState(() => _loading = false);

    switch (result) {
      case AuthResult.otpSent:
        setState(() {
          _otpSent = true;
          _pendingEmail = _emailController.text.trim().toLowerCase();
        });
        _showSnack(context.l10n.otpSent);
      case AuthResult.invalidEmail:
        _showSnack(context.l10n.authInvalidEmail);
      case AuthResult.notConfigured:
        _showSnack(context.l10n.backendNotConfigured);
      default:
        _showSnack(context.l10n.authError);
    }
  }

  Future<void> _verifyOtp() async {
    setState(() => _loading = true);
    final result = await AuthService.verifyEmailOtp(
      email: _pendingEmail,
      token: _otpController.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);

    if (result == AuthResult.success) {
      AnalyticsService.signUp();
      await SyncService.pullAndMerge();
      if (await AuthService.isAdmin()) {
        if (!mounted) return;
        _showSnack(context.l10n.adminAccessGranted);
      }
      if (!mounted) return;
      context.pop(true);
      return;
    }
    _showSnack(context.l10n.authError);
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.signIn)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.signInSubtitle,
              style: const TextStyle(color: Colors.white70, height: 1.5),
            ),
            if (BackendConfig.isConfigured) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.cloud_done, color: Colors.greenAccent, size: 18),
                  const SizedBox(width: 8),
                  Text(l10n.syncActive, style: const TextStyle(color: Colors.greenAccent, fontSize: 13)),
                ],
              ),
            ],
            const SizedBox(height: 28),
            TextField(
              controller: _emailController,
              enabled: !_otpSent,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: l10n.email,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            if (_otpSent) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: l10n.enterOtpCode,
                  prefixIcon: const Icon(Icons.pin_outlined),
                  counterText: '',
                ),
              ),
            ],
            const SizedBox(height: 20),
            if (!_otpSent)
              ElevatedButton(
                onPressed: _loading ? null : _sendOtp,
                child: _loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.continueWithEmail),
              )
            else ...[
              ElevatedButton(
                onPressed: _loading ? null : _verifyOtp,
                child: _loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.verifyCode),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _loading
                    ? null
                    : () => setState(() {
                          _otpSent = false;
                          _otpController.clear();
                        }),
                child: Text(l10n.continueWithEmail),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
