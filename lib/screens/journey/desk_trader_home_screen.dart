import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class DeskTraderHomeScreen extends StatelessWidget {
  const DeskTraderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Desk Trader',
      title: 'Сегодня на пути',
      subtitle: 'Серия 47 дней без нарушений · не прибыль, а дисциплина.',
      showBack: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmCard(
            accent: AppTheme.accent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('План недели ментора', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                const Text('BTC: зона 61 800–62 200 · ждём реакцию'),
                const Text('Ср — CPI: риск вдвое меньше или пропусти день'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _Badge('30 д', done: true),
              _Badge('90 д', done: true),
              _Badge('180 д'),
            ],
          ),
          const SizedBox(height: 16),
          TmCard(
            child: ListTile(
              leading: const Icon(Icons.calendar_month, color: AppTheme.accent),
              title: const Text('Разбор месяца · журнал Tiger'),
              subtitle: const Text('1 ноя · без рейтинга по прибыли'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 8),
          TmCard(
            accent: AppTheme.warn,
            child: ListTile(
              leading: const Icon(Icons.rate_review, color: AppTheme.warn),
              title: const Text('Домашки ждут проверки'),
              subtitle: const Text('3 в очереди'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/desk/review'),
            ),
          ),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'Очередь проверки',
        onPressed: () => context.push('/desk/review'),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final bool done;

  const _Badge(this.label, {this.done = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: done ? AppTheme.bullSoft : AppTheme.surface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: done ? AppTheme.bull : AppTheme.lineSoft),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (done) const Icon(Icons.check, size: 14, color: AppTheme.bull),
          if (done) const SizedBox(width: 4),
          Text(label, style: TextStyle(fontWeight: FontWeight.w700, color: done ? AppTheme.bull : AppTheme.text)),
        ],
      ),
    );
  }
}
