import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/lessons_repository.dart';
import '../models/lesson.dart';
import '../models/lesson_section.dart';
import '../services/gamification_service.dart';
import '../services/entitlement_service.dart';
import '../l10n/app_localizations.dart';
import '../services/locale_service.dart';
import '../services/club_service.dart';
import '../services/progress_service.dart';
import '../services/sim_mode.dart';
import '../services/streak_service.dart';
import '../widgets/lesson_paywall_sheet.dart';
import '../theme.dart';
import '../utils/chart_visual_context.dart';
import '../utils/crypto_lesson_context.dart';
import '../widgets/lesson_chart_card.dart';
import '../widgets/lesson_rich_text.dart';
import '../widgets/lesson_checkpoint.dart';
import '../widgets/lesson_practice_cards.dart';
import '../widgets/course_lesson_steps.dart';
import '../utils/num_format.dart';

class LessonScreen extends StatefulWidget {
  final Lesson? lesson;
  final int? lessonId;

  const LessonScreen({super.key, this.lesson, this.lessonId});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final _repository = LessonsRepository();
  late PageController _pageController;
  Lesson? _lesson;
  CryptoLessonContext? _crypto;
  bool _completed = false;
  bool _loading = true;
  bool _checkpointPassed = false;
  int _step = 0;
  List<_LessonStep> _steps = [];
  final Set<int> _answeredChoiceSteps = {};

  bool get _currentRequiresAnswer {
    if (_step < 0 || _step >= _steps.length) return false;
    return _steps[_step].requiresAnswer;
  }

  bool get _canGoNext {
    if (!_currentRequiresAnswer) return true;
    return _answeredChoiceSteps.contains(_step);
  }

  void _leaveLesson() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/learning');
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _init();
  }

  @override
  void didUpdateWidget(LessonScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lessonId != widget.lessonId ||
        oldWidget.lesson?.id != widget.lesson?.id) {
      _pageController.dispose();
      _pageController = PageController();
      setState(() {
        _step = 0;
        _completed = false;
        _checkpointPassed = false;
        _loading = true;
        _answeredChoiceSteps.clear();
      });
      _init();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    Lesson? lesson = widget.lesson;
    if (lesson == null && widget.lessonId != null) {
      lesson = await _repository.getLessonById(widget.lessonId!);
    }
    if (lesson != null) {
      final unlocked = await EntitlementService.isLessonUnlocked(lesson.id);
      if (!unlocked && mounted) {
        final ok = await showLessonPaywallIfNeeded(context, lesson.id, leave: () {
          if (mounted) _leaveLesson();
        });
        if (!ok) return;
      }
    }
    final completed = lesson != null
        ? await ProgressService.isLessonComplete(lesson.id)
        : false;
    var resumeStep = 0;
    if (lesson != null && !completed) {
      resumeStep = await ProgressService.getLessonStep(lesson.id);
    }
    if (!mounted) return;
    final steps = lesson != null ? _buildSteps(lesson) : <_LessonStep>[];
    if (resumeStep >= steps.length) resumeStep = 0;
    // Questions before the saved step were answered last time.
    for (var i = 0; i < resumeStep; i++) {
      if (steps[i].requiresAnswer) _answeredChoiceSteps.add(i);
    }
    _pageController.dispose();
    _pageController = PageController(initialPage: resumeStep);
    setState(() {
      _lesson = lesson;
      _crypto = lesson != null ? CryptoLessonContext.forLesson(lesson) : null;
      _completed = completed;
      _checkpointPassed = completed;
      _steps = steps;
      _step = resumeStep;
      _loading = false;
    });
    if (resumeStep > 0 && mounted) {
      final stepLabel = resumeStep + 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.resumeLessonStep(stepLabel)),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).size.height - 160,
            ),
          ),
        );
      });
    }
  }

  /// Prefer animated pattern diagram when present; else first chart; else generic candle.
  String _bestVisualChartType(Lesson lesson, String primary) {
    String? first;
    for (final s in lesson.sections) {
      if (s.type != 'chart' || s.chartType == null) continue;
      final t = s.chartType!;
      first ??= t;
      if (t.startsWith('pattern_') ||
          t == 'ascending_triangle' ||
          t == 'descending_triangle' ||
          t == 'symmetric_triangle' ||
          t == 'head_shoulders' ||
          t == 'inverse_head_shoulders' ||
          t == 'fibonacci' ||
          t == 'channel' ||
          t == 'order_flow' ||
          t == 'order_book' ||
          t.startsWith('order_book_')) {
        return t;
      }
    }
    if (first != null) return first;
    if (primary.isNotEmpty) return primary;
    return 'candlestick';
  }

  static String _norm(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'[^a-zа-яё0-9]+'), ' ').trim();

  /// Rebuilt course: pages exactly as authored, in order, no generated filler.
  List<_LessonStep> _buildCourseSteps(Lesson lesson) {
    void answered(int index) {
      if (!_answeredChoiceSteps.contains(index)) {
        setState(() => _answeredChoiceSteps.add(index));
      }
    }

    final steps = <_LessonStep>[
      _LessonStep(icon: Icons.flag_outlined, builder: (ctx, l10n) => CourseIntroStep(lesson: lesson)),
    ];
    var rememberAdded = false;
    void addRemember() {
      if (rememberAdded || lesson.takeaway.trim().isEmpty) return;
      rememberAdded = true;
      steps.add(_LessonStep(
        icon: Icons.lightbulb_outline,
        builder: (ctx, l10n) => CourseRememberStep(lesson: lesson),
      ));
    }

    for (final s in lesson.sections) {
      switch (s.type) {
        case 'step':
          steps.add(_LessonStep(icon: Icons.menu_book_outlined, builder: (ctx, l10n) => CourseTextStep(section: s)));
        case 'choice':
          final index = steps.length;
          steps.add(_LessonStep(
            icon: Icons.touch_app_outlined,
            requiresAnswer: true,
            builder: (ctx, l10n) => CourseChoiceStep(section: s, onAnswered: () => answered(index)),
          ));
        case 'practice':
          addRemember();
          steps.add(_LessonStep(
            icon: Icons.candlestick_chart_outlined,
            builder: (ctx, l10n) => CoursePracticeStep(lesson: lesson, section: s),
          ));
        case 'homework':
          addRemember();
          steps.add(_LessonStep(
            icon: Icons.assignment_outlined,
            builder: (ctx, l10n) => LessonHomeworkCard(lesson: lesson, section: s),
          ));
        default:
          break;
      }
    }
    addRemember();
    steps.add(_LessonStep(
      icon: Icons.quiz_outlined,
      builder: (ctx, l10n) => LessonCheckpoint(
        lesson: lesson,
        onPassed: () async {
          setState(() => _checkpointPassed = true);
          await GamificationService.award(PointsReason.lessonQuiz, uniqueKey: 'lq-${lesson.id}');
          await _completeLesson();
        },
        onReview: () => _pageController.jumpToPage(lesson.sections.isEmpty ? 0 : 1),
      ),
    ));
    return steps;
  }

  List<_LessonStep> _buildSteps(Lesson lesson) {
    if (lesson.isCourseV2) return _buildCourseSteps(lesson);
    final crypto = CryptoLessonContext.forLesson(lesson);
    final primaryChart = crypto.primaryChartType;
    final visualType = _bestVisualChartType(lesson, primaryChart);
    final steps = <_LessonStep>[
      _LessonStep(
        icon: Icons.flag_outlined,
        builder: (ctx, l10n) => _IntroStep(
          lesson: lesson,
          crypto: crypto,
          chartType: visualType,
          cardIndex: 100,
        ),
      ),
    ];

    // Always show the step chart. cardIndex picks a different setup per step —
    // skipping «same chartType» left most lesson pages blank after the intro.
    String? chartIfNew(String t) => t;

    final seenTexts = <String>[_norm(lesson.subtitle)];
    bool isRepeat(String text) {
      final n = _norm(text);
      if (n.length < 12) return false;
      return seenTexts.any((s) => s == n || (s.length >= 12 && (s.contains(n) || n.contains(s))));
    }

    void addAnswered(int index) {
      if (!_answeredChoiceSteps.contains(index)) {
        setState(() => _answeredChoiceSteps.add(index));
      }
    }

    ({String? heading, String question})? pendingCompare;
    void addCompare(String answer) {
      final c = pendingCompare!;
      pendingCompare = null;
      final stepIndex = steps.length;
      steps.add(_LessonStep(
        icon: Icons.compare_arrows_rounded,
        requiresAnswer: true,
        builder: (ctx, l10n) => _CompareStep(
          heading: c.heading,
          question: c.question,
          answer: answer,
          onRevealed: () => addAnswered(stepIndex),
        ),
      ));
    }

    String? pendingHeading;
    var fallbackCard = 1;

    for (final s in lesson.sections) {
      switch (s.type) {
        case 'heading':
          pendingHeading = s.title;
          break;
        case 'text':
          final cardIndex = s.cardIndex ?? fallbackCard++;
          final heading = pendingHeading;
          pendingHeading = null;
          final text = (s.body ?? '').trim();
          if (text.isEmpty || isRepeat(text)) break;
          seenTexts.add(_norm(text));
          if (text.endsWith('?') && pendingCompare == null) {
            pendingCompare = (heading: heading, question: text);
            break;
          }
          if (pendingCompare != null) {
            addCompare(text);
            break;
          }
          final chartType = chartIfNew(s.chartType ?? visualType);
          steps.add(_LessonStep(
            icon: Icons.menu_book_outlined,
            builder: (ctx, l10n) => _TextCardStep(
              heading: heading,
              text: text,
              lesson: lesson,
              crypto: crypto,
              chartType: chartType,
              cardIndex: cardIndex,
              caption: s.caption,
            ),
          ));
          break;
        case 'choice':
          if (pendingCompare != null) addCompare(lesson.takeaway);
          final cardIndex = s.cardIndex ?? fallbackCard++;
          final chartType = chartIfNew(s.chartType ?? visualType);
          final section = s;
          final choiceStepIndex = steps.length;
          steps.add(_LessonStep(
            icon: Icons.touch_app_outlined,
            requiresAnswer: true,
            builder: (ctx, l10n) => _ChoiceCardStep(
              section: section,
              lesson: lesson,
              crypto: crypto,
              chartType: chartType,
              cardIndex: cardIndex,
              onAnswered: () => addAnswered(choiceStepIndex),
            ),
          ));
          break;
        case 'homework':
        case 'journal':
        case 'practice':
        case 'market_note':
        case 'calculator':
        case 'link':
          if (pendingCompare != null) addCompare(lesson.takeaway);
          final section = s;
          final cardIndex = s.cardIndex ?? fallbackCard++;
          final chartType = chartIfNew(s.chartType ?? visualType);
          steps.add(_LessonStep(
            icon: switch (s.type) {
              'homework' => Icons.assignment_outlined,
              'journal' => Icons.edit_note,
              'practice' => Icons.fitness_center,
              _ => Icons.extension_outlined,
            },
            builder: (ctx, l10n) => _InteractiveWithChartStep(
              lesson: lesson,
              section: section,
              crypto: crypto,
              chartType: chartType,
              cardIndex: cardIndex,
            ),
          ));
          break;
        case 'references':
          if (lesson.references.isEmpty) break;
          steps.add(_LessonStep(
            icon: Icons.menu_book_outlined,
            builder: (ctx, l10n) => _ReferencesStep(lesson: lesson),
          ));
          break;
        default:
          break;
      }
    }
    if (pendingCompare != null) addCompare(lesson.takeaway);

    final hasHomework = lesson.sections.any((s) => s.type == 'homework');
    if (!hasHomework) {
      steps.add(_LessonStep(
        icon: Icons.assignment_outlined,
        builder: (ctx, l10n) => LessonHomeworkStep(lesson: lesson),
      ));
    }

    steps.add(_LessonStep(
      icon: Icons.quiz_outlined,
      builder: (ctx, l10n) => LessonCheckpoint(
        lesson: lesson,
        onPassed: () async {
          setState(() => _checkpointPassed = true);
          await GamificationService.award(PointsReason.lessonQuiz, uniqueKey: 'lq-${lesson.id}');
          await _completeLesson();
        },
        onReview: () => _pageController.jumpToPage(0),
      ),
    ));

    return steps;
  }

  void _nextStep() {
    if (!_canGoNext) return;
    if (_step < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _prevStep() {
    if (_step > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _onStepChanged(int i) async {
    setState(() => _step = i);
    final lesson = _lesson;
    if (lesson == null || _completed) return;
    await ProgressService.saveLessonStep(lesson.id, i);
  }

  Future<void> _completeLesson() async {
    if (_lesson == null || _completed) return;
    if (!_checkpointPassed) return;

    await ProgressService.markLessonComplete(_lesson!.id);
    final lit = await StreakService.light();
    StreakService.takePending();
    final award = await GamificationService.award(PointsReason.lesson, uniqueKey: 'lesson-${_lesson!.id}');
    final streak = await StreakService.load();
    if (!mounted) return;

    setState(() => _completed = true);
    final next = GamificationService.nextLeague(award.total);
    final mult = award.multiplier;
    final l10n = context.l10n;
    final multStr = LocaleService.instance.language == AppLanguage.ru
        ? mult.toStringAsFixed(1).replaceAll('.', ',')
        : mult.toStringAsFixed(1);
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: AppTheme.claySquare(AppTheme.accent),
              child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            Text(l10n.lessonPassedShort, style: AppTheme.display(24)),
            const SizedBox(height: 10),
            Text(
              award.isZero
                  ? l10n.pointsAlreadyAwarded
                  : '+${award.awarded} ${pointsWord(award.awarded)}',
              style: AppTheme.display(30, color: AppTheme.progress),
            ),
            if (lit != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(lit.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppTheme.accentText, fontWeight: FontWeight.w700)),
              )
            else if (mult > 1)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l10n.streakPointsMult(streak.days, multStr),
                  style: const TextStyle(color: AppTheme.accentText, fontWeight: FontWeight.w700),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              next == null
                  ? l10n.totalPointsProLeague(
                      ClubService.fmt(award.total),
                      pointsWord(award.total),
                    )
                  : l10n.totalPointsToLeague(
                      ClubService.fmt(award.total),
                      pointsWord(award.total),
                      l10n.leagueName(next.name),
                      ClubService.fmt(next.minPoints - award.total),
                    ),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.muted, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.next)),
        ],
      ),
    );
  }

  Future<void> _goNextLesson() async {
    if (_lesson == null) return;
    final currentId = _lesson!.id;
    final next = await _repository.getNextLesson(currentId);
    if (!mounted) return;
    if (next != null) {
      context.go('/lesson/${next.id}', extra: next);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_lesson == null || _steps.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.lessonNotFound)),
      );
    }

    final lesson = _lesson!;
    final isLast = _step == _steps.length - 1;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          tooltip: l10n.backToLearning,
          onPressed: _leaveLesson,
        ),
        title: Text(
          '${l10n.lessonNumber(lesson.id)} · ${l10n.stepOf(_step + 1, _steps.length)}',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.muted),
        ),
        actions: [
          // «Торговая пара» is explained in lesson 2.
          if (_crypto != null && lesson.id >= 2)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.surface2,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    lesson.pair ?? _crypto!.pair,
                    style: const TextStyle(fontSize: 11, color: AppTheme.textSoft, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: AppTheme.display(22),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (_step + 1) / _steps.length,
                    minHeight: 8,
                    backgroundColor: AppTheme.surface2,
                    color: AppTheme.progress,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: _onStepChanged,
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _steps[index].builder(context, l10n),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
            ),
            child: Column(
              children: [
                if (isLast && _checkpointPassed && !_completed)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _completeLesson,
                      child: Text(l10n.markComplete),
                    ),
                  )
                else if (isLast && _completed) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _goNextLesson,
                      child: Text(l10n.nextLesson),
                    ),
                  ),
                  if (lesson.id >= SimMode.firstOpenLesson) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.go('/practice?returnLesson=${lesson.id}'),
                        child: Text(l10n.practiceAfterLesson),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => context.go('/learning'),
                      child: Text(l10n.backToLearningLessonsList),
                    ),
                  ),
                ] else if (!isLast || _checkpointPassed)
                  Column(
                    children: [
                      if (_currentRequiresAnswer && !_canGoNext)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            l10n.findCorrectToContinue,
                            style: TextStyle(
                              color: AppTheme.warn.withValues(alpha: 0.95),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          if (_step > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _prevStep,
                                child: Text(l10n.back),
                              ),
                            ),
                          if (_step > 0) const SizedBox(width: 12),
                          if (!isLast)
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: _canGoNext ? _nextStep : null,
                                child: Text(l10n.next),
                              ),
                            ),
                        ],
                      ),
                    ],
                  )
                else
                  // Checkpoint step: only one back — avoid duplicate «Назад».
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _prevStep,
                      child: Text(l10n.back),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonStep {
  final IconData icon;
  final Widget Function(BuildContext, AppLocalizations) builder;
  final bool requiresAnswer;

  const _LessonStep({
    required this.icon,
    required this.builder,
    this.requiresAnswer = false,
  });
}

class _IntroStep extends StatelessWidget {
  final Lesson lesson;
  final CryptoLessonContext crypto;
  final String chartType;
  final int cardIndex;

  const _IntroStep({
    required this.lesson,
    required this.crypto,
    required this.chartType,
    this.cardIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lesson.subtitle, style: const TextStyle(color: AppTheme.text, height: 1.5, fontSize: 16.5)),
        const SizedBox(height: 16),
        LessonChartCard(
          chartType: chartType,
          visual: ChartVisualContext.forChartType(chartType, l10n, lessonId: lesson.id),
          pair: crypto.pair,
          timeframe: crypto.timeframe,
          exchange: crypto.exchange,
          lessonId: lesson.id,
          cardIndex: cardIndex,
          height: 220,
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: AppTheme.cardDecoration(color: AppTheme.surface2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.flag_outlined, color: AppTheme.gold, size: 18),
                  const SizedBox(width: 8),
                  Text(l10n.whatYouWillLearn, style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 10),
              Text(lesson.outcome, style: const TextStyle(height: 1.55, color: AppTheme.textSoft)),
              if (lesson.learningOutcomes.isNotEmpty) ...[
                const SizedBox(height: 14),
                ...lesson.learningOutcomes.map(
                  (o) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 16, color: AppTheme.gold),
                        const SizedBox(width: 8),
                        Expanded(child: Text(o, style: const TextStyle(height: 1.45, color: AppTheme.muted, fontSize: 13))),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _chip(Icons.speed, l10n.difficultyName(lesson.difficulty)),
            const SizedBox(width: 8),
            _chip(Icons.timer_outlined, '${lesson.durationMin} ${l10n.min}'),
          ],
        ),
      ],
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.gold),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

/// Optional chart under the step content; null [chartType] = same chart as before, skip it.
Widget _stepChart({
  required BuildContext context,
  required String? chartType,
  required Lesson lesson,
  required CryptoLessonContext crypto,
  required int cardIndex,
  String? caption,
}) {
  if (chartType == null) return const SizedBox.shrink();
  return Padding(
    padding: const EdgeInsets.only(top: 16),
    child: LessonChartCard(
      chartType: chartType,
      visual: ChartVisualContext.forChartType(chartType, context.l10n, lessonId: lesson.id),
      caption: caption,
      pair: crypto.pair,
      timeframe: crypto.timeframe,
      exchange: crypto.exchange,
      lessonId: lesson.id,
      cardIndex: cardIndex,
      height: 220,
    ),
  );
}

class _TextCardStep extends StatelessWidget {
  final String? heading;
  final String text;
  final Lesson lesson;
  final CryptoLessonContext crypto;
  final String? chartType;
  final int cardIndex;
  final String? caption;

  const _TextCardStep({
    required this.heading,
    required this.text,
    required this.lesson,
    required this.crypto,
    required this.chartType,
    required this.cardIndex,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = heading == null ? null : l10n.translateSectionHeading(heading!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(title, style: AppTheme.display(21)),
          ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: AppTheme.cardDecoration(),
          child: LessonRichText(text: text),
        ),
        _stepChart(
          context: context,
          chartType: chartType,
          lesson: lesson,
          crypto: crypto,
          cardIndex: cardIndex,
          caption: caption == title ? null : caption,
        ),
      ],
    );
  }
}

class _CompareStep extends StatefulWidget {
  const _CompareStep({
    required this.heading,
    required this.question,
    required this.answer,
    required this.onRevealed,
  });

  final String? heading;
  final String question;
  final String answer;
  final VoidCallback onRevealed;

  @override
  State<_CompareStep> createState() => _CompareStepState();
}

class _CompareStepState extends State<_CompareStep> {
  bool _shown = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.heading == null ? l10n.checkYourself : l10n.translateSectionHeading(widget.heading!),
          style: AppTheme.display(21),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: AppTheme.cardDecoration(),
          child: Text(widget.question, style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.answerThenReveal,
          style: const TextStyle(color: AppTheme.muted, fontSize: 13),
        ),
        const SizedBox(height: 12),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          crossFadeState: _shown ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() => _shown = true);
                widget.onRevealed();
              },
              icon: const Icon(Icons.visibility_rounded, size: 18),
              label: Text(l10n.showAnswer),
            ),
          ),
          secondChild: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.mint.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_rounded, color: AppTheme.mint, size: 20),
                const SizedBox(width: 10),
                Expanded(child: LessonRichText(text: widget.answer)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChoiceCardStep extends StatefulWidget {
  final LessonSection section;
  final Lesson lesson;
  final CryptoLessonContext crypto;
  final String? chartType;
  final int cardIndex;
  final VoidCallback onAnswered;

  const _ChoiceCardStep({
    required this.section,
    required this.lesson,
    required this.crypto,
    required this.chartType,
    required this.cardIndex,
    required this.onAnswered,
  });

  @override
  State<_ChoiceCardStep> createState() => _ChoiceCardStepState();
}

class _ChoiceCardStepState extends State<_ChoiceCardStep> {
  int? _selected;
  bool _answered = false;

  void _pick(int i) {
    if (_answered) return;
    setState(() {
      _selected = i;
      _answered = true;
    });
    widget.onAnswered();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = widget.section.items ?? const <String>[];
    final correct = widget.section.correctIndex ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.section.title ?? l10n.keyTakeaway,
          style: AppTheme.display(21),
        ),
        if (widget.section.body != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.section.body!,
            style: const TextStyle(color: AppTheme.textSoft, height: 1.45, fontSize: 15.5, fontWeight: FontWeight.w700),
          ),
        ],
        const SizedBox(height: 14),
        ...List.generate(items.length, (i) {
          final selected = _selected == i;
          final showResult = _answered && selected;
          final isCorrect = i == correct;
          Color border = AppTheme.lineSoft;
          Color? bg;
          if (showResult) {
            border = isCorrect ? AppTheme.bull : AppTheme.bear;
            bg = (isCorrect ? AppTheme.bull : AppTheme.bear).withValues(alpha: 0.12);
          } else if (_answered && isCorrect) {
            border = AppTheme.bull.withValues(alpha: 0.55);
          }
          return Semantics(
            button: true,
            selected: selected,
            hint: l10n.answerOptionHint(i + 1),
            child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: bg ?? AppTheme.surface2,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _answered ? null : () => _pick(i),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border),
                  ),
                  child: Text(items[i], style: const TextStyle(height: 1.45, color: AppTheme.text)),
                ),
              ),
            ),
            ),
          );
        }),
        if (_answered) ...[
          const SizedBox(height: 8),
          Text(
            _selected == correct ? l10n.choiceCorrect : l10n.choiceWrong,
            style: TextStyle(
              color: _selected == correct ? AppTheme.bull : AppTheme.warn,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        _stepChart(
          context: context,
          chartType: widget.chartType,
          lesson: widget.lesson,
          crypto: widget.crypto,
          cardIndex: widget.cardIndex,
          caption: widget.section.caption,
        ),
      ],
    );
  }
}

class _InteractiveWithChartStep extends StatelessWidget {
  final Lesson lesson;
  final LessonSection section;
  final CryptoLessonContext crypto;
  final String? chartType;
  final int cardIndex;

  const _InteractiveWithChartStep({
    required this.lesson,
    required this.section,
    required this.crypto,
    required this.chartType,
    required this.cardIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LessonInteractiveSection(lesson: lesson, section: section),
        _stepChart(
          context: context,
          chartType: chartType,
          lesson: lesson,
          crypto: crypto,
          cardIndex: cardIndex,
          caption: section.caption,
        ),
      ],
    );
  }
}

class LessonHomeworkStep extends StatelessWidget {
  final Lesson lesson;

  const LessonHomeworkStep({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeworkRubric,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        LessonHomeworkCard(lesson: lesson),
      ],
    );
  }
}

class _ReferencesStep extends StatelessWidget {
  final Lesson lesson;

  const _ReferencesStep({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final refs = lesson.references;
    if (refs.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.sectionReferences, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        ...refs.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () => launchUrl(Uri.parse(r.url), mode: LaunchMode.externalApplication),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: AppTheme.cardDecoration(),
                child: Row(
                  children: [
                    const Icon(Icons.link, color: AppTheme.gold, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          Text(
                            '${r.author}${r.year != null ? ', ${r.year}' : ''}',
                            style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
