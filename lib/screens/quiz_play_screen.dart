import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../data/lessons_repository.dart';
import '../models/quiz_question.dart';
import '../services/gamification_service.dart';
import '../services/locale_service.dart';
import '../services/progress_service.dart';
import '../services/quiz_session.dart';
import '../services/spaced_repetition_service.dart';
import '../widgets/lesson_charts.dart';
import '../theme.dart';

class QuizPlayScreen extends StatefulWidget {
  final String title;
  final List<QuizQuestion> questions;
  final bool isDailyChallenge;
  final String? moduleId;
  final int? passPercent;
  final bool isPlacement;
  final List<int> placementLessonIds;

  const QuizPlayScreen({
    super.key,
    required this.title,
    required this.questions,
    this.isDailyChallenge = false,
    this.moduleId,
    this.passPercent,
    this.isPlacement = false,
    this.placementLessonIds = const [],
  });

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int currentIndex = 0;
  int? selectedAnswerIndex;
  int score = 0;
  bool answered = false;
  final Set<int> _wrongLessonIds = {};

  void _selectAnswer(int index) {
    if (answered) return;
    final q = widget.questions[currentIndex];
    setState(() {
      selectedAnswerIndex = index;
      answered = true;
      if (index == q.correctIndex) {
        score++;
        if (q.sourceId != null) {
          SpacedRepetitionService.recordCorrect(q.sourceId!);
        }
      } else {
        if (q.lessonId != null) _wrongLessonIds.add(q.lessonId!);
        if (q.sourceId != null) {
          SpacedRepetitionService.recordWrong(
            questionId: q.sourceId!,
            question: q.question,
            options: q.options,
            correctIndex: q.correctIndex,
            explanation: q.explanation,
            category: q.category,
            difficulty: q.difficulty,
            lessonId: q.lessonId,
          );
        }
      }
    });
  }

  Future<void> _finish() async {
    GamificationService.lastAward = null;
    final reviewLessons = <Map<String, dynamic>>[];

    if (widget.isDailyChallenge) {
      await ProgressService.completeDailyChallenge(score, widget.questions.length);
    } else {
      await ProgressService.saveQuizResult(
        title: widget.title,
        score: score,
        total: widget.questions.length,
      );
      if (widget.isPlacement && widget.placementLessonIds.isNotEmpty) {
        final weak = _wrongLessonIds.intersection(widget.placementLessonIds.toSet());
        final strong = widget.placementLessonIds.where((id) => !weak.contains(id));
        await ProgressService.markLessonsComplete(strong);
        final lessons = await LessonsRepository.instance.loadLessons();
        final byId = {for (final l in lessons) l.id: l};
        final orderedWeak = widget.placementLessonIds.where(weak.contains);
        for (final id in orderedWeak) {
          final lesson = byId[id];
          reviewLessons.add({
            'id': id,
            'title': lesson?.title ?? LocaleService.instance.strings.lessonFallback(id),
          });
        }
        if (widget.moduleId != null) {
          final pass = widget.passPercent ?? 70;
          if (score >= (widget.questions.length * pass / 100).ceil()) {
            await ProgressService.markModulePassed(widget.moduleId!, score, widget.questions.length);
            await GamificationService.award(PointsReason.moduleTest, uniqueKey: 'mt-${widget.moduleId}');
          }
        }
      } else if (widget.moduleId != null) {
        final pass = widget.passPercent ?? 70;
        if (score >= (widget.questions.length * pass / 100).ceil()) {
          await ProgressService.markModulePassed(widget.moduleId!, score, widget.questions.length);
          await GamificationService.award(PointsReason.moduleTest, uniqueKey: 'mt-${widget.moduleId}');
        }
      }
    }
    await ProgressService.recordDailyActivity();
    QuizSession.clear();
    if (!mounted) return;
    context.go('/quiz-result', extra: {
      'score': score,
      'total': widget.questions.length,
      'title': widget.title,
      'isDailyChallenge': widget.isDailyChallenge,
      'isPlacement': widget.isPlacement,
      'reviewLessons': reviewLessons,
    });
  }

  void _nextQuestion() {
    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswerIndex = null;
        answered = false;
      });
      return;
    }
    _finish();
  }

  Color _optionColor(int index, QuizQuestion question) {
    if (!answered) return AppTheme.card;
    if (index == question.correctIndex) {
      return AppTheme.bull.withValues(alpha: 0.25);
    }
    if (selectedAnswerIndex == index) {
      return AppTheme.bear.withValues(alpha: 0.25);
    }
    return AppTheme.card;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final question = widget.questions[currentIndex];
    final progress = (currentIndex + 1) / widget.questions.length;
    final compact = MediaQuery.of(context).size.height < 720;
    final chartHeight = compact ? 160.0 : 220.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                children: [
                  Row(
                    children: [
                      Text(
                        '${l10n.questionOf} ${currentIndex + 1}/${widget.questions.length}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.gold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          l10n.difficultyName(question.difficulty),
                          style: const TextStyle(color: AppTheme.gold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      color: AppTheme.gold,
                      backgroundColor: AppTheme.line,
                    ),
                  ),
                  if (question.showChart && question.lessonId != null) ...[
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        height: chartHeight,
                        child: LessonChartWidget(
                          chartType: 'lesson',
                          lessonId: question.lessonId,
                          height: chartHeight,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    question.question,
                    style: TextStyle(
                      fontSize: compact ? 18 : 20,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.categoryName(question.category),
                    style: const TextStyle(color: AppTheme.muted, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(question.options.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: _optionColor(index, question),
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _selectAnswer(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppTheme.line,
                                  child: Text(
                                    String.fromCharCode(65 + index),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    question.options[index],
                                    style: const TextStyle(height: 1.35, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  if (answered) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selectedAnswerIndex == question.correctIndex
                            ? AppTheme.bull.withValues(alpha: 0.12)
                            : AppTheme.bear.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selectedAnswerIndex == question.correctIndex
                              ? AppTheme.bull.withValues(alpha: 0.4)
                              : AppTheme.bear.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedAnswerIndex == question.correctIndex
                                ? l10n.greatJob
                                : l10n.keepPracticing,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            question.explanation,
                            style: const TextStyle(color: AppTheme.textSoft, fontSize: 13, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: answered ? _nextQuestion : null,
                  child: Text(
                    currentIndex == widget.questions.length - 1
                        ? l10n.seeResults
                        : l10n.nextQuestion,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
