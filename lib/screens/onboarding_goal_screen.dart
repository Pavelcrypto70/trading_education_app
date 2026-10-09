import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/club_service.dart';
import '../services/onboarding_service.dart';
import '../theme.dart';

class OnboardingGoalScreen extends StatefulWidget {
  const OnboardingGoalScreen({super.key});

  @override
  State<OnboardingGoalScreen> createState() => _OnboardingGoalScreenState();
}

class _OnboardingGoalScreenState extends State<OnboardingGoalScreen> {
  String _goal = 'from_zero';
  int _minutes = 30;
  bool _loading = false;

  static const _goals = [
    (
      'from_zero',
      'С нуля',
      'Никогда не торговал, хочу понять основы',
    ),
    (
      'lost_before',
      'Пробовал и слил',
      'Хочу систему и правила риска',
    ),
    (
      'already_trading',
      'Уже торгую',
      'Хочу проверить себя тестами модулей',
    ),
  ];

  static const _times = [15, 30, 45];

  /// About 10 minutes per lesson; cutoffs also need a 7- and 30-day streak.
  static const _minutesPerLesson = 10;
  static const _courseLessons = 58;

  Future<void> _continue() async {
    setState(() => _loading = true);
    await OnboardingService.saveGoal(_goal);
    await OnboardingService.markCompleted();
    if (!mounted) return;
    context.go(_goal == 'already_trading' ? '/module-quiz' : '/lesson/1');
  }

  @override
  Widget build(BuildContext context) {
    final perDay = (_minutes / _minutesPerLesson).clamp(1, 10);
    final studentsDays = (ClubService.stage1Lessons / perDay).ceil().clamp(ClubService.studentsStreak, 365);
    final proDays = (_courseLessons / perDay).ceil().clamp(ClubService.proStreak, 365);
    final proWeeks = (proDays / 7).ceil();

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Назад',
                    onPressed: () => context.go('/onboarding'),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const Text(
                    'Шаг 2 из 2',
                    style: TextStyle(color: AppTheme.faint, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('С чего ты начинаешь?', style: AppTheme.display(28)),
                    const SizedBox(height: 20),
                    for (final (id, title, sub) in _goals) ...[
                      _GoalOption(
                        title: title,
                        subtitle: sub,
                        selected: _goal == id,
                        onTap: () => setState(() => _goal = id),
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 12),
                    const Text(
                      'СКОЛЬКО ВРЕМЕНИ В ДЕНЬ',
                      style: TextStyle(color: AppTheme.faint, fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        for (final m in _times) ...[
                          Expanded(
                            child: _TimeChip(
                              label: '$m мин',
                              selected: _minutes == m,
                              onTap: () => setState(() => _minutes = m),
                            ),
                          ),
                          if (m != _times.last) const SizedBox(width: 8),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.accentDim,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.45)),
                      ),
                      child: Text(
                        'При $_minutes мин в день: чат учеников — примерно через $studentsDays дн., '
                        'диплом и чат профи — примерно через $proWeeks нед. '
                        'Быстрее не выйдет: для чатов нужна серия 7 и 30 дней.',
                        style: const TextStyle(color: AppTheme.text, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _continue,
                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_goal == 'already_trading' ? 'К тестам модулей' : 'Начать урок 1'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  const _GoalOption({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: title,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? AppTheme.accentDim : AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            border: Border.all(
              color: selected ? AppTheme.accent : AppTheme.lineSoft,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppTheme.accent : AppTheme.line,
                    width: 2,
                  ),
                  color: selected ? AppTheme.accent : Colors.transparent,
                ),
                child: selected ? const Icon(Icons.circle, size: 8, color: AppTheme.onAccent) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: AppTheme.text, fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppTheme.muted, fontSize: 13.5, height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppTheme.accentDim : AppTheme.surface2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? AppTheme.accent : AppTheme.lineSoft),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppTheme.accentText : AppTheme.text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
