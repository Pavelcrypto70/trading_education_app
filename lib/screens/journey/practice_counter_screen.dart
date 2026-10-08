import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class PracticeCounterScreen extends StatelessWidget {
  const PracticeCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Ступень 3 · Практика',
      title: 'Бумажный счёт',
      subtitle: 'Спотовый рынок и фьючерс на реплее. Ворота: 8 из 10 сделок по плану.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmCard(
            accent: AppTheme.accent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Учебный счёт', style: TmKit.bodyMuted.copyWith(fontSize: 12)),
                    Text('\$10 340', style: TmKit.monoValue.copyWith(fontSize: 24)),
                    Text('+3.4%', style: TextStyle(color: AppTheme.bull, fontWeight: FontWeight.w700)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('По плану', style: TmKit.bodyMuted.copyWith(fontSize: 12)),
                    Text('7 / 10', style: TmKit.monoValue.copyWith(fontSize: 20)),
                    Text('нужно 8 из 10', style: TmKit.bodyMuted.copyWith(fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Счётчик ворот', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const TmSegmentCounter(passed: 6, failed: 1),
          const SizedBox(height: 16),
          const TmMiniChart(),
          const SizedBox(height: 16),
          TmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Последние сделки', style: TmKit.bodyMuted.copyWith(fontSize: 12)),
                const SizedBox(height: 8),
                _DealRow('#8 BTCUSDT', '+2.2R', ok: true),
                _DealRow('#7 BTCUSDT', '+0.8R', ok: true),
                _DealRow('#6 ETHUSDT', '−1R', ok: false),
              ],
            ),
          ),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'Новая сделка по плану',
        icon: Icons.play_arrow,
        onPressed: () => context.push('/trade/plan'),
      ),
    );
  }
}

class _DealRow extends StatelessWidget {
  final String title;
  final String r;
  final bool ok;

  const _DealRow(this.title, this.r, {required this.ok});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(ok ? Icons.check_circle : Icons.cancel, size: 16, color: ok ? AppTheme.bull : AppTheme.bear),
          const SizedBox(width: 8),
          Expanded(child: Text(title)),
          Text(r, style: TextStyle(color: ok ? AppTheme.bull : AppTheme.bear, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
