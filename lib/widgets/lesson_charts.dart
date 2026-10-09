import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/lesson_chart_setups.dart';
import '../models/chart_setup.dart';
import 'order_book_diagram.dart';
import 'pattern_diagram_widget.dart';
import '../theme.dart';

class CandleData {
  final double open;
  final double high;
  final double low;
  final double close;

  const CandleData({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  bool get isBullish => close >= open;
}

class LessonChartWidget extends StatelessWidget {
  final String chartType;
  final int? lessonId;
  final int cardIndex;
  final double? height;

  const LessonChartWidget({
    super.key,
    required this.chartType,
    this.lessonId,
    this.cardIndex = 0,
    this.height,
  });

  static bool _isPatternType(String t) =>
      t.startsWith('pattern_') ||
      t == 'ascending_triangle' ||
      t == 'descending_triangle' ||
      t == 'symmetric_triangle' ||
      t == 'head_shoulders' ||
      t == 'inverse_head_shoulders' ||
      t == 'fibonacci' ||
      t == 'channel';

  static bool _isOrderBookType(String t) =>
      t == 'order_flow' ||
      t == 'order_book' ||
      t.startsWith('order_book_') ||
      t == 'ask_wall' ||
      t == 'bid_wall' ||
      t == 'spoof' ||
      t == 'spread';

  @override
  Widget build(BuildContext context) {
    if (_isPatternType(chartType)) {
      final h = height ?? 260.0;
      return PatternDiagramWidget(patternType: chartType, height: h);
    }
            if (_isOrderBookType(chartType)) {
      final h = height ?? 340.0;
      final scenario = OrderBookDiagram.fromChartType(chartType);
      final pair = scenario == OrderBookScenario.spread ? 'ALT/USDT' : 'BTC/USDT';
      return OrderBookDiagram(
        scenario: scenario,
        height: h,
        pair: pair,
      );
    }
    final setup = lessonId != null
        ? LessonChartSetups.forLesson(lessonId!, chartType, cardIndex: cardIndex)
        : LessonChartSetups.forChartType(chartType, cardIndex: cardIndex);
    final h = height ?? (lessonId != null ? 300.0 : 220.0);

    return SizedBox(
      height: h,
      width: double.infinity,
      child: CustomPaint(
        painter: _SetupChartPainter(setup: setup),
      ),
    );
  }
}

class _SetupChartPainter extends CustomPainter {
  final ChartSetup setup;

  _SetupChartPainter({required this.setup});

  static const _bullColor = Color(0xFF2AD49A);
  static const _bearColor = Color(0xFFFF5566);
  static const _gridColor = Color(0x22FFFFFF);
  static const _gold = Color(0xFF5AE2FF);

  static const _chartPadRight = 44.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chartH = setup.showVolume ? size.height * 0.72 : size.height;
    final chartW = size.width - _chartPadRight;
    final chartSize = Size(chartW, chartH);

    _drawBackground(canvas, chartSize);
    _drawGrid(canvas, chartSize);

    if (setup.candles.isEmpty) return;

    final bounds = _priceBounds(setup.candles);
    final lo = bounds.$1;
    final hi = bounds.$2;

    _drawPriceScale(canvas, chartSize, lo, hi);

    for (final zone in setup.zones) {
      _drawZone(canvas, chartSize, zone, lo, hi);
    }

    for (final level in setup.levels) {
      _drawLevel(canvas, chartSize, level, lo, hi);
    }

    for (final line in setup.lines) {
      _drawTrendLine(canvas, chartSize, line);
    }

    _drawCandles(canvas, chartSize, setup.candles, lo, hi);

    for (final marker in setup.markers) {
      _drawMarker(canvas, chartSize, marker, setup.candles, lo, hi);
    }

    for (final ann in setup.annotations) {
      _drawAnnotation(canvas, size, ann);
    }

    if (setup.showVolume && setup.volumes != null) {
      _drawVolume(canvas, Size(chartW, size.height), setup.volumes!, chartH);
    }
  }

  (double, double) _priceBounds(List<CandleData> candles) {
    final minVal = candles.map((c) => c.low).reduce(math.min);
    final maxVal = candles.map((c) => c.high).reduce(math.max);
    final pad = (maxVal - minVal) * 0.12 + 1;
    return (minVal - pad, maxVal + pad);
  }

  void _drawBackground(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AppTheme.bg2,
    );
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _gridColor
      ..strokeWidth = 1;
    for (var i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    final vLines = setup.candles.length > 16 ? 10 : 8;
    for (var i = 1; i < vLines; i++) {
      final x = size.width * i / vLines;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  void _drawPriceScale(Canvas canvas, Size size, double lo, double hi) {
    for (var i = 0; i <= 4; i++) {
      final t = i / 4;
      final price = lo + (hi - lo) * (1 - t);
      final y = size.height * t;
      final tp = TextPainter(
        text: TextSpan(
          text: price.toStringAsFixed(price >= 100 ? 0 : 1),
          style: const TextStyle(
            color: Color(0xFF95A3B8),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(size.width + 6, y - tp.height / 2));
    }
  }

  double _y(Size size, double val, double lo, double hi) {
    final range = hi - lo;
    if (range == 0) return size.height / 2;
    return size.height - ((val - lo) / range) * size.height;
  }

  void _drawCandles(Canvas canvas, Size size, List<CandleData> candles, double lo, double hi) {
    final gap = size.width / candles.length;
    final candleW = (gap * 0.72).clamp(2.5, 10.0);
    final wickW = candles.length > 18 ? 1.0 : 1.35;

    for (var i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = gap * i + gap / 2;
      final color = c.isBullish ? _bullColor : _bearColor;
      final bodyTop = _y(size, math.max(c.open, c.close), lo, hi);
      final bodyBot = _y(size, math.min(c.open, c.close), lo, hi);
      final bodyH = (bodyBot - bodyTop).abs();
      final wickPaint = Paint()
        ..color = color
        ..strokeWidth = wickW;
      canvas.drawLine(
        Offset(x, _y(size, c.high, lo, hi)),
        Offset(x, _y(size, c.low, lo, hi)),
        wickPaint,
      );
      if (bodyH < 1.2) {
        canvas.drawLine(
          Offset(x - candleW / 2, bodyTop),
          Offset(x + candleW / 2, bodyTop),
          Paint()
            ..color = color
            ..strokeWidth = 1.2,
        );
      } else {
        canvas.drawRect(
          Rect.fromLTRB(x - candleW / 2, bodyTop, x + candleW / 2, bodyBot),
          Paint()..color = color,
        );
      }
    }
  }

  void _drawLevel(Canvas canvas, Size size, ChartLevel level, double lo, double hi) {
    final y = _y(size, level.price, lo, hi);
    final paint = Paint()
      ..color = level.color.withValues(alpha: 0.9)
      ..strokeWidth = 1.5;
    if (level.dashed) {
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), paint);
    } else {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    _drawLabel(canvas, size, level.label, Offset(8, y - 22), level.color);
  }

  void _drawZone(Canvas canvas, Size size, ChartZone zone, double lo, double hi) {
    final top = _y(size, zone.top, lo, hi);
    final bottom = _y(size, zone.bottom, lo, hi);
    canvas.drawRect(
      Rect.fromLTRB(0, top, size.width, bottom),
      Paint()..color = zone.color,
    );
    if (zone.label != null) {
      _drawLabel(
        canvas,
        size,
        zone.label!,
        Offset(10, (top + bottom) / 2 - 10),
        const Color(0xFFF4F7FB),
      );
    }
  }

  void _drawTrendLine(Canvas canvas, Size size, ChartLine line) {
    final paint = Paint()
      ..color = line.color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final start = Offset(line.x1 * size.width, line.y1 * size.height);
    final end = Offset(line.x2 * size.width, line.y2 * size.height);
    if (line.dashed) {
      _drawDashedLine(canvas, start, end, paint);
    } else {
      canvas.drawLine(start, end, paint);
    }
    if (line.label != null) {
      _drawLabel(canvas, size, line.label!, Offset(end.dx - 80, end.dy - 24), line.color);
    }
  }

  void _drawMarker(
    Canvas canvas,
    Size size,
    ChartMarker marker,
    List<CandleData> candles,
    double lo,
    double hi,
  ) {
    if (marker.candleIndex < 0 || marker.candleIndex >= candles.length) return;
    final gap = size.width / candles.length;
    final x = gap * marker.candleIndex + gap / 2;
    final c = candles[marker.candleIndex];

    final color = switch (marker.kind) {
      ChartMarkerKind.entry || ChartMarkerKind.buy => _bullColor,
      ChartMarkerKind.stop => _bearColor,
      ChartMarkerKind.target || ChartMarkerKind.sell => _gold,
      ChartMarkerKind.note => AppTheme.textSoft,
    };

    // Prefer label above the candle so text does not sit on the body.
    final tipY = switch (marker.kind) {
      ChartMarkerKind.stop => _y(size, c.low, lo, hi) + 8,
      ChartMarkerKind.target || ChartMarkerKind.sell => _y(size, c.high, lo, hi) - 28,
      _ => _y(size, c.high, lo, hi) - 28,
    };

    final tip = Offset(x, tipY + 10);
    canvas.drawCircle(tip, 6, Paint()..color = const Color(0xFF03050A));
    canvas.drawCircle(tip, 5, Paint()..color = color);
    canvas.drawCircle(tip, 5, Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1);

    final labelX = (x + 10).clamp(8.0, size.width - 120);
    _drawLabel(canvas, size, marker.label, Offset(labelX, tipY - 4), color);
  }

  void _drawAnnotation(Canvas canvas, Size size, ChartAnnotation ann) {
    _drawLabel(
      canvas,
      size,
      ann.text,
      Offset(ann.x * size.width, ann.y * size.height),
      ann.color,
    );
  }

  void _drawVolume(Canvas canvas, Size size, List<double> volumes, double chartH) {
    final maxV = volumes.reduce(math.max);
    final barW = size.width / volumes.length * 0.5;
    final gap = size.width / volumes.length;
    final baseY = size.height * 0.97;
    for (var i = 0; i < volumes.length; i++) {
      final h = (volumes[i] / maxV) * (size.height - chartH) * 0.85;
      final x = gap * i + gap / 2;
      canvas.drawRect(
        Rect.fromLTRB(x - barW / 2, baseY - h, x + barW / 2, baseY),
        Paint()..color = _bullColor.withValues(alpha: 0.55),
      );
    }
    _drawLabel(
      canvas,
      Size(size.width, size.height),
      'Объём',
      Offset(8, chartH + 4),
      AppTheme.textSoft,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dash = 6.0;
    const gap = 4.0;
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final len = math.sqrt(dx * dx + dy * dy);
    if (len == 0) return;
    final ux = dx / len;
    final uy = dy / len;
    var dist = 0.0;
    while (dist < len) {
      final s = dist;
      final e = math.min(dist + dash, len);
      canvas.drawLine(
        Offset(start.dx + ux * s, start.dy + uy * s),
        Offset(start.dx + ux * e, start.dy + uy * e),
        paint,
      );
      dist += dash + gap;
    }
  }

  /// Prime chart labels: solid ink pill + white type, clamped inside the chart.
  void _drawLabel(Canvas canvas, Size size, String text, Offset pos, Color accent) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFFF4F7FB),
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          height: 1.15,
          letterSpacing: 0.15,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 2,
      ellipsis: '…',
    )..layout(maxWidth: math.min(168, size.width - 20));

    const padH = 9.0;
    const padV = 5.0;
    final w = tp.width + padH * 2;
    final h = tp.height + padV * 2;
    final x = pos.dx.clamp(4.0, math.max(4.0, size.width - w - 4)).toDouble();
    final y = pos.dy.clamp(4.0, math.max(4.0, size.height - h - 4)).toDouble();
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, y, w, h),
      const Radius.circular(8),
    );

    canvas.drawRRect(
      rect.shift(const Offset(0, 1.5)),
      Paint()..color = const Color(0x66000000),
    );
    canvas.drawRRect(rect, Paint()..color = const Color(0xF20C121C));
    canvas.drawRRect(
      rect,
      Paint()
        ..color = accent.withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    // Accent bar on the left edge of the pill.
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, 3, h),
        topLeft: const Radius.circular(8),
        bottomLeft: const Radius.circular(8),
      ),
      Paint()..color = accent,
    );
    tp.paint(canvas, Offset(x + padH, y + padV));
  }

  @override
  bool shouldRepaint(covariant _SetupChartPainter oldDelegate) =>
      oldDelegate.setup != setup;
}
