import 'dart:math' as math;

import '../models/chart_setup.dart';
import '../services/locale_service.dart';
import '../theme.dart';
import '../widgets/lesson_charts.dart';
import 'chart_sequence_builder.dart';

/// Generates a **unique** chart per (lessonId, cardIndex) for the linear course.
/// Pedagogy gates annotations: no liquidation/stop/take before those lessons.
class LessonChartFactory {
  LessonChartFactory._();

  static const _bull = AppTheme.bull;
  static const _bear = AppTheme.bear;
  static const _gold = AppTheme.lavender;
  static const _purple = AppTheme.info;

  static ChartSetup forCard({
    required int lessonId,
    required int cardIndex,
    String chartType = 'candlestick',
  }) {
    final rng = math.Random(lessonId * 7919 + cardIndex * 104729 + chartType.hashCode);
    final stage = _stage(lessonId);
    final shape = _shape(rng, cardIndex, stage);

    final candles = _candlesFor(shape, rng);
    final levels = <ChartLevel>[];
    final markers = <ChartMarker>[];
    final zones = <ChartZone>[];
    final annotations = <ChartAnnotation>[];

    _annotate(
      stage: stage,
      shape: shape,
      cardIndex: cardIndex,
      candles: candles,
      levels: levels,
      markers: markers,
      zones: zones,
      annotations: annotations,
      rng: rng,
    );

    return ChartSetup(
      candles: candles,
      levels: levels,
      markers: markers,
      zones: zones,
      annotations: annotations,
      showVolume: cardIndex.isOdd && lessonId >= 8,
    );
  }

  static _Stage _stage(int id) {
    if (id <= 3) return _Stage.spot;
    if (id <= 7) return _Stage.futures;
    if (id <= 14) return _Stage.chart;
    if (id <= 27) return _Stage.levels;
    if (id <= 36) return _Stage.patterns;
    if (id <= 46) return _Stage.trade;
    if (id <= 51) return _Stage.market;
    return _Stage.risk;
  }

  static _Shape _shape(math.Random rng, int card, _Stage stage) {
    final pick = (card + rng.nextInt(3)) % 6;
    switch (pick) {
      case 0:
        return _Shape.up;
      case 1:
        return _Shape.down;
      case 2:
        return _Shape.dump;
      case 3:
        return _Shape.range;
      case 4:
        return _Shape.v;
      default:
        return stage == _Stage.levels || stage == _Stage.patterns ? _Shape.breakout : _Shape.up;
    }
  }

  static List<CandleData> _candlesFor(_Shape shape, math.Random rng) {
    final base = 55.0 + rng.nextInt(30);
    final amp = 1.4 + rng.nextDouble() * 1.2;
    switch (shape) {
      case _Shape.up:
        return ChartSequenceBuilder.merge([
          ChartSequenceBuilder.sideways(6, center: base, amplitude: amp),
          ChartSequenceBuilder.trendUp(12, start: base, end: base + 14 + rng.nextInt(6), noise: amp),
          ChartSequenceBuilder.sideways(4, center: base + 14, amplitude: amp * 0.7),
        ]);
      case _Shape.down:
        return ChartSequenceBuilder.merge([
          ChartSequenceBuilder.trendUp(6, start: base, end: base + 8, noise: amp),
          ChartSequenceBuilder.trendDown(14, start: base + 8, end: base - 10, noise: amp),
          ChartSequenceBuilder.sideways(4, center: base - 10, amplitude: amp * 0.6),
        ]);
      case _Shape.dump:
        return ChartSequenceBuilder.merge([
          ChartSequenceBuilder.trendUp(8, start: base, end: base + 12, noise: amp * 0.8),
          ChartSequenceBuilder.trendDown(10, start: base + 12, end: base - 8, noise: amp * 1.2),
          ChartSequenceBuilder.sideways(6, center: base - 6, amplitude: amp),
        ]);
      case _Shape.range:
        return ChartSequenceBuilder.sideways(22, center: base, amplitude: 3.2 + rng.nextDouble());
      case _Shape.v:
        return ChartSequenceBuilder.merge([
          ChartSequenceBuilder.trendDown(10, start: base + 10, end: base - 4, noise: amp),
          ChartSequenceBuilder.trendUp(12, start: base - 4, end: base + 12, noise: amp),
        ]);
      case _Shape.breakout:
        return ChartSequenceBuilder.merge([
          ChartSequenceBuilder.sideways(12, center: base, amplitude: 2.0),
          ChartSequenceBuilder.trendUp(10, start: base + 1, end: base + 14, noise: amp),
        ]);
    }
  }

  static void _annotate({
    required _Stage stage,
    required _Shape shape,
    required int cardIndex,
    required List<CandleData> candles,
    required List<ChartLevel> levels,
    required List<ChartMarker> markers,
    required List<ChartZone> zones,
    required List<ChartAnnotation> annotations,
    required math.Random rng,
  }) {
    final l10n = LocaleService.instance.strings;
    final lows = candles.map((c) => c.low).reduce(math.min);
    final highs = candles.map((c) => c.high).reduce(math.max);
    final mid = (lows + highs) / 2;
    final support = lows + (highs - lows) * 0.18;
    final resist = lows + (highs - lows) * 0.82;
    final n = candles.length;
    final entryIdx = (n * 0.45).floor().clamp(2, n - 3);

    switch (stage) {
      case _Stage.spot:
        annotations.add(ChartAnnotation(
          text: l10n.chartAnnSpotYours,
          x: 0.03,
          y: 0.06,
          color: _bull,
        ));
        if (shape == _Shape.dump || shape == _Shape.down) {
          levels.add(ChartLevel(price: support, label: l10n.chartAnnCoinStays, color: _purple));
          annotations.add(ChartAnnotation(
            text: l10n.chartAnnNoLiq,
            x: 0.62,
            y: 0.88,
            color: _gold,
          ));
        } else {
          levels.add(ChartLevel(price: mid, label: l10n.chartAnnHold, color: _bull, dashed: true));
        }
        markers.add(ChartMarker(
          candleIndex: entryIdx,
          label: shape == _Shape.dump || shape == _Shape.down ? l10n.chartAnnBought : l10n.chartLabelEntry,
          kind: ChartMarkerKind.buy,
        ));
        break;

      case _Stage.futures:
        annotations.add(ChartAnnotation(
          text: cardIndex.isEven ? l10n.chartAnnFuturesContract : l10n.chartAnnLeverageRisk,
          x: 0.03,
          y: 0.05,
          color: _gold,
        ));
        if (cardIndex >= 2 || shape == _Shape.dump) {
          final liqTop = support;
          final liqBottom = support - (highs - lows) * 0.22;
          zones.add(ChartZone(
            top: liqTop,
            bottom: liqBottom,
            color: _bear.withValues(alpha: 0.28),
            label: l10n.chartAnnLiqZone,
          ));
          levels.add(ChartLevel(
            price: support + (highs - lows) * 0.06,
            label: l10n.chartAnnStopBeforeLiq,
            color: _bear,
          ));
        } else {
          levels.add(ChartLevel(
            price: mid,
            label: l10n.chartAnnContractOnly,
            color: _gold,
            dashed: true,
          ));
        }
        markers.add(ChartMarker(
          candleIndex: entryIdx,
          label: l10n.chartAnnOpenedPosition,
          kind: ChartMarkerKind.entry,
        ));
        break;

      case _Stage.chart:
        annotations.add(ChartAnnotation(
          text: l10n.chartAnnCandles,
          x: 0.04,
          y: 0.08,
        ));
        if (cardIndex % 3 == 0) {
          markers.add(ChartMarker(candleIndex: entryIdx, label: l10n.chartAnnGreen, kind: ChartMarkerKind.buy));
        } else if (cardIndex % 3 == 1) {
          markers.add(ChartMarker(candleIndex: entryIdx + 1, label: l10n.chartAnnRed, kind: ChartMarkerKind.sell));
        } else {
          annotations.add(ChartAnnotation(text: l10n.chartAnnBodyWicks, x: 0.55, y: 0.2, color: _gold));
        }
        break;

      case _Stage.levels:
        levels.add(ChartLevel(price: support, label: l10n.patternLabelSupport, color: _purple));
        levels.add(ChartLevel(price: resist, label: l10n.patternLabelResistance, color: _bear));
        if (cardIndex.isOdd) {
          annotations.add(ChartAnnotation(text: l10n.chartAnnZoneNotLine, x: 0.55, y: 0.15, color: _gold));
          zones.add(ChartZone(top: support + 2, bottom: support - 2, color: _purple.withValues(alpha: 0.15)));
        }
        if (shape == _Shape.breakout) {
          markers.add(ChartMarker(candleIndex: n - 4, label: l10n.chartAnnBreakout, kind: ChartMarkerKind.note));
        }
        break;

      case _Stage.patterns:
        levels.add(ChartLevel(price: resist, label: l10n.chartAnnPatternTop, color: _bear, dashed: true));
        levels.add(ChartLevel(price: support, label: l10n.chartAnnPatternBottom, color: _purple, dashed: true));
        annotations.add(ChartAnnotation(text: l10n.chartAnnPatternOnChart, x: 0.05, y: 0.1, color: _gold));
        markers.add(ChartMarker(candleIndex: entryIdx, label: l10n.chartAnnLookHere, kind: ChartMarkerKind.note));
        break;

      case _Stage.trade:
        final stop = support - 1;
        final take = resist + 1;
        levels.add(ChartLevel(price: mid, label: l10n.chartLabelEntry, color: _gold));
        levels.add(ChartLevel(price: stop, label: l10n.chartLabelStop, color: _bear));
        levels.add(ChartLevel(price: take, label: l10n.chartLabelTake, color: _bull));
        annotations.add(ChartAnnotation(
          text: cardIndex.isEven ? l10n.chartAnnCheckRr : l10n.chartAnnStopTakeOnExchange,
          x: 0.05,
          y: 0.08,
          color: _gold,
        ));
        markers.add(ChartMarker(candleIndex: entryIdx, label: l10n.chartLabelEntry, kind: ChartMarkerKind.entry));
        markers.add(ChartMarker(candleIndex: entryIdx, label: l10n.chartLabelStop, kind: ChartMarkerKind.stop));
        markers.add(ChartMarker(
          candleIndex: (entryIdx + 4).clamp(0, n - 1),
          label: l10n.chartLabelTake,
          kind: ChartMarkerKind.target,
        ));
        break;

      case _Stage.market:
        annotations.add(ChartAnnotation(text: l10n.chartAnnMarketNow, x: 0.04, y: 0.1));
        levels.add(ChartLevel(price: mid, label: l10n.chartAnnAvgPrice, color: _gold, dashed: true));
        if (shape == _Shape.dump) {
          annotations.add(ChartAnnotation(text: l10n.chartAnnSharpDrop, x: 0.55, y: 0.85, color: _bear));
        }
        break;

      case _Stage.risk:
        levels.add(ChartLevel(price: support, label: l10n.chartAnnPlanCancelled, color: _bear));
        annotations.add(ChartAnnotation(
          text: cardIndex.isEven ? l10n.chartAnnRiskFirst : l10n.chartAnnJournalAfter,
          x: 0.04,
          y: 0.1,
          color: _gold,
        ));
        if (cardIndex >= 1) {
          zones.add(ChartZone(
            top: support,
            bottom: support - 5,
            color: _bear.withValues(alpha: 0.12),
            label: l10n.chartAnnNotHere,
          ));
        }
        break;
    }
  }
}

enum _Stage { spot, futures, chart, levels, patterns, trade, market, risk }

enum _Shape { up, down, dump, range, v, breakout }
