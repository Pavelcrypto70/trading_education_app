import 'dart:math' as math;

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
  final int? lessonId;
  final int cardIndex;

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
    this.lessonId,
    this.cardIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chartH = lessonId != null ? math.max(height, 320.0) : height;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.line.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppTheme.accent.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 0),
          ),
        ],
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
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Text(
                title!,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  height: 1.35,
                  color: AppTheme.text,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.bg2,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.lineSoft),
              ),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: chartH,
                width: double.infinity,
                child: LessonChartWidget(
                  chartType: chartType,
                  lessonId: lessonId,
                  cardIndex: cardIndex,
                ),
              ),
            ),
          ),
          if ((caption != null && caption!.isNotEmpty) || visual.showTradingViewNote)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (caption != null && caption!.isNotEmpty)
                  Text(
                    caption!,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.55,
                      color: AppTheme.muted,
                    ),
                  ),
                if (visual.showTradingViewNote) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.tradingViewStyleNote,
                    style: const TextStyle(fontSize: 11, color: AppTheme.faint),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.surface2, AppTheme.surface],
        ),
        border: Border(bottom: BorderSide(color: AppTheme.lineSoft)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppTheme.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            pair,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: AppTheme.accent,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(width: 10),
          _pill(timeframe),
          const SizedBox(width: 6),
          _pill(exchange),
          const Spacer(),
          const Icon(Icons.show_chart_rounded, size: 16, color: AppTheme.faint),
        ],
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.25)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: AppTheme.muted,
        ),
      ),
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
        color: AppTheme.accentDim,
        border: const Border(bottom: BorderSide(color: AppTheme.lineSoft)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.account_balance, size: 16, color: AppTheme.accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
                color: AppTheme.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
