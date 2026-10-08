import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class RealAccountChecklistScreen extends StatelessWidget {
  const RealAccountChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Реальный счёт',
      title: 'Чеклист ступени 5',
      subtitle: 'Кладёшь только сумму, потерю которой переживёшь · 30 дней стартуют после первой сделки.',
      body: Column(
        children: [
          _Step('Верификация личности (KYC)', done: true),
          _Step('Двухфакторная аутентификация (2FA)', done: true),
          _Step('Депозит 150 USDT', done: true),
          _Step('Isolated · плечо ≤ 3x', done: true),
          _Step('Риск-менеджер 2% в день', done: false, action: '/real/risk'),
          _Step('Команда Desk Club — заявка', done: false),
          _Step('Первая сделка по шаблону', done: false, action: '/real/first-trade'),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'Подтвердить риск-менеджер',
        onPressed: () => context.push('/real/risk'),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String title;
  final bool done;
  final String? action;

  const _Step(this.title, {required this.done, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TmCard(
        child: ListTile(
          leading: Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? AppTheme.bull : AppTheme.faint,
          ),
          title: Text(title),
          trailing: action != null && !done
              ? TextButton(
                  onPressed: () => context.push(action!),
                  child: const Text('Открыть'),
                )
              : null,
        ),
      ),
    );
  }
}
