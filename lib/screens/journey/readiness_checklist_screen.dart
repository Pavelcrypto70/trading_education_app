import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class ReadinessChecklistScreen extends StatefulWidget {
  const ReadinessChecklistScreen({super.key});

  @override
  State<ReadinessChecklistScreen> createState() => _ReadinessChecklistScreenState();
}

class _ReadinessChecklistScreenState extends State<ReadinessChecklistScreen> {
  final _auto = [true, true, true, true];
  final _manual = [false, false, false];

  bool get _allDone => !_manual.contains(false);

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Ступень 4 · Рынок и риск',
      title: 'Чеклист готовности',
      subtitle: '7 из 7 — только тогда диплом и ступень 5.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Отмечено приложением', style: TmKit.bodyMuted.copyWith(fontSize: 12)),
          const SizedBox(height: 8),
          _CheckTile('10 бумажных сделок (8+ по плану)', _auto[0], locked: true),
          _CheckTile('Риск ≤ 1% и расчёт размера', _auto[1], locked: true),
          _CheckTile('Плечо, isolated, ликвидация', _auto[2], locked: true),
          _CheckTile('7 домашек ≥ 7/10', _auto[3], locked: true),
          const SizedBox(height: 16),
          Text('Подтверждаю сам', style: TmKit.bodyMuted.copyWith(fontSize: 12)),
          const SizedBox(height: 8),
          _CheckTile(
            'Кладу только сумму, потерю которой переживу',
            _manual[0],
            onChanged: (v) => setState(() => _manual[0] = v),
          ),
          _CheckTile(
            'Мне 18+ и это законно в моей стране',
            _manual[1],
            onChanged: (v) => setState(() => _manual[1] = v),
          ),
          _CheckTile(
            'Включу риск-менеджер с дневным лимитом',
            _manual[2],
            onChanged: (v) => setState(() => _manual[2] = v),
          ),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'Получить диплом',
        onPressed: _allDone ? () => context.push('/diploma') : null,
      ),
    );
  }
}

class _CheckTile extends StatelessWidget {
  final String label;
  final bool value;
  final bool locked;
  final ValueChanged<bool>? onChanged;

  const _CheckTile(this.label, this.value, {this.locked = false, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TmCard(
        child: CheckboxListTile(
          value: value,
          onChanged: locked ? null : (v) => onChanged?.call(v ?? false),
          title: Text(label, style: const TextStyle(fontSize: 14)),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: AppTheme.bull,
        ),
      ),
    );
  }
}
