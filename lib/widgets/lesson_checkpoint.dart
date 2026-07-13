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
        ),
        CheckpointQuestion(
          question: l10n.checkpointQuestion2(lesson.title),
          options: [lesson.takeaway, bullets.last, bullets.length > 1 ? bullets[1] : bullets[0]],
          correctIndex: 0,
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
      ),
    ];
  }

  @override
  State<LessonCheckpoint> createState() => _LessonCheckpointState();
}

class CheckpointQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;
  final bool showChart;

  const CheckpointQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
    this.showChart = false,
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
      final passed = _correct >= (questions.length * 0.7).ceil();
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
    final passed = _answered && isLast && _correct >= (questions.length * 0.7).ceil();

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
                      l10n.checkpointProgress(_qIndex + 1, questions.length),
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (q.showChart) ...[
            SizedBox(
              height: 160,
              child: LessonChartWidget(
                chartType: 'lesson',
                lessonId: widget.lesson.id,
                height: 160,
              ),
            ),
            const SizedBox(height: 14),
          ],
          Text(q.question, style: const TextStyle(fontWeight: FontWeight.w600, height: 1.4)),
          const SizedBox(height: 14),
          ...List.generate(q.options.length, (i) {
            final isCorrect = i == q.correctIndex;
            Color? border;
            Color? bg;
            if (_answered) {
              if (isCorrect) {
                border = Colors.green;
                bg = Colors.green.withValues(alpha: 0.15);
              } else if (_selected == i) {
                border = Colors.redAccent;
                bg = Colors.redAccent.withValues(alpha: 0.1);
              }
            }
            return Padding(
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
                      border: Border.all(color: border ?? Colors.white12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (_answered && isCorrect)
                                ? Colors.green
                                : (_answered && _selected == i)
                                    ? Colors.redAccent
                                    : Colors.white12,
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
            );
          }),
          if (_answered && q.explanation != null && q.explanation!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(q.explanation!, style: const TextStyle(color: Colors.white54, fontSize: 12, height: 1.4)),
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
