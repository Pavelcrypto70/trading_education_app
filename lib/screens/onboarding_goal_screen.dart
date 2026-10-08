import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/onboarding_service.dart';
import '../theme.dart';

class OnboardingGoalScreen extends StatefulWidget {
  const OnboardingGoalScreen({super.key});

  @override
  State<OnboardingGoalScreen> createState() => _OnboardingGoalScreenState();
}

class _OnboardingGoalScreenState extends State<OnboardingGoalScreen> {
  String? _goal;
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
      'Хочу проверить себя и выйти на свой процесс',
    ),
  ];

  static const _times = [15, 30, 45];

  Future<void> _continue() async {
    if (_goal == null) return;
    setState(() => _loading = true);
    await OnboardingService.saveGoal(_goal!);
    if (_goal == 'already_trading') {
      await OnboardingService.markCompleted();
      if (!mounted) return;
      context.go('/placement');
      return;
    }
    await OnboardingService.markCompleted();
    if (!mounted) return;
    context.go('/lesson/1');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final weeks = (_minutes == 15)
        ? '7–8'
        : (_minutes == 30)
            ? '5–6'
            : '4–5';

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Шаг 2 из 2',
                style: textTheme.labelLarge?.copyWith(color: AppTheme.faint),
              ),
              const SizedBox(height: 12),
              Text(
                'С чего ты начинаешь?',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.text,
                ),
              ),
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
              Text(
                'СКОЛЬКО ВРЕМЕНИ В ДЕНЬ',
                style: textTheme.labelLarge?.copyWith(color: AppTheme.faint),
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
                  border: Border.all(color: const Color(0xFF1F5566)),
                ),
                child: Text(
                  'При $_minutes минутах в день путь до реального счёта займёт около $weeks недель.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppTheme.text,
                    height: 1.4,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _goal == null || _loading ? null : _continue,
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Продолжить'),
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
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accentDim : AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
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
              child: selected
                  ? const Icon(Icons.circle, size: 8, color: AppTheme.onAccent)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.text,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.muted,
                      fontSize: 13.5,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppTheme.accentDim : AppTheme.surface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppTheme.accent : AppTheme.lineSoft,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppTheme.accent : AppTheme.text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
