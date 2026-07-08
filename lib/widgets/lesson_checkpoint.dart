import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/lesson.dart';
import '../l10n/app_localizations.dart';
import '../services/locale_service.dart';
import '../theme.dart';

class CheckpointQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const CheckpointQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class LessonCheckpoint extends StatefulWidget {
  final Lesson lesson;
  final VoidCallback onPassed;

  const LessonCheckpoint({super.key, required this.lesson, required this.onPassed});

  static List<CheckpointQuestion> generate(Lesson lesson, AppLocalizations l10n) {
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
        options: [lesson.takeaway, lesson.subtitle, lesson.outcome.substring(0, lesson.outcome.length.clamp(0, 60))],
        correctIndex: 0,
      ),
    ];
  }

  @override
  State<LessonCheckpoint> createState() => _LessonCheckpointState();
}

class _LessonCheckpointState extends State<LessonCheckpoint> {
  List<CheckpointQuestion>? _questions;
  int _qIndex = 0;
  int? _selected;
  bool _answered = false;
  int _correct = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _questions ??= LessonCheckpoint.generate(widget.lesson, context.l10n);
  }

  void _select(int index) {
    if (_answered) return;
    setState(() {
      _selected = index;
      _answered = true;
      if (index == _questions![_qIndex].correctIndex) _correct++;
    });
    HapticFeedback.lightImpact();
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
      final passed = _correct >= (questions.length * 0.5).ceil();
      if (passed) widget.onPassed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final questions = _questions!;
    final q = questions[_qIndex];
    final isLast = _qIndex == questions.length - 1;
    final passed = _answered && isLast && _correct >= (questions.length * 0.5).ceil();

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
