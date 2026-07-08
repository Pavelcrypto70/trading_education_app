import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/lesson_chart_setups.dart';
import '../models/chart_setup.dart';

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

  const LessonChartWidget({
    super.key,
    required this.chartType,
    this.lessonId,
  });

  @override
  Widget build(BuildContext context) {
    final setup = lessonId != null
        ? LessonChartSetups.forLesson(lessonId!, chartType)
        : LessonChartSetups.forChartType(chartType);

    return SizedBox(
      height: lessonId != null ? 300 : 220,
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

  static const _bullColor = Color(0xFF26A69A);
  static const _bearColor = Color(0xFFEF5350);
  static const _gridColor = Color(0x22FFFFFF);
  static const _gold = Color(0xFFD4AF37);

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
      Paint()..color = const Color(0xFF0D1117),
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
      _drawLabel(
        canvas,
        price.toStringAsFixed(price >= 100 ? 0 : 1),
        Offset(size.width + 4, y - 6),
        Colors.white38,
      );
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
      ..color = level.color
      ..strokeWidth = 1.5;
    if (level.dashed) {
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), paint);
    } else {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    _drawLabel(canvas, level.label, Offset(8, y - 16), level.color);
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
        zone.label!,
        Offset(size.width * 0.52, (top + bottom) / 2 - 8),
        Colors.white54,
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
      _drawLabel(canvas, line.label!, Offset(end.dx - 72, end.dy - 18), line.color);
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
      ChartMarkerKind.note => Colors.white70,
    };

    final offsetY = switch (marker.kind) {
      ChartMarkerKind.stop => _y(size, c.low, lo, hi) + 10,
      ChartMarkerKind.target => _y(size, c.high, lo, hi) - 30,
      ChartMarkerKind.sell => _y(size, c.high, lo, hi) - 22,
      _ => _y(size, c.close, lo, hi) - 22,
    };

    canvas.drawCircle(Offset(x, offsetY + 6), 5, Paint()..color = color);
    _drawLabel(canvas, marker.label, Offset(x + 8, offsetY), color);
  }

  void _drawAnnotation(Canvas canvas, Size size, ChartAnnotation ann) {
    _drawLabel(
      canvas,
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
    _drawLabel(canvas, 'Объём', Offset(8, chartH + 4), Colors.white38);
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

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          shadows: const [Shadow(color: Colors.black87, blurRadius: 4)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 150);
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant _SetupChartPainter oldDelegate) =>
      oldDelegate.setup != setup;
}
