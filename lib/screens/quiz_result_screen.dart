import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/lessons_repository.dart';
import '../services/gamification_service.dart';
import '../services/locale_service.dart';
import '../theme.dart';
import '../utils/num_format.dart';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int total;
  final String title;
  final bool isDailyChallenge;
  final bool isPlacement;
  final List<Map<String, dynamic>> reviewLessons;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.title,
    this.isDailyChallenge = false,
    this.isPlacement = false,
    this.reviewLessons = const [],
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  PointsAward? _award;

  @override
  void initState() {
    super.initState();
    _award = GamificationService.lastAward;
    GamificationService.lastAward = null;
  }

  IconData get _icon {
    final percent = widget.total == 0 ? 0 : ((widget.score / widget.total) * 100).round();
    if (percent >= 70) return Icons.emoji_events;
    if (percent >= 50) return Icons.thumb_up_outlined;
    return Icons.menu_book_outlined;
  }

  Future<void> _openLesson(int id) async {
    final lesson = await LessonsRepository.instance.getLessonById(id);
    if (!mounted) return;
    if (lesson == null) {
      context.go('/learning');
      return;
    }
    context.go('/lesson/$id', extra: lesson);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final percent = widget.total == 0 ? 0 : ((widget.score / widget.total) * 100).round();
    final message = percent >= 70 ? l10n.greatJob : l10n.keepPracticing;
    final review = widget.reviewLessons;
    final firstReviewId = review.isNotEmpty ? review.first['id'] as int? : null;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppTheme.gold.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.gold.withValues(alpha: 0.4)),
                        ),
                        child: Icon(_icon, size: 48, color: AppTheme.gold),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.isPlacement
                          ? l10n.placementResultTitle
                          : (widget.isDailyChallenge ? l10n.dailyChallenge : l10n.quizArena),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${widget.score} / ${widget.total}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppTheme.gold),
                    ),
                    Text(
                      '$percent%',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: AppTheme.muted),
                    ),
                    if (_award != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        l10n.moduleTestCounted('+${_award!.awarded} ${pointsWord(_award!.awarded)}'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppTheme.accentText, fontWeight: FontWeight.w800),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      l10n.scoreResult(widget.score, widget.total),
                      style: const TextStyle(color: AppTheme.textSoft, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: const TextStyle(color: AppTheme.muted, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    if (widget.isPlacement) ...[
                      const SizedBox(height: 20),
                      if (review.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: AppTheme.cardDecoration(color: AppTheme.bullSoft),
                          child: Text(
                            l10n.placementNoGaps,
                            style: const TextStyle(height: 1.45),
                          ),
                        )
                      else ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: AppTheme.cardDecoration(color: AppTheme.bearSoft),
                          child: Text(
                            review.length == 1
                                ? l10n.placementOneGap
                                : l10n.placementManyGaps(review.length),
                            style: const TextStyle(height: 1.45),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.reviewThese,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        for (final item in review)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Material(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => _openLesson(item['id'] as int),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.menu_book_rounded, color: AppTheme.gold),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          l10n.lessonIdTitle(item['id'] as int, item['title'] as String),
                                          style: const TextStyle(fontWeight: FontWeight.w700, height: 1.3),
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right_rounded, color: AppTheme.muted),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ],
                  ],
                ),
              ),
              if (widget.isPlacement && firstReviewId != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _openLesson(firstReviewId),
                    child: Text(l10n.repeatLessonBtn(firstReviewId)),
                  ),
                )
              else if (widget.isPlacement)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/learning'),
                    child: Text(l10n.continueToLessons),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/quiz'),
                    child: Text(l10n.backToQuizArena),
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/'),
                  child: Text(l10n.goHome),
                ),
              ),
              if (!widget.isDailyChallenge && !widget.isPlacement) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go('/learning'),
                  child: Text(l10n.reviewLessons),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
