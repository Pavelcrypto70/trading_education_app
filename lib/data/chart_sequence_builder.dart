import 'dart:math' as math;

import '../widgets/lesson_charts.dart';

/// Детерминированные последовательности свечей для учебных графиков.
class ChartSequenceBuilder {
  ChartSequenceBuilder._();

  static CandleData c(double o, double h, double l, double cl) =>
      CandleData(open: o, high: h, low: l, close: cl);

  static double _wobble(int i, double amp) =>
      math.sin(i * 1.73 + 0.4) * amp + math.cos(i * 0.91) * amp * 0.45;

  /// Плавный восходящий тренд.
  static List<CandleData> trendUp(
    int count, {
    required double start,
    required double end,
    double noise = 0.8,
  }) {
    if (count <= 0) return [];
    final step = (end - start) / count;
    final out = <CandleData>[];
    var price = start;
    for (var i = 0; i < count; i++) {
      final drift = step + _wobble(i, noise * 0.15);
      final open = price;
      final close = price + drift;
      final wickUp = 0.4 + noise * 0.35 + (i.isEven ? 0.2 : 0);
      final wickDn = 0.35 + noise * 0.3;
      final high = math.max(open, close) + wickUp;
      final low = math.min(open, close) - wickDn;
      out.add(c(open, high, low, close));
      price = close;
    }
    return out;
  }

  /// Плавный нисходящий тренд.
  static List<CandleData> trendDown(
    int count, {
    required double start,
    required double end,
    double noise = 0.8,
  }) {
    if (count <= 0) return [];
    final step = (start - end) / count;
    final out = <CandleData>[];
    var price = start;
    for (var i = 0; i < count; i++) {
      final drift = step + _wobble(i + 3, noise * 0.15);
      final open = price;
      final close = price - drift;
      final wickUp = 0.35 + noise * 0.3;
      final wickDn = 0.4 + noise * 0.35 + (i.isEven ? 0.2 : 0);
      final high = math.max(open, close) + wickUp;
      final low = math.min(open, close) - wickDn;
      out.add(c(open, high, low, close));
      price = close;
    }
    return out;
  }

  /// Боковик вокруг центра.
  static List<CandleData> sideways(
    int count, {
    required double center,
    double amplitude = 2.5,
    double bias = 0,
  }) {
    final out = <CandleData>[];
    var price = center;
    for (var i = 0; i < count; i++) {
      final drift = _wobble(i, amplitude * 0.22) + bias;
      final open = price;
      final close = (center + drift).clamp(center - amplitude, center + amplitude);
      final high = math.max(open, close) + 0.35 + amplitude * 0.08;
      final low = math.min(open, close) - 0.35 - amplitude * 0.08;
      out.add(c(open, high, low, close));
      price = close;
    }
    return out;
  }

  /// Склейка нескольких фрагментов в одну серию.
  static List<CandleData> merge(List<List<CandleData>> parts) =>
      parts.expand((p) => p).toList();

  /// Контекст до сетапа: лёгкий тренд к первой свече ядра.
  static List<CandleData> contextBefore(List<CandleData> core, {int count = 10}) {
    if (core.isEmpty || count <= 0) return [];
    final anchor = core.first.open;
    return trendUp(count, start: anchor + 6, end: anchor + 0.5, noise: 0.6);
  }

  /// Контекст после сетапа: продолжение от последней свечи.
  static List<CandleData> contextAfter(List<CandleData> core, {int count = 4}) {
    if (core.isEmpty || count <= 0) return [];
    final anchor = core.last.close;
    return trendUp(count, start: anchor, end: anchor + 4, noise: 0.5);
  }

  /// Объёмы под количество свечей (базовый + всплеск на индексе).
  static List<double> volumes(int count, {int? spikeIndex, double spike = 2.2}) {
    final base = List<double>.generate(count, (i) => 28 + (i % 5) * 4 + _wobble(i, 6).abs());
    if (spikeIndex != null && spikeIndex >= 0 && spikeIndex < count) {
      base[spikeIndex] *= spike;
    }
    return base;
  }
}
