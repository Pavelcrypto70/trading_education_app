import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class MarkupGradeScreen extends StatelessWidget {
  const MarkupGradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Оценка домашки',
      title: '8 из 10 · принято',
      subtitle: 'Разметка №2 засчитана. Прогресс ворот: 2 / 3 разметки.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmCard(
            accent: AppTheme.bull,
            child: Column(
              children: [
                _RubricRow('Уровни зоной', '4 / 4'),
                _RubricRow('Вывод с графика', '3 / 4'),
                _RubricRow('Где идея ломается', '1 / 2'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const TmTeacherLine(
            message:
                'Хорошо выделил зону, не линию. На следующей разметке укажи точнее, при каком закрытии идея считается сломанной.',
          ),
        ],
      ),
      bottomBar: Column(
        children: [
          TmPrimaryButton(
            label: 'Дальше',
            onPressed: () => context.push('/weekly-report'),
          ),
          const SizedBox(height: 8),
          TmGhostButton(
            label: 'Открыть Desk Club',
            onPressed: () => context.go('/club'),
          ),
        ],
      ),
    );
  }
}

class _RubricRow extends StatelessWidget {
  final String label;
  final String score;

  const _RubricRow(this.label, this.score);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(score, style: TmKit.monoValue),
        ],
      ),
    );
  }
}
