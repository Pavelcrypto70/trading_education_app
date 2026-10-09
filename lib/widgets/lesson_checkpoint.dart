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

  const LessonCheckpoint({super.key, required this.lesson, required this.onPassed});

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
              showChart: q.id.endsWith('Q1'),
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
      final a = _shuffleOptions([bullets[0], bullets[1], bullets[2]], 0, lesson.id * 41);
      final b = _shuffleOptions(
        [lesson.takeaway, bullets.last, bullets.length > 1 ? bullets[1] : bullets[0]],
        0,
        lesson.id * 43,
      );
      return [
        CheckpointQuestion(
          question: l10n.checkpointQuestion1,
          options: a.$1,
          correctIndex: a.$2,
          cardIndex: _lastCardIndex(lesson),
        ),
        CheckpointQuestion(
          question: l10n.checkpointQuestion2(lesson.title),
          options: b.$1,
          correctIndex: b.$2,
          cardIndex: _lastCardIndex(lesson),
          showChart: true,
        ),
      ];
    }

    final fallback = _shuffleOptions(
      [
        lesson.takeaway,
        lesson.subtitle,
        lesson.outcome.length > 60 ? lesson.outcome.substring(0, 60) : lesson.outcome,
      ],
      0,
      lesson.id * 47,
    );
    return [
      CheckpointQuestion(
        question: l10n.checkpointQuestion2(lesson.title),
        options: fallback.$1,
        correctIndex: fallback.$2,
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

  static (List<String>, int) _shuffleOptions(List<String> options, int correctIndex, int seed) {
    final indexed = List.generate(options.length, (i) => i);
    // Deterministic Fisher–Yates
    var state = seed & 0x7fffffff;
    int next() {
      state = (1103515245 * state + 12345) & 0x7fffffff;
      return state;
    }
    for (var i = indexed.length - 1; i > 0; i--) {
      final j = next() % (i + 1);
      final tmp = indexed[i];
      indexed[i] = indexed[j];
      indexed[j] = tmp;
    }
    final shuffled = indexed.map((i) => options[i]).toList();
    final newCorrect = indexed.indexOf(correctIndex.clamp(0, options.length - 1));
    return (shuffled, newCorrect < 0 ? 0 : newCorrect);
  }

  /// 2 of 3 for short quizzes; 70% for longer ones.
  static int requiredCorrect(int total) =>
      total <= 3 ? (total - 1).clamp(1, total) : (total * 0.7).ceil();

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
}

class _LessonCheckpointState extends State<LessonCheckpoint> {
  List<CheckpointQuestion>? _questions;
  int _qIndex = 0;
  int? _selected;
  bool _answered = false;
  int _correct = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final qs = await LessonCheckpoint.generate(widget.lesson, context.l10n);
    if (!mounted) return;
    setState(() {
      _questions = qs;
      _loading = false;
    });
  }

  void _select(int index) {
    if (_answered || _questions == null) return;
    final q = _questions![_qIndex];
    setState(() {
      _selected = index;
      _answered = true;
      if (index == q.correctIndex) {
        _correct++;
      } else {
        SpacedRepetitionService.recordWrong(
          questionId: 'lesson-${widget.lesson.id}-$_qIndex',
          question: q.question,
          options: q.options,
          correctIndex: q.correctIndex,
          explanation: q.explanation ?? '',
          category: 'Lesson',
          difficulty: 'Easy',
          lessonId: widget.lesson.id,
        );
      }
    });
  }

  void _next() {
    final questions = _questions!;
    if (_qIndex < questions.length - 1) {
      setState(() {
        _qIndex++;
        _selected = null;
        _answered = false;
      });
    } else {
      final passed = _correct >= LessonCheckpoint.requiredCorrect(questions.length);
      if (passed) {
        widget.onPassed();
      } else {
        setState(() {
          _qIndex = 0;
          _selected = null;
          _answered = false;
          _correct = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (_loading || _questions == null) {
      return const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()));
    }
    final questions = _questions!;
    final q = questions[_qIndex];
    final isLast = _qIndex == questions.length - 1;
    final passed = _answered && isLast && _correct >= LessonCheckpoint.requiredCorrect(questions.length);

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
                      '${l10n.checkpointProgress(_qIndex + 1, questions.length)} · '
                      'нужно ${LessonCheckpoint.requiredCorrect(questions.length)} верных',
                      style: const TextStyle(color: AppTheme.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
            final isCorrect = i == q.correctIndex;
            Color? border;
            Color? bg;
            if (_answered) {
              if (isCorrect) {
                border = AppTheme.bull;
                bg = AppTheme.bull.withValues(alpha: 0.15);
              } else if (_selected == i) {
                border = AppTheme.bear;
                bg = AppTheme.bear.withValues(alpha: 0.1);
              }
            }
            return Semantics(
              button: true,
              selected: _selected == i,
              hint: 'Вариант ответа ${i + 1}',
              child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: bg ?? AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => _select(i),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: border ?? AppTheme.line),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (_answered && isCorrect)
                                ? AppTheme.bull
                                : (_answered && _selected == i)
                                    ? AppTheme.bear
                                    : AppTheme.line,
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + i),
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(q.options[i], style: const TextStyle(height: 1.3, fontSize: 13))),
                      ],
                    ),
                  ),
                ),
              ),
              ),
            );
          }),
          if (_answered && q.explanation != null && q.explanation!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(q.explanation!, style: const TextStyle(color: AppTheme.muted, fontSize: 12, height: 1.4)),
          ],
          if (_answered) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _next,
                child: Text(
                  isLast
                      ? (passed ? l10n.checkpointComplete : l10n.checkpointRetry)
                      : l10n.continueBtn,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
