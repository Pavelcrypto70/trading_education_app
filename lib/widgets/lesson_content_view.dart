import 'package:flutter/material.dart';

import '../models/lesson_section.dart';
import '../services/locale_service.dart';
import '../theme.dart';
import 'lesson_charts.dart';
import 'lesson_practice_cards.dart';

class LessonContentView extends StatelessWidget {
  final List<LessonSection> sections;

  const LessonContentView({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          _buildSection(context, sections[i]),
        ],
      ],
    );
  }

  Widget _buildSection(BuildContext context, LessonSection section) {
    final l10n = context.l10n;

    switch (section.type) {
      case 'heading':
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            l10n.translateSectionHeading(section.title ?? ''),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.3,
            ),
          ),
        );
      case 'chart':
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.cardDecoration(color: AppTheme.surface),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (section.title != null) ...[
                Row(
                  children: [
                    const Icon(Icons.candlestick_chart, size: 16, color: AppTheme.gold),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        section.title!,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LessonChartWidget(chartType: section.chartType ?? 'price_chart'),
              ),
              if (section.caption != null) ...[
                const SizedBox(height: 12),
                Text(
                  section.caption!,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.white54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        );
      case 'tradingview':
        return LessonTradingViewCard(section: section);
      case 'market_note':
        return LessonMarketNoteCard(section: section);
      case 'example':
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: AppTheme.cardDecoration(color: AppTheme.accent.withValues(alpha: 0.08)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.play_circle_outline, size: 18, color: AppTheme.accent),
                  const SizedBox(width: 8),
                  Text(
                    l10n.sectionPracticalScenario,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.accent),
                  ),
                ],
              ),
              if (section.body != null) ...[
                const SizedBox(height: 10),
                Text(section.body!, style: const TextStyle(height: 1.6, color: Colors.white70)),
              ],
            ],
          ),
        );
      case 'tip':
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: AppTheme.cardDecoration(color: AppTheme.gold.withValues(alpha: 0.08)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.lightbulb_outline, size: 18, color: AppTheme.gold),
                  const SizedBox(width: 8),
                  Text(
                    l10n.sectionProTip,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.gold),
                  ),
                ],
              ),
              if (section.body != null) ...[
                const SizedBox(height: 10),
                Text(section.body!, style: const TextStyle(height: 1.6, color: Colors.white70)),
              ],
            ],
          ),
        );
      case 'bullets':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.sectionKeyPoints,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            ...?section.items?.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: Icon(Icons.circle, size: 6, color: AppTheme.gold),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(item, style: const TextStyle(height: 1.55, color: Colors.white70)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      default:
        return Text(
          section.body ?? '',
          style: const TextStyle(height: 1.65, color: Colors.white70, fontSize: 15),
        );
    }
  }
}
