import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class PathStage2Screen extends StatelessWidget {
  const PathStage2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Ступень 2 · Читаю график',
      title: 'Уровни, тренд и разметка',
      subtitle:
          'Модули «Уровни и тренд» и «Паттерны». Ворота: тесты модулей 3–4 ≥ 80% и три разметки ≥ 7/10.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmCard(
            accent: AppTheme.accent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Текущий модуль', style: TextStyle(color: AppTheme.faint, fontSize: 12)),
                const SizedBox(height: 4),
                const Text(
                  'Уровни и тренд · 6 / 13',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                ),
                const SizedBox(height: 8),
                Text('Сейчас: урок «Лестница вверх HH/HL»', style: TmKit.bodyMuted),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Ворота ступени', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              TmGateChip(label: 'Тест модуль 3 ≥ 80%', done: true),
              TmGateChip(label: 'Тест модуль 4', current: true),
              TmGateChip(label: 'Разметка №1 (урок 17)', done: true),
              TmGateChip(label: 'Разметка №2 (урок 22)', current: true),
              TmGateChip(label: 'Разметка №3 (урок 33)'),
            ],
          ),
          const SizedBox(height: 16),
          const TmMiniChart(),
          const SizedBox(height: 16),
          TmTeacherLine(
            message:
                'Разметка №2 — на биткоин, 4 часа. Отметь зону поддержки и точку, где идея ломается.',
          ),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'Сдать разметку',
        icon: Icons.draw_outlined,
        onPressed: () => context.push('/markup'),
      ),
    );
  }
}
