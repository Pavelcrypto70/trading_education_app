import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/lesson_quiz_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/lesson.dart';
import '../services/locale_service.dart';
import '../services/spaced_repetition_service.dart';
import '../theme.dart';
import 'lesson_charts.dart';

class LessonCheckpoint extends StatefulWidget {
  final Lesson lesson;
  final VoidCallback onPassed;
  /// Back to the lesson pages to reread before the next try.
  final VoidCallback? onReview;

  const LessonCheckpoint({super.key, required this.lesson, required this.onPassed, this.onReview});

  static Future<List<CheckpointQuestion>> generate(Lesson lesson, AppLocalizations l10n) async {
    final bank = await LessonQuizRepository.forLesson(lesson.id);
    if (bank.length >= 2) {
      return bank
          .take(3)
          .map(
            (q) => CheckpointQuestion(
              question: q.question,
              options: q.options,
              correctIndex: q.correctIndex,
              explanation: q.explanation,
              // Rebuilt course questions are text-only: a random chart would not match them.
              showChart: !lesson.isCourseV2 && q.id.endsWith('Q1'),
              cardIndex: _lastCardIndex(lesson),
            ),
          )
          .toList();
    }

    final bullets = <String>[];
    for (final s in lesson.sections) {
      if (s.type == 'bullets' && s.items != null) {
        bullets.addAll(s.items!);
      }
    }

    if (bullets.length >= 3) {
      return [
        CheckpointQuestion(
          question: l10n.checkpointQuestion1,
          options: [bullets[0], bullets[1], bullets[2]],
          correctIndex: 0,
          cardIndex: _lastCardIndex(lesson),
        ),
        CheckpointQuestion(
          question: l10n.checkpointQuestion2(lesson.title),
          options: [lesson.takeaway, bullets.last, bullets.length > 1 ? bullets[1] : bullets[0]],
          correctIndex: 0,
          cardIndex: _lastCardIndex(lesson),
          showChart: true,
        ),
      ];
    }

    return [
      CheckpointQuestion(
        question: l10n.checkpointQuestion2(lesson.title),
        options: [
          lesson.takeaway,
          lesson.subtitle,
          lesson.outcome.length > 60 ? lesson.outcome.substring(0, 60) : lesson.outcome,
        ],
        correctIndex: 0,
        cardIndex: _lastCardIndex(lesson),
        showChart: true,
      ),
    ];
  }

  static int _lastCardIndex(Lesson lesson) {
    var max = 0;
    for (final s in lesson.sections) {
      final i = s.cardIndex;
      if (i != null && i > max) max = i;
    }
    return max;
  }

  /// Every answer must be right: the test is short and checks the main ideas only.
  static int requiredCorrect(int total) => total;

  @override
  State<LessonCheckpoint> createState() => _LessonCheckpointState();
}

class CheckpointQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;
  final bool showChart;
  final int cardIndex;

  const CheckpointQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
    this.showChart = false,
    this.cardIndex = 0,
  });

  /// Same question with options in a new random order.
  CheckpointQuestion shuffled(math.Random rnd) {
    final order = List.generate(options.length, (i) => i)..shuffle(rnd);
    return CheckpointQuestion(
      question: question,
      options: [for (final i in order) options[i]],
      correctIndex: order.indexOf(correctIndex),
      explanation: explanation,
      showChart: showChart,
      cardIndex: cardIndex,
    );
  }
}

class _LessonCheckpointState extends State<LessonCheckpoint> {
    final _rnd = math.Random();
  List<CheckpointQuestion> _source = const [];
  List<CheckpointQuestion>? _questions;
  int _qIndex = 0;
  int? _selected;
  final List<bool> _results = [];
  bool _finished = false;
  bool _loading = true;
  /// Failed tries in a row; the wrong questions are named only from the second one, so the test can't be passed by guessing.
  int _fails = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final qs = await LessonCheckpoint.generate(widget.lesson, context.l10n);
    if (!mounted) return;
    _source = qs;
    setState(() {
      _start();
      _loading = false;
    });
  }

  void _start() {
    _questions = [for (final q in _source) q.shuffled(_rnd)];
    _qIndex = 0;
    _selected = null;
    _results.clear();
    _finished = false;
  }

  int get _correct => _results.where((r) => r).length;

  void _confirm() {
    final questions = _questions;
    final sel = _selected;
    if (questions == null || sel == null) return;
    final q = questions[_qIndex];
    final ok = sel == q.correctIndex;
    if (!ok) {
      SpacedRepetitionService.recordWrong(
        questionId: 'lesson-${widget.lesson.id}-${_source.indexWhere((s) => s.question == q.question)}',
        question: q.question,
        options: q.options,
        correctIndex: q.correctIndex,
        explanation: q.explanation ?? '',
        category: 'Lesson',
        difficulty: 'Easy',
        lessonId: widget.lesson.id,
      );
    }
    setState(() {
      _results.add(ok);
      if (_qIndex < questions.length - 1) {
        _qIndex++;
        _selected = null;
      } else {
        _finished = true;
      }
    });
    if (!_finished) return;
    if (_correct >= LessonCheckpoint.requiredCorrect(questions.length)) {
      _fails = 0;
      widget.onPassed();
    } else {
      _fails++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (_loading || _questions == null) {
      return const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()));
    }
    final questions = _questions!;
    final need = LessonCheckpoint.requiredCorrect(questions.length);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration(color: AppTheme.accent.withValues(alpha: 0.08)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.quiz, color: AppTheme.accent, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.checkpointTitle, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    Text(
                      _finished
                          ? l10n.correctOfTotal(_correct, questions.length)
                          : '${l10n.checkpointProgress(_qIndex + 1, questions.length)} · ${l10n.needAllCorrectHint}',
                      style: const TextStyle(color: AppTheme.textSoft, fontSize: 13.5, height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_finished) _summary(questions, need) else ..._question(questions[_qIndex]),
        ],
      ),
    );
  }

  List<Widget> _question(CheckpointQuestion q) {
    final l10n = context.l10n;
    return [
        Text(q.question, style: const TextStyle(fontWeight: FontWeight.w700, height: 1.4, fontSize: 15)),
        const SizedBox(height: 12),
        if (q.showChart) ...[
          SizedBox(
            height: 130,
            child: LessonChartWidget(
              chartType: 'candlestick',
              lessonId: widget.lesson.id,
              cardIndex: q.cardIndex,
              height: 130,
            ),
          ),
          const SizedBox(height: 12),
        ],
        ...List.generate(q.options.length, (i) {
          final selected = _selected == i;
          return Semantics(
            button: true,
            selected: selected,
            hint: l10n.answerOptionHint(l10n.answerLetter(i)),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: selected ? AppTheme.lavender.withValues(alpha: 0.16) : AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => setState(() => _selected = i),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: selected ? AppTheme.lavender : AppTheme.line),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected ? AppTheme.lavender : AppTheme.line,
                          ),
                          child: Center(
                            child: Text(
                              l10n.answerLetter(i),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: selected ? AppTheme.onPastel : AppTheme.text,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(q.options[i], style: const TextStyle(height: 1.35, fontSize: 14))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 4),
        Text(
          l10n.seeResultAtEnd,
          style: const TextStyle(color: AppTheme.muted, fontSize: 13.5, height: 1.35),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selected == null ? null : _confirm,
            child: Text(_qIndex < (_questions!.length - 1) ? l10n.answerAndNext : l10n.answerAndSeeResult),
          ),
        ),
      ];
  }

  Widget _summary(List<CheckpointQuestion> questions, int need) {
    final l10n = context.l10n;
    final passed = _correct >= need;
    if (passed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.allCorrectLessonPassed,
              style: const TextStyle(color: AppTheme.bull, fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 12),
          for (var i = 0; i < questions.length; i++) _reviewRow(questions[i], true, showAnswer: true),
        ],
      );
    }
    final wrong = [for (var i = 0; i < questions.length; i++) if (!_results[i]) i + 1];
    final named = _fails >= 2;
    final failMsg = !named
        ? l10n.failAnonymous
        : (wrong.length == 1
            ? l10n.failNamedOne(wrong.first)
            : l10n.failNamedMany(l10n.andJoin(wrong.sublist(0, wrong.length - 1).join(', '), '${wrong.last}')));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          failMsg,
          style: const TextStyle(color: AppTheme.warn, fontWeight: FontWeight.w700, height: 1.4),
        ),
        const SizedBox(height: 12),
        if (named)
          for (var i = 0; i < questions.length; i++) _reviewRow(questions[i], _results[i], showAnswer: false),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(_start),
            child: Text(l10n.retakeCheckpoint),
          ),
        ),
        if (widget.onReview != null) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                setState(_start);
                widget.onReview!();
              },
              child: Text(l10n.returnToLesson),
            ),
          ),
        ],
      ],
    );
  }

  Widget _reviewRow(CheckpointQuestion q, bool ok, {required bool showAnswer}) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(ok ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 18, color: ok ? AppTheme.bull : AppTheme.bear),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.question, style: const TextStyle(fontWeight: FontWeight.w700, height: 1.35)),
                  if (showAnswer) ...[
                    const SizedBox(height: 2),
                    Text(q.options[q.correctIndex],
                        style: const TextStyle(color: AppTheme.bull, fontSize: 13, height: 1.35)),
                    if ((q.explanation ?? '').isNotEmpty)
                      Text(q.explanation!, style: const TextStyle(color: AppTheme.muted, fontSize: 14, height: 1.4)),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
}
