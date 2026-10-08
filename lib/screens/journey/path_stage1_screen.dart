import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '_jwidgets.dart';

/// Journey screen 09 · Путь · ступень 1.
class PathStage1Screen extends StatelessWidget {
  const PathStage1Screen({super.key});

  static const _modules = [
    _ModuleInfo(
      title: 'Спотовый и фьючерсный рынок',
      lessons: 14,
      done: 4,
      current: true,
      testAtEnd: true,
    ),
    _ModuleInfo(
      title: 'График и свечи',
      lessons: 12,
      done: 0,
      locked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mod = _modules.first;
    return JourneyScaffold(
      stepLabel: 'Экран 09',
      title: 'Ступень 1 · Старт',
      subtitle: 'Модуль «${mod.title}»',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          TmProgressLine(
            value: mod.done / mod.lessons,
            label: '${mod.done} / ${mod.lessons} уроков',
          ),
          const SizedBox(height: 20),
          for (final lesson in _lessonRows(mod)) ...[
            _LessonTile(
              lesson: lesson,
              onTap: lesson.status == _LessonStatus.current
                  ? () => context.push('/lesson/${lesson.id}')
                  : lesson.status == _LessonStatus.done
                      ? () => context.push('/lesson/${lesson.id}')
                      : null,
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          _ModuleTestTile(
            enabled: mod.done >= 4,
            onTap: () => context.push('/hub-language'),
          ),
          const SizedBox(height: 16),
          for (final m in _modules.skip(1))
            Opacity(
              opacity: 0.55,
              child: TmCard(
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline, color: AppTheme.faint),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.title,
                            style: const TextStyle(
                              color: AppTheme.muted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Откроется после теста предыдущего модуля',
                            style: TextStyle(color: AppTheme.faint, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottom: TmPrimaryButton(
        label: 'Продолжить урок 5',
        onPressed: () => context.push('/lesson/5'),
      ),
    );
  }

  List<_LessonRow> _lessonRows(_ModuleInfo mod) {
    return List.generate(mod.lessons.clamp(0, 8), (i) {
      final id = i + 1;
      _LessonStatus status;
      if (id <= mod.done) {
        status = _LessonStatus.done;
      } else if (id == mod.done + 1) {
        status = _LessonStatus.current;
      } else {
        status = _LessonStatus.locked;
      }
      return _LessonRow(
        id: id,
        title: _lessonTitles[id - 1],
        minutes: 12,
        status: status,
      );
    });
  }

  static const _lessonTitles = [
    'Что такое свеча',
    'Спотовый рынок и биткоин',
    'Объём и ликвидность',
    'Первый жест на графике',
    'Тренд и откат',
    'Поддержка и сопротивление',
    'Ордер на покупку',
    'Итог недели',
  ];
}

enum _LessonStatus { done, current, locked }

class _LessonRow {
  const _LessonRow({
    required this.id,
    required this.title,
    required this.minutes,
    required this.status,
  });

  final int id;
  final String title;
  final int minutes;
  final _LessonStatus status;
}

class _ModuleInfo {
  const _ModuleInfo({
    required this.title,
    required this.lessons,
    required this.done,
    this.current = false,
    this.testAtEnd = false,
    this.locked = false,
  });

  final String title;
  final int lessons;
  final int done;
  final bool current;
  final bool testAtEnd;
  final bool locked;
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({required this.lesson, this.onTap});

  final _LessonRow lesson;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final status = lesson.status;
    Color border = AppTheme.lineSoft;
    Color bg = AppTheme.surface;
    Widget trailing;

    switch (status) {
      case _LessonStatus.done:
        border = AppTheme.bull.withValues(alpha: 0.4);
        trailing = const Icon(Icons.check_circle, color: AppTheme.bull, size: 22);
      case _LessonStatus.current:
        border = AppTheme.accent;
        bg = AppTheme.accentDim;
        trailing = Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.accent.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'Сейчас',
            style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w700, fontSize: 11),
          ),
        );
      case _LessonStatus.locked:
        trailing = const Icon(Icons.lock_outline, color: AppTheme.faint, size: 20);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: status == _LessonStatus.current ? 1.5 : 1),
          ),
          child: Row(
            children: [
              Text(
                '${lesson.id}',
                style: TextStyle(
                  color: status == _LessonStatus.locked ? AppTheme.faint : AppTheme.accent,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: TextStyle(
                        color: status == _LessonStatus.locked ? AppTheme.muted : AppTheme.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${lesson.minutes} мин',
                      style: const TextStyle(color: AppTheme.faint, fontSize: 12),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleTestTile extends StatelessWidget {
  const _ModuleTestTile({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(14),
          child: TmCard(
            accent: enabled,
            child: Row(
              children: [
                Icon(Icons.fact_check_outlined, color: enabled ? AppTheme.accent : AppTheme.faint),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Тест модуля',
                        style: TextStyle(color: AppTheme.text, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '8 вопросов · порог 80%',
                        style: TextStyle(color: AppTheme.muted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: enabled ? AppTheme.accent : AppTheme.faint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
