import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class StopDayScreen extends StatelessWidget {
  const StopDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Стоп-день',
      title: 'Два стопа подряд',
      subtitle: 'На сегодня всё — так работают профессионалы. Торговля снова завтра.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmCard(
            accent: AppTheme.warn,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Сделки дня', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                _Deal('BTCUSDT', 'stop', '−0.5R'),
                _Deal('ETHUSDT', 'stop', '−0.5R'),
                const SizedBox(height: 8),
                Text(
                  'Минус ровно по плану — это контроль, не провал.',
                  style: TmKit.bodyMuted.copyWith(color: AppTheme.text),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'Записать отчёт стоп-дня',
        onPressed: () => context.push('/30/report'),
      ),
    );
  }
}

class _Deal extends StatelessWidget {
  final String pair;
  final String res;
  final String r;

  const _Deal(this.pair, this.res, this.r);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text('$pair · $res')),
          Text(r, style: const TextStyle(color: AppTheme.bear, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
