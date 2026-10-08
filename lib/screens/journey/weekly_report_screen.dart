import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../ui/tm_kit.dart';

class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Отчёт недели',
      title: 'Неделя 12 · ступень 2',
      subtitle: 'Краткий разбор прогресса перед практикой сделок по плану.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Сделано', style: TmKit.bodyMuted.copyWith(fontSize: 12)),
                const SizedBox(height: 8),
                const Text('· 4 урока «Уровни и тренд»'),
                const Text('· 2 разметки ≥ 7/10'),
                const Text('· тест модуля 3 — 86%'),
                const SizedBox(height: 12),
                Text('Фокус на следующей неделе', style: TmKit.bodyMuted.copyWith(fontSize: 12)),
                const SizedBox(height: 4),
                const Text('Закончить модуль 4 и сдать разметку №3 на биткоин 1h.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TmTeacherLine(
            name: 'Ментор',
            message:
                'Темп ровный. После третьей разметки откроется ступень 3 — бумажные сделки на реплее, счёт \$10 000.',
          ),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'К практике · сделка по плану',
        onPressed: () => context.push('/practice/gates'),
      ),
    );
  }
}
