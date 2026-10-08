import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class TradeRejectedScreen extends StatelessWidget {
  const TradeRejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Сделка не засчитана',
      title: 'Сделка №4 не засчитана',
      subtitle: 'Результат не важен — важен план. Даже прибыль без стопа не идёт в ворота.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmCard(
            accent: AppTheme.bear,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Нарушено:', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                _FailRow('Стоп не был на бирже до входа'),
                _FailRow('Риск фактически > 1%'),
                const SizedBox(height: 8),
                Text('Красный сегмент в счётчике. Право на 2 ошибки в десяти сделках.',
                    style: TmKit.bodyMuted.copyWith(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
      bottomBar: Column(
        children: [
          TmPrimaryButton(
            label: 'Понял · новая сделка',
            onPressed: () => context.push('/trade/plan'),
          ),
          const SizedBox(height: 8),
          TmGhostButton(
            label: 'Повторить урок «Стоп сразу на бирже»',
            onPressed: () => context.push('/learning'),
          ),
        ],
      ),
    );
  }
}

class _FailRow extends StatelessWidget {
  final String text;

  const _FailRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.close, size: 16, color: AppTheme.bear),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
