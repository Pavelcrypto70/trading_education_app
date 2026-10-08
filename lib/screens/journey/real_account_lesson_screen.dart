import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class RealAccountLessonScreen extends StatelessWidget {
  const RealAccountLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Урок 63 · модуль 8',
      title: 'Риск-менеджер Tiger',
      subtitle: 'Дневная просадка 2% от баланса на начало дня · USDⓈ-M Binance.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SettingRow('Тип лимита', 'От баланса на начало дня'),
                _SettingRow('Просадка', '2%'),
                _SettingRow('Рынок', 'USDⓈ-M Binance'),
                _SettingRow('Статус', 'Включён', highlight: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'При срабатывании торговля блокируется до следующего дня. Риск-менеджер не заменяет стоп на сделке.',
            style: TmKit.bodyMuted,
          ),
          const SizedBox(height: 16),
          TmCard(
            accent: AppTheme.warn,
            padding: const EdgeInsets.all(12),
            child: const Text(
              'Макет экрана Tiger.com Broker — deep link откроет раздел Risk manager.',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
      bottomBar: Column(
        children: [
          TmPrimaryButton(
            label: 'Открыть Risk manager на Tiger',
            icon: Icons.open_in_new,
            onPressed: () => context.push('/real/checklist'),
          ),
          const SizedBox(height: 8),
          TmGhostButton(
            label: 'Продолжить в приложении',
            onPressed: () => context.push('/real/checklist'),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String k;
  final String v;
  final bool highlight;

  const _SettingRow(this.k, this.v, {this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(k, style: TmKit.bodyMuted)),
          Text(
            v,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: highlight ? AppTheme.bull : AppTheme.text,
            ),
          ),
        ],
      ),
    );
  }
}
