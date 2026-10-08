import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class FirstRealTradeScreen extends StatelessWidget {
  const FirstRealTradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const deposit = 150.0;
    const riskPct = 0.005;
    final riskUsd = deposit * riskPct;
    return TmScreen(
      stageLabel: 'Первая сделка',
      title: 'Калькулятор от депозита',
      subtitle: 'Биткоин · 3x isolated · маленькая сумма — цель первой недели.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmCard(
            accent: AppTheme.accent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Депозит $deposit USDT · риск 0.5%', style: TmKit.bodyMuted.copyWith(fontSize: 12)),
                Text('Риск ${riskUsd.toStringAsFixed(2)} USDT', style: TmKit.monoValue.copyWith(fontSize: 22)),
                const SizedBox(height: 12),
                _PlanRow('Вход', '62 600'),
                _PlanRow('Стоп', '61 600 (1.6%)'),
                _PlanRow('Позиция', '47 USDT'),
                const SizedBox(height: 8),
                Text(
                  '−${riskUsd.toStringAsFixed(2)} если стоп · +1.65 если тейк',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Порядок: план в приложении → стоп на бирже → вход → скрин или отчёт.',
            style: TmKit.bodyMuted,
          ),
        ],
      ),
      bottomBar: Column(
        children: [
          TmPrimaryButton(
            label: 'Скопировать план · открыть Tiger',
            onPressed: () => context.push('/30/today'),
          ),
          const SizedBox(height: 8),
          TmGhostButton(
            label: 'Отчёт за сегодня',
            onPressed: () => context.push('/30/report'),
          ),
        ],
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  final String k;
  final String v;

  const _PlanRow(this.k, this.v);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 72, child: Text(k, style: TmKit.bodyMuted)),
          Text(v, style: TmKit.monoValue.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}
