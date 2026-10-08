import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '_jwidgets.dart';

/// Journey screen 03 · Быстрый путь — экзамен готовности.
class PlacementExamIntroScreen extends StatelessWidget {
  const PlacementExamIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return JourneyScaffold(
      stepLabel: 'Экран 03',
      title: 'Быстрый путь для опытных',
      subtitle:
          '20 вопросов по риску, стопу, плечу и плану сделки. Порог — 85%. Одна попытка в сутки.',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          TmCard(
            accent: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Что будет дальше',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 14),
                _OutcomeRow(
                  icon: Icons.check_circle_outline,
                  color: AppTheme.bull,
                  title: '≥ 85% — сдаёте экзамен',
                  subtitle:
                      'Сохраните прогресс, вступите в Academy и откройте ключ. Ступени 1–2 засчитаются автоматически.',
                ),
                const SizedBox(height: 12),
                _OutcomeRow(
                  icon: Icons.trending_flat,
                  color: AppTheme.warn,
                  title: 'Меньше 85% — обычный маршрут',
                  subtitle:
                      'Пройдёте спотовый рынок и график с нуля, без потери доступа к бесплатным урокам.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const TmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TmStatRow(
                  icon: Icons.quiz_outlined,
                  title: '20 вопросов',
                  subtitle: 'Без подсказок во время экзамена',
                ),
                SizedBox(height: 14),
                TmStatRow(
                  icon: Icons.percent,
                  title: 'Порог 85%',
                  subtitle: '17 правильных ответов для прохода',
                ),
                SizedBox(height: 14),
                TmStatRow(
                  icon: Icons.schedule,
                  title: '1 попытка в сутки',
                  subtitle: 'Перед результатом понадобится аккаунт',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Темы: риск на сделку, стоп-лосс, изолированное плечо, план до входа, биткоин на спотовом рынке.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      bottom: Column(
        children: [
          TmPrimaryButton(
            label: 'Начать экзамен',
            onPressed: () => context.push('/module-test'),
          ),
          TmGhostButton(
            label: 'Лучше пройду с начала',
            onPressed: () => context.go('/lesson/1'),
          ),
        ],
      ),
    );
  }
}

class _OutcomeRow extends StatelessWidget {
  const _OutcomeRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.text,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: AppTheme.muted, height: 1.4, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
