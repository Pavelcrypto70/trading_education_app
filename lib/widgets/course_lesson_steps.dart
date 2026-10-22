import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/lesson.dart';
import '../models/lesson_section.dart';
import '../services/lesson_practice_service.dart';
import '../services/locale_service.dart';
import '../theme.dart';
import 'course_chart.dart';
import 'lesson_rich_text.dart';

/// Step widgets for the rebuilt course (lessons authored in tools/course).
/// Every page shows only what the author wrote: no generated charts, no repeats.

class CourseIntroStep extends StatelessWidget {
  final Lesson lesson;
  const CourseIntroStep({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lesson.subtitle, style: const TextStyle(color: AppTheme.text, height: 1.5, fontSize: 17)),
        const SizedBox(height: 18),
        if (lesson.learningOutcomes.isNotEmpty)
          _Block(
            icon: Icons.flag_outlined,
            title: l10n.afterLessonYouCan,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final o in lesson.learningOutcomes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.check_circle_outline, size: 16, color: AppTheme.progress),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(o, style: const TextStyle(height: 1.45, color: AppTheme.textSoft))),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        if (lesson.newTerms.isNotEmpty) ...[
          const SizedBox(height: 14),
          _Block(
            icon: Icons.translate_rounded,
            title: l10n.newWordsInLesson,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in lesson.newTerms)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.progress.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppTheme.progress.withValues(alpha: 0.4)),
                        ),
                        child: Text(_cap(t.term),
                            style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.text)),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.eachWordExplained,
                  style: const TextStyle(color: AppTheme.muted, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 14),
        Row(
          children: [
            const Icon(Icons.timer_outlined, size: 16, color: AppTheme.muted),
            const SizedBox(width: 6),
            Text(l10n.minutesLabel(lesson.durationMin), style: const TextStyle(color: AppTheme.muted, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  static String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class CourseTextStep extends StatelessWidget {
  final LessonSection section;
  const CourseTextStep({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((section.title ?? '').isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(section.title!, style: AppTheme.display(21)),
          ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: AppTheme.cardDecoration(),
          child: LessonRichText(text: section.body ?? ''),
        ),
        if (section.chart != null) ...[
          const SizedBox(height: 16),
          CourseChartCard(spec: section.chart!),
        ],
      ],
    );
  }
}

class CourseChoiceStep extends StatefulWidget {
  final LessonSection section;
  final VoidCallback onAnswered;
  const CourseChoiceStep({super.key, required this.section, required this.onAnswered});

  @override
  State<CourseChoiceStep> createState() => _CourseChoiceStepState();
}

class _CourseChoiceStepState extends State<CourseChoiceStep> {
  int? _picked;
  bool _solved = false;
  bool _wait = false;
  Timer? _waitTimer;

  @override
  void dispose() {
    _waitTimer?.cancel();
    super.dispose();
  }

  void _pick(int i) {
    if (_solved || _wait) return;
    final correct = widget.section.correctIndex ?? 0;
    setState(() {
      _picked = i;
      if (i == correct) {
        _solved = true;
      } else {
        // A short pause after a wrong answer: read the explanation instead of tapping through.
        _wait = true;
      }
    });
    if (i == correct) {
      widget.onAnswered();
    } else {
      _waitTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _wait = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = widget.section;
    final items = s.items ?? const <String>[];
    final correct = s.correctIndex ?? 0;
    final explain = s.explain ?? const <String>[];
    final picked = _picked;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.title ?? l10n.checkYourself, style: AppTheme.display(21)),
        const SizedBox(height: 10),
        if (s.chart != null) ...[
          CourseChartCard(spec: s.chart!, height: 250),
          const SizedBox(height: 14),
        ],
        Text(s.body ?? '', style: const TextStyle(fontSize: 16, height: 1.45, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _option(i, items[i], correct, picked),
          ),
        if (picked != null && picked < explain.length)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: (picked == correct ? AppTheme.bull : AppTheme.warn).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  picked == correct
                      ? l10n.correctShort
                      : _wait
                          ? l10n.incorrectReadExplain
                          : l10n.incorrectPickAnother,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: picked == correct ? AppTheme.bull : AppTheme.warn,
                  ),
                ),
                const SizedBox(height: 6),
                Text(explain[picked], style: const TextStyle(height: 1.45, color: AppTheme.textSoft)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _option(int i, String text, int correct, int? picked) {
    final isPicked = picked == i;
    final showGood = _solved && i == correct;
    final showBad = isPicked && i != correct;
    final border = showGood
        ? AppTheme.bull
        : showBad
            ? AppTheme.bear
            : AppTheme.lineSoft;
    return Semantics(
      button: true,
      selected: isPicked,
      child: Material(
        color: showGood
            ? AppTheme.bull.withValues(alpha: 0.12)
            : showBad
                ? AppTheme.bear.withValues(alpha: 0.10)
                : AppTheme.surface2,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _solved || _wait ? null : () => _pick(i),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border, width: showGood || showBad ? 1.6 : 1),
            ),
            child: Row(
              children: [
                Expanded(child: Text(text, style: const TextStyle(height: 1.4, color: AppTheme.text))),
                if (showGood) const Icon(Icons.check_circle_rounded, color: AppTheme.bull, size: 20),
                if (showBad) const Icon(Icons.cancel_rounded, color: AppTheme.bear, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CourseRememberStep extends StatelessWidget {
  final Lesson lesson;
  const CourseRememberStep({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.keyTakeaway, style: AppTheme.display(21)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.cardDecoration(
            color: AppTheme.progress.withValues(alpha: 0.10),
            border: Border.all(color: AppTheme.progress.withValues(alpha: 0.45)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_rounded, color: AppTheme.progress),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  lesson.takeaway,
                  style: const TextStyle(fontSize: 17, height: 1.5, fontWeight: FontWeight.w700, color: AppTheme.text),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CoursePracticeStep extends StatefulWidget {
  final Lesson lesson;
  final LessonSection section;
  const CoursePracticeStep({super.key, required this.lesson, required this.section});

  @override
  State<CoursePracticeStep> createState() => _CoursePracticeStepState();
}

class _CoursePracticeStepState extends State<CoursePracticeStep> {
  bool _done = false;

  Lesson get lesson => widget.lesson;
  LessonSection get section => widget.section;

  @override
  void initState() {
    super.initState();
    LessonPracticeService.isDone(lesson.id).then((d) {
      if (mounted && d) setState(() => _done = true);
    });
  }

  Future<void> _open(BuildContext context) async {
    await LessonPracticeService.startPractice(
      lessonId: lesson.id,
      lessonTitle: lesson.title,
      scenario: section.body,
    );
    if (context.mounted) context.go('/practice?returnLesson=${lesson.id}');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = section.items ?? const <String>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.title ?? l10n.paperPracticeDefaultTitle, style: AppTheme.display(21)),
        if (_done) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppTheme.bull, size: 18),
              const SizedBox(width: 6),
              Text(l10n.assignmentDone, style: const TextStyle(color: AppTheme.bull, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
        const SizedBox(height: 6),
        Text(
          l10n.paperMoneyRealHabits,
          style: const TextStyle(color: AppTheme.muted, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 14),
        _Block(
          icon: Icons.track_changes_rounded,
          title: l10n.assignmentTitle,
          child: Text(section.body ?? '', style: const TextStyle(height: 1.5, color: AppTheme.text, fontSize: 15.5)),
        ),
        const SizedBox(height: 12),
        _Block(
          icon: Icons.format_list_numbered_rounded,
          title: l10n.howToDo,
          child: Column(
            children: [
              for (var i = 0; i < steps.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: AppTheme.progress, shape: BoxShape.circle),
                        child: Text('${i + 1}',
                            style: const TextStyle(color: AppTheme.onPastel, fontWeight: FontWeight.w900, fontSize: 12)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(steps[i], style: const TextStyle(height: 1.45, color: AppTheme.textSoft))),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if ((section.finish ?? '').isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(section.finish!,
              style: const TextStyle(color: AppTheme.progress, fontWeight: FontWeight.w700, height: 1.45)),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _open(context),
            icon: const Icon(Icons.candlestick_chart_rounded),
            label: Text(_done ? l10n.openPaperExchangeAgain : l10n.openPaperExchange),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.assignmentCountsOnClose,
          style: const TextStyle(color: AppTheme.muted, fontSize: 12.5, height: 1.4),
        ),
      ],
    );
  }
}

class _Block extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const _Block({required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(color: AppTheme.surface2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.progress, size: 18),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
