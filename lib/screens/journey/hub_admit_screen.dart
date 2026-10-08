import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class HubAdmitScreen extends StatelessWidget {
  const HubAdmitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Допуск',
      title: 'Допуск в основной хаб',
      subtitle: 'Реферальная программа активна · ключ Desk Club · ступень 5 открыта.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmCard(
            accent: AppTheme.accent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Что дальше', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                const Text('· верификация личности и двухфакторная аутентификация'),
                const Text('· депозит только на сумму, которую готов потерять'),
                const Text('· риск-менеджер Tiger и команда Desk Club'),
                const Text('· 30 дней с отчётами в #first-30'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const TmTeacherLine(
            message: 'Деньги на счёте — твои. Мы видим только User ID и события риск-менеджера в команде.',
          ),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'Урок: риск-менеджер Tiger',
        onPressed: () => context.push('/real/lesson'),
      ),
    );
  }
}
