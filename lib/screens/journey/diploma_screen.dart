import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class DiplomaScreen extends StatelessWidget {
  const DiplomaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Диплом',
      title: 'Трейдинг с нуля',
      subtitle: '58 уроков · экзамен 90% · спот, фьючерс, график.',
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: AppTheme.heroGradient(),
            child: Column(
              children: [
                const Icon(Icons.workspace_premium, color: AppTheme.accent, size: 48),
                const SizedBox(height: 12),
                const Text('Павел Т.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('ID TM-2026-08421', style: TmKit.monoValue.copyWith(fontSize: 13)),
                const SizedBox(height: 12),
                Text(
                  'Desk Club · обучение, не финансовый совет',
                  style: TmKit.bodyMuted.copyWith(fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TmGhostButton(label: 'Поделиться', onPressed: () {}),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'Открыта ступень 5 · реальный счёт',
        onPressed: () => context.push('/hub-admit'),
      ),
    );
  }
}
