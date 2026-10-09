import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/lessons_repository.dart';
import '../models/lesson.dart';
import '../services/club_service.dart';
import '../services/gamification_service.dart';
import '../services/progress_service.dart';
import '../services/streak_service.dart';
import '../theme.dart';

/// Home tab: continue learning, quick actions, and the 6-stage roadmap.
class PathHubScreen extends StatefulWidget {
  const PathHubScreen({super.key});

  @override
  State<PathHubScreen> createState() => _PathHubScreenState();
}

class _PathHubScreenState extends State<PathHubScreen> {
  List<Lesson> _lessons = const [];
  Set<int> _completed = const {};
  StreakState? _streak;
  int _points = 0;
  int _stage1Tests = 0;
  int? _resumeStep;
  bool _loading = true;
  int? _expandedStage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final lessons = await LessonsRepository().loadLessons();
    final completed = await ProgressService.getCompletedLessons();
    final streak = await StreakService.load();
    final points = await GamificationService.getPoints();
    final celebrate = await ClubService.pendingCelebration();
    final modules = await ProgressService.getModuleResults();
    int? resumeStep;
    for (final l in lessons) {
      if (!completed.contains(l.id)) {
        final step = await ProgressService.getLessonStep(l.id);
        resumeStep = step > 0 ? step + 1 : null;
        break;
      }
    }
    if (!mounted) return;
    setState(() {
      _lessons = lessons;
      _completed = completed;
      _stage1Tests = ['spotfut', 'chart'].where(modules.containsKey).length;
      _resumeStep = resumeStep;
      _streak = streak;
      _points = points;
      _loading = false;
      _expandedStage ??= _currentStage;
    });
    final lit = StreakService.takePending();
    if (lit != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lit.message), behavior: SnackBarBehavior.floating),
      );
    }
    if (celebrate != null) {
      await context.push('/cutoff/${celebrate == ClubChat.pro ? 'pro' : 'students'}');
      if (mounted) _load();
    }
  }

  /// Stage 1 closes like the students cutoff: lessons 1–14 and both module tests.
  int get _currentStage {
    final stage1 = List.generate(ClubService.stage1Lessons, (i) => i + 1).every(_completed.contains) &&
        _stage1Tests == 2;
    if (!stage1) return 1;
    final done = _completed.length;
    const thresholds = [26, 40, 50, 56];
    for (var i = 0; i < thresholds.length; i++) {
      if (done < thresholds[i]) return i + 2;
    }
    return 6;
  }

  ({int number, Lesson lesson})? get _nextLesson {
    for (var i = 0; i < _lessons.length; i++) {
      if (!_completed.contains(_lessons[i].id)) {
        return (number: i + 1, lesson: _lessons[i]);
      }
    }
    return null;
  }

  Future<void> _push(String route) async {
    await context.push(route);
    if (mounted) _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: RefreshIndicator(
        onRefresh: _load,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _Header(
                    streak: _streak!,
                    points: _points,
                    onStreak: () => _push('/streak'),
                    onPoints: () => context.go('/club'),
                  ),
                ),
              ),
            ),
            if (!_streak!.litToday && _streak!.days > 0)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Material(
                    color: AppTheme.accentSoft,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      onTap: () => _push('/streak'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department_rounded, color: AppTheme.accent),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _streak!.freezes > 0
                                    ? 'Огонёк не зажжён · серия ${_streak!.days} дн. Заморозка спасёт день, но лучше пройти урок'
                                    : 'Серия ${_streak!.days} дн. сгорит в полночь — закончи урок или квиз',
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _ContinueCard(
                  next: _nextLesson,
                  resumeStep: _resumeStep,
                  done: _completed.length,
                  total: _lessons.length,
                  onContinue: (id) => _push('/lesson/$id'),
                  onAllLessons: () => context.go('/learning'),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _LadderCard(points: _points, onTap: () => context.go('/club')),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 28, 20, 12),
              sliver: SliverToBoxAdapter(child: _SectionTitle('Быстрые действия')),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(child: _QuickGrid(onOpen: _push)),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 4),
              sliver: SliverToBoxAdapter(
                child: _SectionTitle(
                  'Дорожная карта',
                  trailing: 'Ступень $_currentStage из 6',
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'От первого урока до своей сделки на реальном счёте. Нажми на ступень, чтобы увидеть шаги.',
                  style: TextStyle(color: AppTheme.muted, fontSize: 13, height: 1.45),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              sliver: SliverList.separated(
                itemCount: _stages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final stage = _stages[i];
                  final n = i + 1;
                  return _StageCard(
                    stage: stage,
                    number: n,
                    status: n < _currentStage
                        ? _StageStatus.done
                        : n == _currentStage
                            ? _StageStatus.current
                            : _StageStatus.upcoming,
                    expanded: _expandedStage == n,
                    onToggle: () => setState(
                      () => _expandedStage = _expandedStage == n ? null : n,
                    ),
                    onOpen: _push,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.streak,
    required this.points,
    required this.onStreak,
    required this.onPoints,
  });

  final StreakState streak;
  final int points;
  final VoidCallback onStreak;
  final VoidCallback onPoints;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 6
        ? 'Доброй ночи'
        : hour < 12
            ? 'Доброе утро'
            : hour < 18
                ? 'Добрый день'
                : 'Добрый вечер';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(color: AppTheme.muted, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text('Твой путь трейдера', style: AppTheme.display(26)),
            ],
          ),
        ),
        _StatPill(
          icon: Icons.local_fire_department_rounded,
          value: '${streak.days}',
          color: streak.litToday ? AppTheme.accent : AppTheme.muted,
          tooltip: streak.litToday ? 'Огонёк сегодня горит' : 'Огонёк сегодня не зажжён',
          onTap: onStreak,
        ),
        const SizedBox(width: 8),
        _StatPill(
          icon: Icons.emoji_events_rounded,
          value: ClubService.fmt(points),
          color: AppTheme.progress,
          tooltip: 'Очки · ладер клуба',
          onTap: onPoints,
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.value,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String value;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 5),
                Text(
                  value,
                  style: TextStyle(color: AppTheme.text, fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LadderCard extends StatelessWidget {
  const _LadderCard({required this.points, required this.onTap});

  final int points;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final league = GamificationService.leagueFor(points);
    final next = GamificationService.nextLeague(points);
    final p = next == null ? 1.0 : ((points - league.minPoints) / (next.minPoints - league.minPoints)).clamp(0.0, 1.0);
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: AppTheme.claySquare(league.color),
                child: const Icon(Icons.leaderboard_rounded, color: AppTheme.onPastel),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      next == null
                          ? 'Лига «${league.name}» · чат профи открыт'
                          : next.unlocks != null
                              ? 'До «${next.unlocks}» — ${ClubService.fmt(next.minPoints - points)} очков'
                              : 'До лиги «${next.name}» — ${ClubService.fmt(next.minPoints - points)} очков',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: p,
                        minHeight: 8,
                        backgroundColor: AppTheme.bg2,
                        color: AppTheme.progress,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded, color: AppTheme.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({
    required this.next,
    required this.resumeStep,
    required this.done,
    required this.total,
    required this.onContinue,
    required this.onAllLessons,
  });

  final ({int number, Lesson lesson})? next;
  final int? resumeStep;
  final int done;
  final int total;
  final ValueChanged<int> onContinue;
  final VoidCallback onAllLessons;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : done / total;
    final n = next;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.heroGradient(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        n == null
                            ? 'Курс пройден'
                            : resumeStep != null
                                ? 'Урок ${n.number} · ты на шаге $resumeStep'
                                : 'Следующий · урок ${n.number}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      n?.lesson.title ?? 'Все уроки пройдены',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.display(22, color: Colors.white),
                    ),
                    if (n != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        n.lesson.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13.5,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _Ring(progress: progress),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Пройдено $done из $total уроков',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.onPastel,
                    ),
                    onPressed: n == null ? onAllLessons : () => onContinue(n.lesson.id),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(n == null ? 'Повторить' : 'Продолжить'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                    ),
                    onPressed: onAllLessons,
                    child: const Text('Все уроки'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 68,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 68,
            height: 68,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 7,
              strokeCap: StrokeCap.round,
              color: AppTheme.progress,
              backgroundColor: Colors.white.withValues(alpha: 0.22),
            ),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, {this.trailing});

  final String text;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: AppTheme.display(20),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(color: AppTheme.accent, fontSize: 12.5, fontWeight: FontWeight.w700),
          ),
      ],
    );
  }
}

class _QuickGrid extends StatelessWidget {
  const _QuickGrid({required this.onOpen});

  final ValueChanged<String> onOpen;

  static const _items = [
    _Quick('Тесты модулей', 'Нужны для отсечки', Icons.fact_check_rounded, AppTheme.mint, '/module-quiz'),
    _Quick('Журнал', 'Записи и выводы', Icons.edit_note_rounded, AppTheme.sun, '/journal'),
    _Quick('Карточки', 'Повторение', Icons.style_rounded, AppTheme.pink, '/flashcards'),
    _Quick('Словарь', 'Термины', Icons.translate_rounded, AppTheme.sky, '/glossary'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, i) {
        final item = _items[i];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => onOpen(item.route),
            child: Ink(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppTheme.tintGradient(item.color),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: item.color.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: AppTheme.bg, size: 21),
                  ),
                  const Spacer(),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.text,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppTheme.muted, fontSize: 11.5),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Quick {
  const _Quick(this.title, this.subtitle, this.icon, this.color, this.route);

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;
}

enum _StageStatus { done, current, upcoming }

class _StageCard extends StatelessWidget {
  const _StageCard({
    required this.stage,
    required this.number,
    required this.status,
    required this.expanded,
    required this.onToggle,
    required this.onOpen,
  });

  final _Stage stage;
  final int number;
  final _StageStatus status;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.stageColor(number);
    final isCurrent = status == _StageStatus.current;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        gradient: isCurrent || expanded ? AppTheme.tintGradient(color) : null,
        color: isCurrent || expanded ? null : AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCurrent ? color : color.withValues(alpha: expanded ? 0.45 : 0.22),
          width: isCurrent ? 1.6 : 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: status == _StageStatus.upcoming ? color.withValues(alpha: 0.16) : color,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: status == _StageStatus.done
                          ? const Icon(Icons.check_rounded, color: AppTheme.bg, size: 24)
                          : Text(
                              '$number',
                              style: TextStyle(
                                color: status == _StageStatus.upcoming ? color : AppTheme.bg,
                                fontWeight: FontWeight.w800,
                                fontSize: 19,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                stage.title,
                                style: const TextStyle(
                                  color: AppTheme.text,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (isCurrent) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'Сейчас',
                                  style: TextStyle(
                                    color: AppTheme.bg,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          stage.description,
                          style: const TextStyle(color: AppTheme.muted, fontSize: 12.5, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.expand_more_rounded, color: color),
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Column(
                children: [
                  for (var i = 0; i < stage.steps.length; i++)
                    _StepRow(
                      step: stage.steps[i],
                      index: i + 1,
                      color: color,
                      isLast: i == stage.steps.length - 1,
                      onTap: () => onOpen(stage.steps[i].route),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.step,
    required this.index,
    required this.color,
    required this.isLast,
    required this.onTap,
  });

  final _Step step;
  final int index;
  final Color color;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 46,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.18),
                      border: Border.all(color: color.withValues(alpha: 0.7)),
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.only(top: 4),
                        color: color.withValues(alpha: 0.25),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: const TextStyle(
                        color: AppTheme.text,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step.subtitle,
                      style: const TextStyle(color: AppTheme.muted, fontSize: 12.5, height: 1.35),
                    ),
                  ],
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color.withValues(alpha: 0.8)),
          ],
        ),
      ),
    );
  }
}

class _Stage {
  const _Stage(this.title, this.description, this.steps);

  final String title;
  final String description;
  final List<_Step> steps;
}

class _Step {
  const _Step(this.title, this.subtitle, this.route);

  final String title;
  final String subtitle;
  final String route;
}

const _stages = [
  _Stage('Старт', 'Уроки 1–14, тесты модулей, первая домашка', [
    _Step('Уроки ступени 1', 'Спотовый и фьючерсный рынок по порядку', '/learning'),
    _Step('Тесты модулей', 'Спот/фьючерс и график · проходной 70%', '/module-quiz'),
    _Step('Первая домашка', 'Ответ уходит ментору · +100 очков', '/homework'),
    _Step('Сохрани прогресс', 'Аккаунт, чтобы не потерять уроки', '/auth'),
    _Step('Чат учеников', '1 400 очков + ступень 1 + 7 огоньков', '/club?tab=chats'),
  ]),
  _Stage('Читаю график', 'Свечи, уровни, тренд и разметка', [
    _Step('Уроки ступени 2', 'График, свечи и уровни', '/learning'),
    _Step('Разметка графика', 'Домашка с графиком на проверку', '/homework'),
    _Step('Огоньки и неделя', 'Серия, множитель и очки за 7 дней', '/streak'),
  ]),
  _Stage('Практика', 'Учебные сделки с планом, стопом и журналом', [
    _Step('Сделка по плану', 'Вход, стоп и цель до клика · +80 очков', '/practice'),
    _Step('Журнал сделок', 'Записи и выводы · +20 в день', '/journal'),
    _Step('Карточки', 'Повторение терминов', '/flashcards'),
  ]),
  _Stage('Диплом', 'Уроки, все тесты модулей, журнал и домашки', [
    _Step('Диплом', 'Проверка условий и выдача · +200 очков', '/certificate'),
    _Step('Чат профи', '6 900 очков + диплом + 8 сделок + 30 огоньков', '/club?tab=chats'),
  ]),
  _Stage('Реальный счёт', 'Первые 30 дней с ментором · после диплома', [
    _Step('Что внутри и как попасть', 'Риск-менеджер, счёт, 30 дней отчётов', '/stage/5'),
  ]),
  _Stage('Desk Trader', 'Выпуск и помощь новым ученикам', [
    _Step('Что внутри и как попасть', 'Выпуск и проверка домашек', '/stage/6'),
  ]),
];
