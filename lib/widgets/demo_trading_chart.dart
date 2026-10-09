import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/demo_candle.dart';
import '../theme.dart';

/// Live candlestick chart for paper trading.
class DemoTradingChart extends StatelessWidget {
  final List<DemoCandle> candles;
  final double currentPrice;
  final double? entryPrice;
  final double? stopPrice;
  final double? targetPrice;
  final double height;
  final int visibleCandles;

  const DemoTradingChart({
    super.key,
    required this.candles,
    required this.currentPrice,
    this.entryPrice,
    this.stopPrice,
    this.targetPrice,
    this.height = 300,
    this.visibleCandles = 48,
  });

  @override
  Widget build(BuildContext context) {
    final slice = candles.length > visibleCandles
        ? candles.sublist(candles.length - visibleCandles)
        : candles;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _DemoChartPainter(
            candles: slice,
            currentPrice: currentPrice,
            entryPrice: entryPrice,
            stopPrice: stopPrice,
            targetPrice: targetPrice,
          ),
        ),
      ),
    );
  }
}

class _DemoChartPainter extends CustomPainter {
  final List<DemoCandle> candles;
  final double currentPrice;
  final double? entryPrice;
  final double? stopPrice;
  final double? targetPrice;

  _DemoChartPainter({
    required this.candles,
    required this.currentPrice,
    this.entryPrice,
    this.stopPrice,
    this.targetPrice,
  });

  static const _bullColor = AppTheme.bull;
  static const _bearColor = AppTheme.bear;
  static const _gridColor = Color(0x22FFFFFF);
  static const _padRight = 60.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chartW = size.width - _padRight;
    final chartSize = Size(chartW, size.height);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AppTheme.bg2,
    );

    if (candles.isEmpty) return;

    final scaleWindow = candles.length > 28 ? candles.sublist(candles.length - 28) : candles;
    final bounds = _priceBounds(scaleWindow);
    var lo = bounds.$1;
    var hi = bounds.$2;

    for (final level in [currentPrice, entryPrice, stopPrice, targetPrice]) {
      if (level != null) {
        lo = math.min(lo, level);
        hi = math.max(hi, level);
      }
    }
    final pad = (hi - lo) * 0.06 + 0.02;
    lo -= pad;
    hi += pad;

    _drawGrid(canvas, chartSize);
    _drawPriceScale(canvas, chartSize, lo, hi);

    if (stopPrice != null) {
      _drawLevel(canvas, chartSize, stopPrice!, lo, hi, _bearColor, 'SL');
    }
    if (targetPrice != null) {
      _drawLevel(canvas, chartSize, targetPrice!, lo, hi, AppTheme.gold, 'TP');
    }
    if (entryPrice != null) {
      _drawLevel(canvas, chartSize, entryPrice!, lo, hi, AppTheme.textSoft, 'Entry');
    }

    _drawLevel(
      canvas,
      chartSize,
      currentPrice,
      lo,
      hi,
      Colors.cyanAccent.withValues(alpha: 0.9),
      '',
      dashed: true,
      showLabel: false,
    );

    _drawCandles(canvas, chartSize, candles, lo, hi);

    final last = candles.last;
    final gap = chartSize.width / candles.length;
    final x = gap * (candles.length - 1) + gap / 2;
    final y = _y(chartSize, last.close, lo, hi);

    canvas.drawCircle(Offset(x, y), 4.5, Paint()..color = last.isBullish ? _bullColor : _bearColor);
    canvas.drawCircle(
      Offset(x, y),
      8,
      Paint()
        ..color = (last.isBullish ? _bullColor : _bearColor).withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    _drawLabel(
      canvas,
      _fmtPrice(currentPrice),
      Offset(chartSize.width - 54, y - 18),
      last.isBullish ? _bullColor : _bearColor,
    );
  }

  (double, double) _priceBounds(List<DemoCandle> candles) {
    final minVal = candles.map((c) => c.low).reduce(math.min);
    final maxVal = candles.map((c) => c.high).reduce(math.max);
    return (minVal, maxVal);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _gridColor
      ..strokeWidth = 1;
    for (var i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (var i = 1; i < 6; i++) {
      final x = size.width * i / 6;
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
        _fmtPrice(price),
        Offset(size.width + 2, y - 6),
        AppTheme.faint,
      );
    }
  }

  String _fmtPrice(double p) {
    if (p >= 100) return p.toStringAsFixed(2);
    if (p >= 1) return p.toStringAsFixed(3);
    return p.toStringAsFixed(4);
  }

  double _y(Size size, double val, double lo, double hi) {
    final range = hi - lo;
    if (range == 0) return size.height / 2;
    return size.height - ((val - lo) / range) * size.height;
  }

  void _drawCandles(Canvas canvas, Size size, List<DemoCandle> candles, double lo, double hi) {
    final gap = size.width / candles.length;
    final candleW = (gap * 0.72).clamp(3.0, 12.0);

    for (var i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = gap * i + gap / 2;
      final color = c.isBullish ? _bullColor : _bearColor;
      final bodyTop = _y(size, math.max(c.open, c.close), lo, hi);
      final bodyBot = _y(size, math.min(c.open, c.close), lo, hi);
      final bodyH = (bodyBot - bodyTop).abs();

      canvas.drawLine(
        Offset(x, _y(size, c.high, lo, hi)),
        Offset(x, _y(size, c.low, lo, hi)),
        Paint()
          ..color = color
          ..strokeWidth = 1.35,
      );

      if (bodyH < 1.0) {
        canvas.drawLine(
          Offset(x - candleW / 2, bodyTop),
          Offset(x + candleW / 2, bodyTop),
          Paint()
            ..color = color
            ..strokeWidth = 1.4,
        );
      } else {
        canvas.drawRRect(
          RRect.fromLTRBR(x - candleW / 2, bodyTop, x + candleW / 2, bodyBot, const Radius.circular(1)),
          Paint()..color = color,
        );
      }
    }
  }

  void _drawLevel(
    Canvas canvas,
    Size size,
    double price,
    double lo,
    double hi,
    Color color,
    String label, {
    bool dashed = true,
    bool showLabel = true,
  }) {
    final y = _y(size, price, lo, hi);
    final paint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..strokeWidth = label.isEmpty ? 1.0 : 1.2;

    if (dashed) {
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), paint);
    } else {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    if (showLabel && label.isNotEmpty) {
      _drawLabel(canvas, '$label ${_fmtPrice(price)}', Offset(6, y - 14), color);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dash = 5.0;
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
    )..layout(maxWidth: 56);
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant _DemoChartPainter old) =>
      old.candles != candles ||
      old.currentPrice != currentPrice ||
      old.entryPrice != entryPrice ||
      old.stopPrice != stopPrice ||
      old.targetPrice != targetPrice;
}
