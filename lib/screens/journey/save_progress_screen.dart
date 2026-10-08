import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '_jwidgets.dart';

/// Journey screen 08 · Сохрани прогресс (email + OTP).
class SaveProgressScreen extends StatefulWidget {
  const SaveProgressScreen({super.key});

  @override
  State<SaveProgressScreen> createState() => _SaveProgressScreenState();
}

class _SaveProgressScreenState extends State<SaveProgressScreen> {
  final _emailController = TextEditingController();
  bool _codeSent = false;
  bool _loading = false;
  String? _otp;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final email = _emailController.text.trim();
    if (!email.contains('@')) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _codeSent = true;
    });
  }

  Future<void> _confirm() async {
    if (_otp == null || _otp!.length < 6) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _loading = false);
    context.go('/path');
  }

  @override
  Widget build(BuildContext context) {
    return JourneyScaffold(
      stepLabel: 'Экран 08',
      title: 'Сохрани прогресс',
      subtitle:
          '3 урока пройдено. Аккаунт нужен, чтобы прогресс не пропал, а ментор видел ваши домашки.',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          TmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Электронная почта',
                    hintText: 'you@example.com',
                  ),
                  enabled: !_codeSent,
                ),
                if (!_codeSent) ...[
                  const SizedBox(height: 16),
                  TmPrimaryButton(
                    label: 'Отправить код',
                    loading: _loading,
                    onPressed: _sendCode,
                  ),
                ],
              ],
            ),
          ),
          if (_codeSent) ...[
            const SizedBox(height: 20),
            Text(
              'КОД ИЗ ПИСЬМА',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 12),
            OtpSixCells(onCompleted: (code) => setState(() => _otp = code)),
            const SizedBox(height: 12),
            Text(
              'Не пришло? Проверьте папку «Спам» или отправьте код снова через 45 секунд.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
      bottom: _codeSent
          ? TmPrimaryButton(
              label: 'Подтвердить',
              loading: _loading,
              onPressed: _otp != null && _otp!.length == 6 ? _confirm : null,
            )
          : null,
    );
  }
}
