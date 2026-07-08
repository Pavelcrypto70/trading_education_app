import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/gamification_service.dart';
import '../services/locale_service.dart';
import '../theme.dart';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int total;
  final String title;
  final bool isDailyChallenge;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.title,
    this.isDailyChallenge = false,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  int? _xpGained;

  @override
  void initState() {
    super.initState();
    _awardXp();
  }

  Future<void> _awardXp() async {
    final amount = widget.isDailyChallenge
        ? GamificationService.xpPerDailyChallenge
        : GamificationService.xpPerQuiz;
    await GamificationService.addXp(amount);
    if (mounted) setState(() => _xpGained = amount);
  }

  IconData get _icon {
    final percent = widget.total == 0 ? 0 : ((widget.score / widget.total) * 100).round();
    if (percent >= 70) return Icons.emoji_events;
    if (percent >= 50) return Icons.thumb_up_outlined;
    return Icons.menu_book_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final percent = widget.total == 0 ? 0 : ((widget.score / widget.total) * 100).round();
    final message = percent >= 70 ? l10n.greatJob : l10n.keepPracticing;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.gold.withValues(alpha: 0.4)),
                ),
                child: Icon(_icon, size: 48, color: AppTheme.gold),
              ),
              const SizedBox(height: 24),
              Text(
                widget.isDailyChallenge ? l10n.dailyChallenge : l10n.quizArena,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '${widget.score} / ${widget.total}',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppTheme.gold),
              ),
              Text('$percent%', style: const TextStyle(fontSize: 18, color: Colors.white54)),
              if (_xpGained != null) ...[
                const SizedBox(height: 8),
                Text(l10n.xpEarned(_xpGained!), style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w700)),
              ],
              const SizedBox(height: 16),
              Text(l10n.scoreResult(widget.score, widget.total), style: const TextStyle(color: Colors.white70, height: 1.5), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(message, style: const TextStyle(color: Colors.white54, height: 1.5), textAlign: TextAlign.center),
              const Spacer(),
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
              if (!widget.isDailyChallenge) ...[
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
