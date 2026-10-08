import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class First30ChatScreen extends StatelessWidget {
  const First30ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: '#first-30 · Telegram',
      title: 'Канал отчётов',
      subtitle: 'Макет чата Desk Club Hub — твой отчёт и ответы ментора.',
      body: Column(
        children: [
          _Bubble(
            author: 'Ты',
            text: 'Day 8/30 · BTCUSDT · 1h\nPlan: entry 62 600 · stop 61 600 · risk 0.5%\nResult: take · +0.9R · By plan: yes',
            mine: true,
          ),
          _Bubble(
            author: 'Ментор',
            text: 'Хорошо держал стоп на бирже. Завтра следи за CPI — риск вдвое меньше или пропусти день.',
          ),
          _Bubble(
            author: 'Участник',
            text: 'Day 8/30 · сегодня не торговал — усталость.',
          ),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'К выпуску · Desk Trader',
        onPressed: () => context.push('/30/done'),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final String author;
  final String text;
  final bool mine;

  const _Bubble({required this.author, required this.text, this.mine = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: mine ? AppTheme.accentDim : AppTheme.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: mine ? AppTheme.accent.withValues(alpha: 0.4) : AppTheme.lineSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(author, style: TextStyle(fontSize: 11, color: AppTheme.faint, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(text, style: const TextStyle(fontSize: 13, height: 1.35)),
          ],
        ),
      ),
    );
  }
}
