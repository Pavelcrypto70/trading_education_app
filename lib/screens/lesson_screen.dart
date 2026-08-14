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
import '../services/progress_service.dart';
import '../widgets/lesson_paywall_sheet.dart';
import '../theme.dart';
import '../utils/chart_visual_context.dart';
import '../utils/crypto_lesson_context.dart';
import '../widgets/lesson_chart_card.dart';
import '../widgets/lesson_concept_visual.dart';
import '../widgets/lesson_rich_text.dart';
import '../widgets/lesson_checkpoint.dart';
import '../widgets/lesson_practice_cards.dart';

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
        final ok = await showLessonPaywallIfNeeded(context, lesson.id);
        if (!ok && mounted) {
          context.pop();
          return;
        }
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
          SnackBar(content: Text(context.l10n.resumeLessonStep(stepLabel))),
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

  List<_LessonStep> _buildSteps(Lesson lesson) {
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

    String? pendingHeading;
    var fallbackCard = 1;

    for (final s in lesson.sections) {
      switch (s.type) {
        case 'heading':
          pendingHeading = s.title;
          break;
        case 'text':
          final cardIndex = s.cardIndex ?? fallbackCard++;
          final chartType = s.chartType ?? visualType;
          final heading = pendingHeading;
          pendingHeading = null;
          final text = s.body ?? '';
          steps.add(_LessonStep(
            icon: Icons.menu_book_outlined,
            builder: (ctx, l10n) => _TextCardStep(
              heading: heading,
              text: text,
              lesson: lesson,
              crypto: crypto,
              chartType: chartType,
              cardIndex: cardIndex,
              visual: ChartVisualContext.forChartType(chartType, l10n, lessonId: lesson.id),
            ),
          ));
          break;
        case 'choice':
          final cardIndex = s.cardIndex ?? fallbackCard++;
          final chartType = s.chartType ?? visualType;
          final section = s;
          steps.add(_LessonStep(
            icon: Icons.touch_app_outlined,
            builder: (ctx, l10n) => _ChoiceCardStep(
              section: section,
              lesson: lesson,
              crypto: crypto,
              chartType: chartType,
              cardIndex: cardIndex,
              visual: ChartVisualContext.forChartType(chartType, l10n, lessonId: lesson.id),
            ),
          ));
          break;
        case 'homework':
        case 'journal':
        case 'practice':
        case 'market_note':
        case 'calculator':
        case 'link':
          final section = s;
          final cardIndex = s.cardIndex ?? fallbackCard++;
          final chartType = s.chartType ?? visualType;
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
              visual: ChartVisualContext.forChartType(chartType, l10n, lessonId: lesson.id),
            ),
          ));
          break;
        case 'references':
          steps.add(_LessonStep(
            icon: Icons.menu_book_outlined,
            builder: (ctx, l10n) => _ReferencesStep(lesson: lesson),
          ));
          break;
        default:
          break;
      }
    }

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
        onPassed: () => setState(() => _checkpointPassed = true),
      ),
    ));

    return steps;
  }

  void _nextStep() {
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
    final xp = await GamificationService.addXp(GamificationService.xpPerLesson);
    if (!mounted) return;

    setState(() => _completed = true);
    final l10n = context.l10n;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.gold.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emoji_events, color: AppTheme.gold, size: 48),
            ),
            const SizedBox(height: 16),
            Text(l10n.lessonComplete, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(l10n.xpEarned(GamificationService.xpPerLesson), style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w700)),
            Text('Total XP: $xp', style: const TextStyle(color: Colors.white54, fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.continueBtn)),
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: l10n.backToLearning,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/learning');
            }
          },
        ),
        title: Text(l10n.moduleName(lesson.module)),
        actions: [
          if (_completed)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.check_circle, color: AppTheme.gold),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        l10n.lessonNumber(lesson.id),
                        style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w700, fontSize: 11),
                      ),
                    ),
                    if (_crypto != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _crypto!.pair,
                          style: const TextStyle(fontSize: 10, color: Colors.white54, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      l10n.stepOf(_step + 1, _steps.length),
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  lesson.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_step + 1) / _steps.length,
                    minHeight: 4,
                    backgroundColor: Colors.white12,
                    color: AppTheme.gold,
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
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.go('/practice?returnLesson=${lesson.id}'),
                      child: Text(l10n.practiceAfterLesson),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => context.go('/learning'),
                      child: Text(l10n.backToLearning),
                    ),
                  ),
                ] else
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
                            onPressed: _nextStep,
                            child: Text(l10n.next),
                          ),
                        )
                      else if (!_checkpointPassed)
                        Expanded(
                          flex: 2,
                          child: OutlinedButton(
                            onPressed: _prevStep,
                            child: Text(l10n.back),
                          ),
                        ),
                    ],
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

  const _LessonStep({required this.icon, required this.builder});
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
        LessonConceptVisual(
          type: conceptTypeFromText(lesson.title, lesson.module),
          height: 110,
        ),
        const SizedBox(height: 16),
        Text(lesson.subtitle, style: const TextStyle(color: Colors.white54, height: 1.5, fontSize: 15)),
        const SizedBox(height: 16),
        LessonChartCard(
          chartType: chartType,
          visual: ChartVisualContext.forChartType(chartType, l10n, lessonId: lesson.id),
          title: lesson.title,
          caption: lesson.title,
          pair: crypto.pair,
          timeframe: crypto.timeframe,
          exchange: crypto.exchange,
          lessonId: lesson.id,
          cardIndex: cardIndex,
          height: 280,
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: AppTheme.cardDecoration(color: AppTheme.gold.withValues(alpha: 0.08)),
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
              Text(lesson.outcome, style: const TextStyle(height: 1.55, color: Colors.white70)),
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
                        Expanded(child: Text(o, style: const TextStyle(height: 1.45, color: Colors.white60, fontSize: 13))),
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
            const SizedBox(width: 8),
            _chip(Icons.currency_bitcoin, crypto.pair),
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
        border: Border.all(color: Colors.white12),
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

class _TextCardStep extends StatelessWidget {
  final String? heading;
  final String text;
  final Lesson lesson;
  final CryptoLessonContext crypto;
  final String chartType;
  final int cardIndex;
  final ChartVisualContext visual;

  const _TextCardStep({
    required this.heading,
    required this.text,
    required this.lesson,
    required this.crypto,
    required this.chartType,
    required this.cardIndex,
    required this.visual,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              l10n.translateSectionHeading(heading!),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
        LessonChartCard(
          chartType: chartType,
          visual: visual,
          title: heading ?? lesson.title,
          caption: heading ?? l10n.visualExampleCaption,
          pair: crypto.pair,
          timeframe: crypto.timeframe,
          exchange: crypto.exchange,
          lessonId: lesson.id,
          cardIndex: cardIndex,
          height: 300,
        ),
        if (text.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.cardDecoration(
              border: Border.all(color: AppTheme.accent.withValues(alpha: 0.2)),
            ),
            child: LessonRichText(text: text),
          ),
        ],
      ],
    );
  }
}

class _ChoiceCardStep extends StatefulWidget {
  final LessonSection section;
  final Lesson lesson;
  final CryptoLessonContext crypto;
  final String chartType;
  final int cardIndex;
  final ChartVisualContext visual;

  const _ChoiceCardStep({
    required this.section,
    required this.lesson,
    required this.crypto,
    required this.chartType,
    required this.cardIndex,
    required this.visual,
  });

  @override
  State<_ChoiceCardStep> createState() => _ChoiceCardStepState();
}

class _ChoiceCardStepState extends State<_ChoiceCardStep> {
  int? _selected;
  bool _answered = false;

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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        if (widget.section.body != null) ...[
          const SizedBox(height: 8),
          Text(widget.section.body!, style: const TextStyle(color: Colors.white54, height: 1.45)),
        ],
        const SizedBox(height: 14),
        LessonChartCard(
          chartType: widget.chartType,
          visual: widget.visual,
          title: widget.section.title,
          caption: widget.section.caption ?? widget.section.title ?? l10n.visualExampleCaption,
          pair: widget.crypto.pair,
          timeframe: widget.crypto.timeframe,
          exchange: widget.crypto.exchange,
          lessonId: widget.lesson.id,
          cardIndex: widget.cardIndex,
          height: 260,
        ),
        const SizedBox(height: 16),
        ...List.generate(items.length, (i) {
          final selected = _selected == i;
          final showResult = _answered && selected;
          final isCorrect = i == correct;
          Color border = Colors.white12;
          Color? bg;
          if (showResult) {
            border = isCorrect ? Colors.greenAccent : Colors.redAccent;
            bg = (isCorrect ? Colors.green : Colors.red).withValues(alpha: 0.12);
          } else if (_answered && isCorrect) {
            border = Colors.greenAccent.withValues(alpha: 0.5);
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: bg ?? AppTheme.card,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _answered
                    ? null
                    : () => setState(() {
                          _selected = i;
                          _answered = true;
                        }),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border),
                  ),
                  child: Text(items[i], style: const TextStyle(height: 1.45)),
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
              color: _selected == correct ? Colors.greenAccent : Colors.orangeAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _InteractiveWithChartStep extends StatelessWidget {
  final Lesson lesson;
  final LessonSection section;
  final CryptoLessonContext crypto;
  final String chartType;
  final int cardIndex;
  final ChartVisualContext visual;

  const _InteractiveWithChartStep({
    required this.lesson,
    required this.section,
    required this.crypto,
    required this.chartType,
    required this.cardIndex,
    required this.visual,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LessonChartCard(
          chartType: chartType,
          visual: visual,
          title: section.title ?? lesson.title,
          caption: section.caption ?? section.title ?? l10n.visualExampleCaption,
          pair: crypto.pair,
          timeframe: crypto.timeframe,
          exchange: crypto.exchange,
          lessonId: lesson.id,
          cardIndex: cardIndex,
          height: 260,
        ),
        const SizedBox(height: 14),
        LessonInteractiveSection(lesson: lesson, section: section),
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
                            style: const TextStyle(fontSize: 12, color: Colors.white54),
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
