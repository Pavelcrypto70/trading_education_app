import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class GraduateScreen extends StatelessWidget {
  const GraduateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Выпуск',
      title: '30 дней пройдены',
      subtitle: 'Ты — Desk Trader. Итог +4.1R не влияет на выпуск — важны отчёты и дисциплина.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmCard(
            accent: AppTheme.accent,
            child: Column(
              children: [
                _StatRow('Отчётов', '22'),
                _StatRow('Нарушений', '1'),
                _StatRow('Итог', '+4.1R'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '· статус в клубе и в выпуске месяца\n'
            '· право проверять домашки ступеней 1–2\n'
            '· лимиты недели 4 остаются базой',
            style: TextStyle(height: 1.5),
          ),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'Открыть путь Desk Trader',
        onPressed: () => context.push('/desk'),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String k;
  final String v;

  const _StatRow(this.k, this.v);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: TmKit.bodyMuted),
          Text(v, style: TmKit.monoValue),
        ],
      ),
    );
  }
}
