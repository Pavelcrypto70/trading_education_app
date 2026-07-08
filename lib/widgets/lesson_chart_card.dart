import 'package:flutter/material.dart';

import '../services/locale_service.dart';
import '../theme.dart';
import '../utils/chart_visual_context.dart';
import 'lesson_charts.dart';

/// Lesson chart card — crypto price charts OR concept diagrams depending on topic.
class LessonChartCard extends StatelessWidget {
  final String chartType;
  final String? title;
  final String? caption;
  final String pair;
  final String timeframe;
  final String exchange;
  final ChartVisualContext visual;
  final double height;

  const LessonChartCard({
    super.key,
    required this.chartType,
    required this.visual,
    this.title,
    this.caption,
    this.pair = 'BTC/USDT',
    this.timeframe = '4H',
    this.exchange = 'Binance',
    this.height = 240,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF131722),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (visual.showCryptoHeader)
            _CryptoHeader(pair: pair, timeframe: timeframe, exchange: exchange)
          else
            _ConceptHeader(title: visual.conceptTitle ?? l10n.sectionChartExample),
          if (title != null && title!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Text(
                title!,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, height: 1.35),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: LessonChartWidget(chartType: chartType),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (caption != null && caption!.isNotEmpty)
                  Text(
                    caption!,
                    style: const TextStyle(fontSize: 13, height: 1.55, color: Colors.white70),
                  )
                else
                  Text(
                    l10n.chartExplainCaption,
                    style: const TextStyle(fontSize: 13, height: 1.55, color: Colors.white54),
                  ),
                if (visual.showTradingViewNote) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.tradingViewStyleNote,
                    style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.35)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CryptoHeader extends StatelessWidget {
  final String pair;
  final String timeframe;
  final String exchange;

  const _CryptoHeader({
    required this.pair,
    required this.timeframe,
    required this.exchange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
      ),
      child: Row(
        children: [
          Text(
            pair,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.gold),
          ),
          const SizedBox(width: 8),
          _pill(timeframe),
          const SizedBox(width: 6),
          _pill(exchange),
        ],
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.white54)),
    );
  }
}

class _ConceptHeader extends StatelessWidget {
  final String title;

  const _ConceptHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.gold.withValues(alpha: 0.1),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance, size: 18, color: AppTheme.gold),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
