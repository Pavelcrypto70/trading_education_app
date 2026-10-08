import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class JournalListScreen extends StatelessWidget {
  const JournalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Журнал сделок',
      title: '8 сделок · 7 по плану',
      subtitle: 'Средний результат +0.9R. Стоп по плану — зелёная галочка.',
      body: Column(
        children: [
          TmCard(
            accent: AppTheme.accent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Stat('8', 'сделок'),
                _Stat('7', 'по плану'),
                _Stat('+0.9R', 'среднее'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _JournalTile('#8 BTCUSDT', '+2.2R', byPlan: true),
          _JournalTile('#7 ETHUSDT', '+0.8R', byPlan: true),
          _JournalTile('#6 BTCUSDT', '−1R', byPlan: true),
          _JournalTile('#4 SOLUSDT', '+0.5R', byPlan: false),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'К экзамену готовности',
        onPressed: () => context.push('/exam'),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String v;
  final String l;

  const _Stat(this.v, this.l);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(v, style: TmKit.monoValue.copyWith(fontSize: 18)),
        Text(l, style: TmKit.bodyMuted.copyWith(fontSize: 11)),
      ],
    );
  }
}

class _JournalTile extends StatelessWidget {
  final String title;
  final String r;
  final bool byPlan;

  const _JournalTile(this.title, this.r, {required this.byPlan});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TmCard(
        child: Row(
          children: [
            Icon(Icons.check_circle, color: byPlan ? AppTheme.bull : AppTheme.faint, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
            Text(r, style: TextStyle(color: byPlan ? AppTheme.bull : AppTheme.bear, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
