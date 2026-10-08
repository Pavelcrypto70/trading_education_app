import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class TradeOpenScreen extends StatefulWidget {
  const TradeOpenScreen({super.key});

  @override
  State<TradeOpenScreen> createState() => _TradeOpenScreenState();
}

class _TradeOpenScreenState extends State<TradeOpenScreen> {
  double _progress = 0.35;
  double _pnl = 88;

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Реплей ×10',
      title: 'Сделка открыта',
      subtitle: 'BTCUSDT · long · стоп можно двигать только к безубытку.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmCard(
            accent: AppTheme.accent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Плавающий результат', style: TextStyle(color: AppTheme.faint, fontSize: 12)),
                    Text('+\$${_pnl.toStringAsFixed(0)}', style: TmKit.monoValue.copyWith(color: AppTheme.bull)),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: _progress, backgroundColor: AppTheme.surface3),
                const SizedBox(height: 8),
                Text('Реплей идёт… ~30 секунд', style: TmKit.bodyMuted.copyWith(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const TmMiniChart(),
          const SizedBox(height: 16),
          TmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Закрытие', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton(onPressed: () => context.push('/trade/review'), child: const Text('По тейку')),
                    OutlinedButton(onPressed: () => context.push('/trade/rejected'), child: const Text('По стопу')),
                    OutlinedButton(
                      onPressed: () => _showManualClose(context),
                      child: const Text('Закрыть сейчас'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'Тейк сработал · к разбору',
        onPressed: () => context.push('/trade/review'),
      ),
    );
  }

  void _showManualClose(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Идея сломалась?'),
        content: const Text('При ручном закрытии опиши причину в журнале.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.push('/trade/review');
            },
            child: const Text('Да, закрываю'),
          ),
        ],
      ),
    );
  }
}
