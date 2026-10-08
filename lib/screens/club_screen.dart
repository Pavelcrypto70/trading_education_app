import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';
import '../ui/tm_kit.dart';

class ClubScreen extends StatelessWidget {
  const ClubScreen({super.key});

  static const _week = [
    ('Пн', 'План недели ментора'),
    ('Вт', 'Урок недели'),
    ('Ср', 'Разбор домашек'),
    ('Чт', 'Q&A по счёту и верификации'),
    ('Пт', '—'),
    ('Сб', '—'),
    ('Вс', 'Разбор 30 дней'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(title: const Text('Desk Club')),
      body: ListView(
        padding: TmKit.screenPadding,
        children: [
          TmCard(
            accent: AppTheme.bull,
            child: Row(
              children: [
                const Icon(Icons.link, color: AppTheme.bull),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Telegram привязан', style: TextStyle(fontWeight: FontWeight.w800)),
                      Text('User ID синхронизирован с ботом', style: TmKit.bodyMuted.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TmCard(
            accent: AppTheme.accent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Для тебя сейчас', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 8),
                const Text('30 дней · отправь отчёт в #first-30 или заполни в приложении.'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.push('/30/report'),
                  child: const Text('Отчёт за сегодня'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Неделя клуба', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 10),
          ..._week.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TmCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 36,
                      child: Text(e.$1, style: TmKit.monoValue.copyWith(fontSize: 13)),
                    ),
                    Expanded(child: Text(e.$2)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Админы никогда не пишут первыми. Реферальная программа и ссылки брокера — только в каналах клуба.',
            style: TmKit.bodyMuted.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 16),
          TmGhostButton(
            label: 'Проверка домашек (Desk Trader)',
            onPressed: () => context.push('/desk/review'),
          ),
        ],
      ),
    );
  }
}
