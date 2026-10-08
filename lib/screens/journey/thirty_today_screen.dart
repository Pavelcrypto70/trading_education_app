import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class ThirtyTodayScreen extends StatelessWidget {
  const ThirtyTodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: '30 дней · реальный счёт',
      title: 'День 8 из 30',
      subtitle: 'Неделя 2 · риск ≤ 0.5% · сделок сегодня 0 / 2 · плечо ≤ 3x.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CalendarGrid(currentDay: 8, reported: {1, 2, 3, 4, 5, 6, 7}),
          const SizedBox(height: 16),
          TmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Фокус недели', style: TmKit.bodyMuted.copyWith(fontSize: 12)),
                const SizedBox(height: 4),
                const Text('Держать до цели, не двигать стоп от входа.'),
                const SizedBox(height: 12),
                Text('Разбор с ментором', style: TmKit.bodyMuted.copyWith(fontSize: 12)),
                const Text('Воскресенье · 18:00 МСК'),
              ],
            ),
          ),
        ],
      ),
      bottomBar: Column(
        children: [
          TmPrimaryButton(
            label: 'Отчёт за сегодня',
            onPressed: () => context.push('/30/report'),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TmGhostButton(
                  label: 'Стоп-день',
                  onPressed: () => context.push('/30/stop'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TmGhostButton(
                  label: '#first-30',
                  onPressed: () => context.push('/30/chat'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final int currentDay;
  final Set<int> reported;

  const _CalendarGrid({required this.currentDay, required this.reported});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: List.generate(30, (i) {
        final day = i + 1;
        Color bg = AppTheme.surface2;
        if (reported.contains(day)) bg = AppTheme.bullSoft;
        if (day == currentDay) bg = AppTheme.accentDim;
        return Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: day == currentDay ? AppTheme.accent : AppTheme.lineSoft,
            ),
          ),
          child: Text(
            '$day',
            style: TextStyle(
              fontWeight: day == currentDay ? FontWeight.w800 : FontWeight.w500,
              color: day == currentDay ? AppTheme.accent : AppTheme.text,
            ),
          ),
        );
      }),
    );
  }
}
