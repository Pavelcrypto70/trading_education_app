import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/lessons_repository.dart';
import '../models/lesson.dart';
import '../models/lesson_section.dart';
import '../services/gamification_service.dart';
import '../l10n/app_localizations.dart';
import '../services/locale_service.dart';
import '../services/progress_service.dart';
import '../theme.dart';
import '../utils/chart_visual_context.dart';
import '../utils/crypto_lesson_context.dart';
import '../widgets/interactive_lesson_widgets.dart';
import '../widgets/lesson_chart_card.dart';
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
    final completed = lesson != null
        ? await ProgressService.isLessonComplete(lesson.id)
        : false;
    if (!mounted) return;
    setState(() {
      _lesson = lesson;
      _crypto = lesson != null ? CryptoLessonContext.forLesson(lesson) : null;
      _completed = completed;
      _checkpointPassed = completed;
      _steps = lesson != null ? _buildSteps(lesson) : [];
      _loading = false;
    });
  }

  List<_TopicBlock> _parseTopicBlocks(List<LessonSection> sections) {
    final blocks = <_TopicBlock>[];
    _TopicBlock? current;

    void flush() {
      if (current != null &&
          (current!.paragraphs.isNotEmpty ||
              current!.chart != null ||
              current!.heading != null)) {
        blocks.add(current!);
      }
      current = null;
    }

    for (final section in sections) {
      switch (section.type) {
        case 'heading':
          flush();
          current = _TopicBlock()..heading = section.title;
        case 'text':
          current ??= _TopicBlock();
          if (section.body != null) {
            current!.paragraphs.add(section.body!);
          }
        case 'chart':
          current ??= _TopicBlock();
          current!.chart = section;
        default:
          break;
      }
    }
    flush();
    return blocks;
  }

  List<_LessonStep> _buildSteps(Lesson lesson) {
    final crypto = CryptoLessonContext.forLesson(lesson);
    final primaryChart = crypto.primaryChartType;
    final steps = <_LessonStep>[
      _LessonStep(
        icon: Icons.flag_outlined,
        builder: (ctx, l10n) => _IntroStep(lesson: lesson, crypto: crypto),
      ),
    ];

    for (final block in _parseTopicBlocks(lesson.sections)) {
      if (block.chart != null) {
        final chartType = block.chart!.chartType ?? primaryChart;
        steps.add(_LessonStep(
          icon: Icons.candlestick_chart,
          builder: (ctx, l10n) => _ChartStep(
            block: block,
            chartType: chartType,
            crypto: crypto,
            visual: ChartVisualContext.forChartType(chartType, l10n),
          ),
        ));
      } else if (block.paragraphs.isNotEmpty || block.heading != null) {
        steps.add(_LessonStep(
          icon: Icons.menu_book_outlined,
          builder: (ctx, l10n) => _TextBlockStep(block: block),
        ));
      }
    }

    LessonSection? example;
    LessonSection? bullets;
    LessonSection? tip;
    final interactive = <LessonSection>[];
    for (final s in lesson.sections) {
      if (s.type == 'example') example = s;
      if (s.type == 'bullets') bullets = s;
      if (s.type == 'tip') tip = s;
      if (s.type == 'tradingview' ||
          s.type == 'practice' ||
          s.type == 'market_note' ||
          s.type == 'journal') {
        interactive.add(s);
      }
    }

    for (final section in interactive) {
      final icon = switch (section.type) {
        'tradingview' => Icons.open_in_new,
        'practice' => Icons.fitness_center,
        'market_note' => Icons.public,
        _ => Icons.edit_note,
      };
      steps.add(_LessonStep(
        icon: icon,
        builder: (ctx, l10n) => LessonInteractiveSection(lesson: lesson, section: section),
      ));
    }

    if (example != null) {
      final showChart = ChartVisualContext.exampleNeedsChart(primaryChart);
      steps.add(_LessonStep(
        icon: Icons.play_circle_outline,
        builder: (ctx, l10n) => _ExampleStep(
          section: example!,
          crypto: crypto,
          chartType: primaryChart,
          visual: ChartVisualContext.forChartType(primaryChart, l10n),
          showChart: showChart,
        ),
      ));
    }

    if (bullets != null && bullets!.items != null && bullets!.items!.isNotEmpty) {
      final bulletItems = bullets!.items!;
      steps.add(_LessonStep(
        icon: Icons.checklist,
        builder: (ctx, l10n) => InteractiveBulletList(items: bulletItems),
      ));
    }

    if (tip != null) {
      final tipSection = tip!;
      steps.add(_LessonStep(
        icon: Icons.lightbulb_outline,
        builder: (ctx, l10n) => _TipStep(section: tipSection, takeaway: lesson.takeaway),
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
              onPageChanged: (i) => setState(() => _step = i),
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
                      onPressed: () => context.go('/practice'),
                      child: Text(l10n.practiceAfterLesson),
                    ),
                  ),
                ] else if (!isLast)
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
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _nextStep,
                          child: Text(l10n.next),
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

class _TopicBlock {
  String? heading;
  final List<String> paragraphs = [];
  LessonSection? chart;
}

class _IntroStep extends StatelessWidget {
  final Lesson lesson;
  final CryptoLessonContext crypto;

  const _IntroStep({
    required this.lesson,
    required this.crypto,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lesson.subtitle, style: const TextStyle(color: Colors.white54, height: 1.5, fontSize: 15)),
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

class _TextBlockStep extends StatelessWidget {
  final _TopicBlock block;

  const _TextBlockStep({required this.block});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (block.heading != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              l10n.translateSectionHeading(block.heading!),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
        for (final p in block.paragraphs)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(p, style: const TextStyle(height: 1.65, color: Colors.white70, fontSize: 15)),
          ),
      ],
    );
  }
}

class _ChartStep extends StatelessWidget {
  final _TopicBlock block;
  final String chartType;
  final CryptoLessonContext crypto;
  final ChartVisualContext visual;

  const _ChartStep({
    required this.block,
    required this.chartType,
    required this.crypto,
    required this.visual,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chart = block.chart!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (block.heading != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              l10n.translateSectionHeading(block.heading!),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
        Text(
          l10n.chartExplainCaption,
          style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 14),
        LessonChartCard(
          chartType: chartType,
          visual: visual,
          title: chart.title,
          caption: chart.caption,
          pair: crypto.pair,
          timeframe: crypto.timeframe,
          exchange: crypto.exchange,
          height: visual.showCryptoHeader ? 240 : 260,
        ),
      ],
    );
  }
}

class _ExampleStep extends StatelessWidget {
  final LessonSection section;
  final CryptoLessonContext crypto;
  final String chartType;
  final ChartVisualContext visual;
  final bool showChart;

  const _ExampleStep({
    required this.section,
    required this.crypto,
    required this.chartType,
    required this.visual,
    required this.showChart,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.cardDecoration(color: AppTheme.accent.withValues(alpha: 0.08)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.play_circle_filled, color: AppTheme.accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.sectionPracticalScenario,
                      style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.accent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(section.body ?? '', style: const TextStyle(height: 1.65, color: Colors.white70, fontSize: 15)),
            ],
          ),
        ),
        if (showChart) ...[
          const SizedBox(height: 16),
          Text(
            l10n.scenarioOnChart(crypto.pair),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 10),
          LessonChartCard(
            chartType: chartType,
            visual: visual,
            caption: section.body,
            pair: crypto.pair,
            timeframe: crypto.timeframe,
            exchange: crypto.exchange,
          ),
        ],
      ],
    );
  }
}

class _TipStep extends StatelessWidget {
  final LessonSection section;
  final String takeaway;

  const _TipStep({required this.section, required this.takeaway});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.cardDecoration(color: AppTheme.gold.withValues(alpha: 0.08)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.lightbulb, color: AppTheme.gold),
                  const SizedBox(width: 8),
                  Text(l10n.sectionProTip, style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.gold)),
                ],
              ),
              const SizedBox(height: 12),
              Text(section.body ?? '', style: const TextStyle(height: 1.6, color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.heroGradient(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.keyTakeaway, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 8),
              Text(takeaway, style: const TextStyle(height: 1.55, color: Colors.white70)),
            ],
          ),
        ),
      ],
    );
  }
}
