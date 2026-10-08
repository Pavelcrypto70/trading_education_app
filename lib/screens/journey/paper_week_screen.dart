import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../ui/tm_kit.dart';

class PaperWeekScreen extends StatelessWidget {
  const PaperWeekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Неделя на бумаге',
      title: 'Минус больше 30% депозита',
      subtitle: 'Не наказание — перезагрузка. Статус и прогресс 30 дней сохраняются, счётчик на паузе.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('3 шага до возврата', style: TextStyle(fontWeight: FontWeight.w800)),
                SizedBox(height: 8),
                Text('1. 5 бумажных сделок по плану на реплее'),
                Text('2. Разбор с ментором в Desk Club'),
                Text('3. Урок 53 «Усреднение и реванш»'),
                SizedBox(height: 8),
                Text('Возврат через 7 дней после выполнения.'),
              ],
            ),
          ),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'К бумажной практике',
        onPressed: () => context.push('/practice/gates'),
      ),
    );
  }
}
