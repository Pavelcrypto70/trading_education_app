import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class TradePlanScreen extends StatefulWidget {
  const TradePlanScreen({super.key});

  @override
  State<TradePlanScreen> createState() => _TradePlanScreenState();
}

class _TradePlanScreenState extends State<TradePlanScreen> {
  double _risk = 1.0;
  static const _entry = 62600.0;
  static const _stop = 61600.0;
  static const _take = 64800.0;

  @override
  Widget build(BuildContext context) {
    final riskUsd = 10000 * (_risk / 100);
    final reward = (_take - _entry) / (_entry - _stop) * riskUsd;
    return TmScreen(
      stageLabel: 'Сделка 8 из 10',
      title: 'План сделки',
      subtitle: 'Вход, стоп и тейк до открытия. Риск не больше 1% счёта.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TmMiniChart(),
          const SizedBox(height: 16),
          TmCard(
            child: Column(
              children: [
                _PlanRow('Вход', '62 600', 'после отскока от зоны'),
                _PlanRow('Стоп', '61 600', 'за поддержкой'),
                _PlanRow('Тейк', '64 800', 'перед сопротивлением'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Риск на сделку', style: TmKit.bodyMuted.copyWith(fontSize: 12)),
          Slider(
            value: _risk,
            min: 0.5,
            max: 1.0,
            divisions: 1,
            label: '${_risk.toStringAsFixed(1)}%',
            onChanged: (v) => setState(() => _risk = v),
          ),
          TmCard(
            accent: AppTheme.bull,
            child: Text(
              '−\$${riskUsd.toStringAsFixed(0)} если стоп · +\$${reward.toStringAsFixed(0)} если тейк · 1 : 2.2',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'Открыть по плану',
        onPressed: () => context.push('/trade/open'),
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  final String k;
  final String v;
  final String hint;

  const _PlanRow(this.k, this.v, this.hint);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 56, child: Text(k, style: TmKit.bodyMuted)),
          Text(v, style: TmKit.monoValue),
          const SizedBox(width: 8),
          Expanded(child: Text(hint, style: TmKit.bodyMuted.copyWith(fontSize: 11))),
        ],
      ),
    );
  }
}
