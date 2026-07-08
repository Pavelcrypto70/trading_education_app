import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/lesson.dart';
import '../models/lesson_section.dart';
import '../services/lesson_practice_service.dart';
import '../services/locale_service.dart';
import '../theme.dart';

class LessonInteractiveSection extends StatelessWidget {
  final Lesson lesson;
  final LessonSection section;

  const LessonInteractiveSection({
    super.key,
    required this.lesson,
    required this.section,
  });

  String get _symbol {
    for (final s in lesson.sections) {
      if (s.symbol != null) return s.symbol!.replaceFirst('BINANCE:', '');
    }
    return 'BTCUSDT';
  }

  @override
  Widget build(BuildContext context) {
    switch (section.type) {
      case 'tradingview':
        return LessonTradingViewCard(section: section);
      case 'practice':
        return LessonPracticeCard(
          section: section,
          lesson: lesson,
          symbol: _symbol,
        );
      case 'market_note':
        return LessonMarketNoteCard(section: section);
      case 'journal':
        return LessonJournalCard(section: section, lesson: lesson);
      default:
        return const SizedBox.shrink();
    }
  }
}

class LessonTradingViewCard extends StatelessWidget {
  final LessonSection section;

  const LessonTradingViewCard({super.key, required this.section});

  Future<void> _open(BuildContext context) async {
    final url = section.url ??
        'https://www.tradingview.com/chart/?symbol=BINANCE:${section.symbol ?? 'BTCUSDT'}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.tradingViewOpenError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(
        color: const Color(0xFF13192B),
        border: Border.all(color: const Color(0xFF2962FF).withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2962FF).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.open_in_new, color: Color(0xFF2962FF), size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  section.title ?? l10n.sectionTradingView,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ],
          ),
          if (section.symbol != null) ...[
            const SizedBox(height: 8),
            Text(
              '${section.symbol}${section.interval != null ? ' · ${section.interval}' : ''}',
              style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ],
          if (section.body != null) ...[
            const SizedBox(height: 10),
            Text(section.body!, style: const TextStyle(height: 1.6, color: Colors.white70)),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _open(context),
              icon: const Icon(Icons.candlestick_chart, size: 18),
              label: Text(l10n.openTradingView),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2962FF),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LessonPracticeCard extends StatelessWidget {
  final LessonSection section;
  final Lesson lesson;
  final String symbol;

  const LessonPracticeCard({
    super.key,
    required this.section,
    required this.lesson,
    required this.symbol,
  });

  Future<void> _startPaper(BuildContext context) async {
    final l10n = context.l10n;
    final scenario = section.body ?? lesson.takeaway;
    await LessonPracticeService.startPractice(
      lessonId: lesson.id,
      lessonTitle: lesson.title,
      symbol: symbol.contains('/') ? symbol : symbol.replaceAll('USDT', '/USDT'),
      scenario: scenario,
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.lessonPracticeStarted(lesson.id))),
      );
      context.go('/practice');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        border: Border.all(color: Colors.green.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fitness_center, color: Colors.greenAccent, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  section.title ?? l10n.sectionPractice,
                  style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.greenAccent),
                ),
              ),
            ],
          ),
          if (section.body != null) ...[
            const SizedBox(height: 10),
            Text(section.body!, style: const TextStyle(height: 1.6, color: Colors.white70)),
          ],
          if (section.items != null) ...[
            const SizedBox(height: 12),
            ...section.items!.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${e.key + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(e.value, style: const TextStyle(height: 1.5, color: Colors.white70)),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _startPaper(context),
              icon: const Icon(Icons.candlestick_chart_outlined),
              label: Text(l10n.practiceLessonSetup(lesson.id)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.withValues(alpha: 0.2),
                foregroundColor: Colors.greenAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LessonMarketNoteCard extends StatelessWidget {
  final LessonSection section;

  const LessonMarketNoteCard({super.key, required this.section});

  String _marketLabel(String? market, AppLocalizations l10n) {
    switch (market) {
      case 'br':
        return l10n.marketBrazil;
      case 'mx':
        return l10n.marketMexico;
      case 'latam':
        return l10n.marketLatam;
      case 'ru':
        return l10n.marketRussia;
      default:
        return l10n.marketGlobal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(
        color: AppTheme.gold.withValues(alpha: 0.07),
        border: Border.all(color: AppTheme.gold.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.public, color: AppTheme.gold, size: 18),
              const SizedBox(width: 8),
              Text(
                _marketLabel(section.market, l10n),
                style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.gold, fontSize: 12),
              ),
            ],
          ),
          if (section.title != null) ...[
            const SizedBox(height: 8),
            Text(section.title!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          ],
          if (section.body != null) ...[
            const SizedBox(height: 8),
            Text(section.body!, style: const TextStyle(height: 1.6, color: Colors.white70)),
          ],
        ],
      ),
    );
  }
}

class LessonJournalCard extends StatelessWidget {
  final LessonSection section;
  final Lesson lesson;

  const LessonJournalCard({super.key, required this.section, required this.lesson});

  void _openJournal(BuildContext context) {
    context.push(
      '/journal?lessonId=${lesson.id}&title=${Uri.encodeComponent(lesson.title)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(color: AppTheme.accent.withValues(alpha: 0.1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note, color: AppTheme.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                section.title ?? l10n.sectionJournal,
                style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.accent),
              ),
            ],
          ),
          if (section.body != null) ...[
            const SizedBox(height: 10),
            Text(section.body!, style: const TextStyle(height: 1.6, color: Colors.white70)),
          ],
          if (section.items != null) ...[
            const SizedBox(height: 10),
            ...section.items!.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_box_outline_blank, size: 16, color: Colors.white38),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item, style: const TextStyle(color: Colors.white60, height: 1.45))),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _openJournal(context),
              icon: const Icon(Icons.edit),
              label: Text(l10n.journalWriteEntry),
            ),
          ),
        ],
      ),
    );
  }
}
