import 'dart:math' as math;

import 'package:flutter/material.dart';

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

  const LessonChartWidget({super.key, required this.chartType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: CustomPaint(
        painter: _LessonChartPainter(chartType: chartType),
      ),
    );
  }
}

class _LessonChartPainter extends CustomPainter {
  final String chartType;

  _LessonChartPainter({required this.chartType});

  static const _bullColor = Color(0xFF26A69A);
  static const _bearColor = Color(0xFFEF5350);
  static const _gridColor = Color(0x22FFFFFF);
  static const _lineColor = Color(0xFFD4AF37);
  static const _supportColor = Color(0xFF6C5CE7);
  static const _resistColor = Color(0xFFEF5350);

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);
    switch (chartType) {
      case 'market_balance':
        _drawMarketBalance(canvas, size);
      case 'price_chart':
        _drawLineChart(canvas, size, _uptrendPoints());
      case 'candlestick':
        _drawCandles(canvas, size, _sampleCandles());
      case 'bullish_candle':
        _drawSingleCandle(canvas, size, const CandleData(open: 40, high: 90, low: 30, close: 80), center: true);
      case 'bearish_candle':
        _drawSingleCandle(canvas, size, const CandleData(open: 80, high: 90, low: 30, close: 40), center: true);
      case 'uptrend':
        _drawTrend(canvas, size, true);
      case 'downtrend':
        _drawTrend(canvas, size, false);
      case 'sideways':
        _drawSideways(canvas, size);
      case 'support_resistance':
        _drawSupportResistance(canvas, size);
      case 'breakout':
        _drawBreakout(canvas, size, false);
      case 'false_breakout':
        _drawBreakout(canvas, size, true);
      case 'pullback':
        _drawPullback(canvas, size);
      case 'structure':
        _drawStructure(canvas, size);
      case 'range_trading':
        _drawRangeTrading(canvas, size);
      case 'reversal':
        _drawReversal(canvas, size);
      case 'momentum':
        _drawMomentum(canvas, size);
      case 'volume_bars':
        _drawVolume(canvas, size);
      case 'risk_reward':
        _drawRiskReward(canvas, size);
      case 'order_flow':
        _drawOrderFlow(canvas, size);
      case 'session_timeline':
        _drawSessionTimeline(canvas, size);
      case 'correlation':
        _drawCorrelation(canvas, size);
      default:
        _drawLineChart(canvas, size, _uptrendPoints());
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _gridColor
      ..strokeWidth = 1;
    for (var i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (var i = 1; i < 6; i++) {
      final x = size.width * i / 6;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  void _drawMarketBalance(Canvas canvas, Size size) {
    // Mini price line — flat then rising when buyers dominate
    final pricePaint = Paint()
      ..color = _lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final pricePath = Path()
      ..moveTo(size.width * 0.05, size.height * 0.72)
      ..lineTo(size.width * 0.35, size.height * 0.70)
      ..lineTo(size.width * 0.55, size.height * 0.55)
      ..lineTo(size.width * 0.95, size.height * 0.28);
    canvas.drawPath(pricePath, pricePaint);
    _drawLabel(canvas, 'Price', Offset(size.width * 0.82, size.height * 0.18), _lineColor);

    // Balance scale
    final cx = size.width * 0.28;
    final cy = size.height * 0.78;
    final scalePaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 2;
    canvas.drawLine(Offset(cx, cy - 35), Offset(cx, cy + 25), scalePaint);
    canvas.drawLine(Offset(cx - 45, cy), Offset(cx + 45, cy), scalePaint);

    _drawLabel(canvas, 'Sellers', Offset(cx + 8, cy - 28), _bearColor);
    _drawLabel(canvas, 'Buyers', Offset(cx - 52, cy + 6), _bullColor);

    // Arrows showing imbalance
    final buyArrow = Paint()..color = _bullColor..strokeWidth = 2;
    canvas.drawLine(Offset(cx - 20, cy - 8), Offset(cx - 20, cy - 22), buyArrow);
    canvas.drawLine(Offset(cx - 26, cy - 16), Offset(cx - 20, cy - 22), buyArrow);
    canvas.drawLine(Offset(cx - 14, cy - 16), Offset(cx - 20, cy - 22), buyArrow);

    _drawLabel(canvas, 'More buyers', Offset(size.width * 0.42, size.height * 0.82), _bullColor);
    _drawLabel(canvas, 'Price rises', Offset(size.width * 0.62, size.height * 0.48), _bullColor);
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  List<CandleData> _sampleCandles() => const [
        CandleData(open: 50, high: 65, low: 45, close: 60),
        CandleData(open: 60, high: 70, low: 55, close: 58),
        CandleData(open: 58, high: 75, low: 56, close: 72),
        CandleData(open: 72, high: 78, low: 65, close: 68),
        CandleData(open: 68, high: 85, low: 66, close: 82),
        CandleData(open: 82, high: 88, low: 75, close: 78),
        CandleData(open: 78, high: 92, low: 76, close: 90),
      ];

  List<CandleData> _uptrendCandles() => const [
        CandleData(open: 30, high: 40, low: 28, close: 38),
        CandleData(open: 38, high: 48, low: 36, close: 45),
        CandleData(open: 45, high: 50, low: 42, close: 44),
        CandleData(open: 44, high: 55, low: 43, close: 53),
        CandleData(open: 53, high: 62, low: 51, close: 60),
        CandleData(open: 60, high: 68, low: 58, close: 65),
        CandleData(open: 65, high: 78, low: 63, close: 75),
        CandleData(open: 75, high: 85, low: 72, close: 82),
      ];

  List<CandleData> _downtrendCandles() => const [
        CandleData(open: 82, high: 85, low: 72, close: 75),
        CandleData(open: 75, high: 78, low: 65, close: 68),
        CandleData(open: 68, high: 72, low: 58, close: 62),
        CandleData(open: 62, high: 65, low: 52, close: 55),
        CandleData(open: 55, high: 58, low: 45, close: 48),
        CandleData(open: 48, high: 52, low: 38, close: 42),
        CandleData(open: 42, high: 45, low: 32, close: 35),
      ];

  List<CandleData> _rangeCandles() => const [
        CandleData(open: 55, high: 72, low: 52, close: 68),
        CandleData(open: 68, high: 74, low: 58, close: 60),
        CandleData(open: 60, high: 73, low: 55, close: 70),
        CandleData(open: 70, high: 75, low: 58, close: 58),
        CandleData(open: 58, high: 72, low: 54, close: 66),
        CandleData(open: 66, high: 74, low: 57, close: 59),
        CandleData(open: 59, high: 73, low: 56, close: 69),
      ];

  void _drawCandles(Canvas canvas, Size size, List<CandleData> candles) {
    if (candles.isEmpty) return;
    final minVal = candles.map((c) => c.low).reduce(math.min);
    final maxVal = candles.map((c) => c.high).reduce(math.max);
    final pad = (maxVal - minVal) * 0.1 + 1;
    final lo = minVal - pad;
    final hi = maxVal + pad;
    final candleW = size.width / candles.length * 0.55;
    final gap = size.width / candles.length;

    for (var i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = gap * i + gap / 2;
      _drawCandleAt(canvas, size, c, x, candleW, lo, hi);
    }
  }

  void _drawSingleCandle(Canvas canvas, Size size, CandleData c, {bool center = false}) {
    final x = center ? size.width / 2 : size.width * 0.5;
    _drawCandleAt(canvas, size, c, x, size.width * 0.15, c.low - 10, c.high + 10);
    if (center) {
      _drawLabel(canvas, 'Open', Offset(x - 50, _y(size, c.open, c.low - 10, c.high + 10)), Colors.white54);
      _drawLabel(canvas, 'Close', Offset(x + 10, _y(size, c.close, c.low - 10, c.high + 10)), Colors.white54);
      _drawLabel(canvas, 'High', Offset(x + 10, _y(size, c.high, c.low - 10, c.high + 10) - 14), Colors.white54);
      _drawLabel(canvas, 'Low', Offset(x + 10, _y(size, c.low, c.low - 10, c.high + 10) + 2), Colors.white54);
    }
  }

  void _drawCandleAt(Canvas canvas, Size size, CandleData c, double x, double w, double lo, double hi) {
    final color = c.isBullish ? _bullColor : _bearColor;
    final bodyTop = _y(size, math.max(c.open, c.close), lo, hi);
    final bodyBot = _y(size, math.min(c.open, c.close), lo, hi);
    final wickPaint = Paint()
      ..color = color
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(x, _y(size, c.high, lo, hi)),
      Offset(x, _y(size, c.low, lo, hi)),
      wickPaint,
    );
    final bodyPaint = Paint()..color = color;
    canvas.drawRect(
      Rect.fromLTRB(x - w / 2, bodyTop, x + w / 2, bodyBot),
      bodyPaint,
    );
  }

  double _y(Size size, double val, double lo, double hi) {
    final range = hi - lo;
    if (range == 0) return size.height / 2;
    return size.height - ((val - lo) / range) * size.height;
  }

  List<Offset> _uptrendPoints() => [];

  void _drawLineChart(Canvas canvas, Size size, List<Offset> points) {
    final pts = [
      Offset(size.width * 0.05, size.height * 0.75),
      Offset(size.width * 0.2, size.height * 0.65),
      Offset(size.width * 0.35, size.height * 0.55),
      Offset(size.width * 0.5, size.height * 0.45),
      Offset(size.width * 0.65, size.height * 0.35),
      Offset(size.width * 0.8, size.height * 0.28),
      Offset(size.width * 0.95, size.height * 0.2),
    ];
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }
    final paint = Paint()
      ..color = _lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }

  void _drawTrend(Canvas canvas, Size size, bool up) {
    final candles = up ? _uptrendCandles() : _downtrendCandles();
    _drawCandles(canvas, size, candles);
    final trendPaint = Paint()
      ..color = _lineColor.withValues(alpha: 0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    if (up) {
      canvas.drawLine(
        Offset(size.width * 0.08, size.height * 0.82),
        Offset(size.width * 0.92, size.height * 0.18),
        trendPaint,
      );
    } else {
      canvas.drawLine(
        Offset(size.width * 0.08, size.height * 0.18),
        Offset(size.width * 0.92, size.height * 0.82),
        trendPaint,
      );
    }
  }

  void _drawSideways(Canvas canvas, Size size) {
    _drawCandles(canvas, size, _rangeCandles());
    final zone = Paint()
      ..color = _supportColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTRB(0, size.height * 0.25, size.width, size.height * 0.65),
      zone,
    );
  }

  void _drawSupportResistance(Canvas canvas, Size size) {
    _drawCandles(canvas, size, _rangeCandles());
    _drawLevel(canvas, size, size.height * 0.25, 'Resistance', _resistColor);
    _drawLevel(canvas, size, size.height * 0.72, 'Support', _supportColor);
  }

  void _drawLevel(Canvas canvas, Size size, double y, String label, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    _drawLabel(canvas, label, Offset(8, y - 16), color);
  }

  void _drawBreakout(Canvas canvas, Size size, bool isFalse) {
    final candles = [
      ..._rangeCandles().sublist(0, 5),
      if (isFalse)
        const CandleData(open: 70, high: 78, low: 58, close: 60)
      else
        const CandleData(open: 70, high: 88, low: 68, close: 85),
      if (isFalse)
        const CandleData(open: 60, high: 72, low: 55, close: 65)
      else
        const CandleData(open: 85, high: 95, low: 80, close: 92),
    ];
    _drawCandles(canvas, size, candles);
    _drawLevel(canvas, size, size.height * 0.28, 'Level', _resistColor);
  }

  void _drawPullback(Canvas canvas, Size size) {
    final candles = [
      ..._uptrendCandles().sublist(0, 5),
      const CandleData(open: 60, high: 62, low: 50, close: 52),
      const CandleData(open: 52, high: 58, low: 48, close: 55),
      const CandleData(open: 55, high: 70, low: 53, close: 68),
      const CandleData(open: 68, high: 82, low: 65, close: 80),
    ];
    _drawCandles(canvas, size, candles);
    final trendPaint = Paint()
      ..color = _lineColor.withValues(alpha: 0.5)
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(size.width * 0.05, size.height * 0.85),
      Offset(size.width * 0.95, size.height * 0.15),
      trendPaint,
    );
  }

  void _drawStructure(Canvas canvas, Size size) {
    _drawTrend(canvas, size, true);
    final dot = Paint()..color = _lineColor;
    final labels = ['HH', 'HL', 'HH', 'HL'];
    final xs = [0.15, 0.35, 0.6, 0.82];
    final ys = [0.7, 0.55, 0.35, 0.45];
    for (var i = 0; i < labels.length; i++) {
      final x = size.width * xs[i];
      final y = size.height * ys[i];
      canvas.drawCircle(Offset(x, y), 4, dot);
      _drawLabel(canvas, labels[i], Offset(x + 6, y - 14), _lineColor);
    }
  }

  void _drawRangeTrading(Canvas canvas, Size size) {
    _drawSupportResistance(canvas, size);
    final entry = Paint()..color = _bullColor;
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.68), 5, entry);
    _drawLabel(canvas, 'Buy', Offset(size.width * 0.38, size.height * 0.62), _bullColor);
    final exit = Paint()..color = _bearColor;
    canvas.drawCircle(Offset(size.width * 0.55, size.height * 0.3), 5, exit);
    _drawLabel(canvas, 'Sell', Offset(size.width * 0.58, size.height * 0.24), _bearColor);
  }

  void _drawReversal(Canvas canvas, Size size) {
    final candles = [
      ..._uptrendCandles().sublist(0, 5),
      const CandleData(open: 75, high: 78, low: 55, close: 58),
      const CandleData(open: 58, high: 62, low: 45, close: 48),
      const CandleData(open: 48, high: 52, low: 38, close: 40),
    ];
    _drawCandles(canvas, size, candles);
  }

  void _drawMomentum(Canvas canvas, Size size) {
    final candles = [
      const CandleData(open: 50, high: 55, low: 48, close: 52),
      const CandleData(open: 52, high: 60, low: 51, close: 58),
      const CandleData(open: 58, high: 72, low: 57, close: 70),
      const CandleData(open: 70, high: 88, low: 68, close: 85),
      const CandleData(open: 85, high: 95, low: 82, close: 92),
    ];
    _drawCandles(canvas, size, candles);
  }

  void _drawVolume(Canvas canvas, Size size) {
    _drawCandles(canvas, Size(size.width, size.height * 0.65), _sampleCandles());
    final volumes = [30.0, 45, 55, 40, 70, 50, 85];
    final maxV = volumes.reduce(math.max);
    final barW = size.width / volumes.length * 0.5;
    final gap = size.width / volumes.length;
    final baseY = size.height * 0.95;
    for (var i = 0; i < volumes.length; i++) {
      final h = (volumes[i] / maxV) * size.height * 0.25;
      final x = gap * i + gap / 2;
      final paint = Paint()..color = _bullColor.withValues(alpha: 0.5);
      canvas.drawRect(
        Rect.fromLTRB(x - barW / 2, baseY - h, x + barW / 2, baseY),
        paint,
      );
    }
    _drawLabel(canvas, 'Volume', Offset(8, size.height * 0.72), Colors.white38);
  }

  void _drawRiskReward(Canvas canvas, Size size) {
    _drawCandles(canvas, size, _uptrendCandles().sublist(0, 5));
    final entry = size.height * 0.55;
    final stop = size.height * 0.78;
    final target = size.height * 0.2;
    _drawLevel(canvas, size, entry, 'Entry', _lineColor);
    _drawLevel(canvas, size, stop, 'Stop', _bearColor);
    _drawLevel(canvas, size, target, 'Target', _bullColor);
    final zone = Paint()..color = _bearColor.withValues(alpha: 0.08)..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTRB(0, entry, size.width, stop), zone);
    final reward = Paint()..color = _bullColor.withValues(alpha: 0.08)..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTRB(0, target, size.width, entry), reward);
  }

  void _drawOrderFlow(Canvas canvas, Size size) {
    final mid = size.height / 2;
    _drawLabel(canvas, 'Bids (Buy)', Offset(8, mid + 20), _bullColor);
    _drawLabel(canvas, 'Asks (Sell)', Offset(8, mid - 40), _bearColor);
    for (var i = 0; i < 5; i++) {
      final w = size.width * (0.3 + i * 0.08);
      final y = mid + 10 + i * 14.0;
      canvas.drawRect(
        Rect.fromLTWH(size.width / 2 - w, y, w, 10),
        Paint()..color = _bullColor.withValues(alpha: 0.4 + i * 0.1),
      );
    }
    for (var i = 0; i < 5; i++) {
      final w = size.width * (0.25 + i * 0.07);
      final y = mid - 60 + i * 14.0;
      canvas.drawRect(
        Rect.fromLTWH(size.width / 2, y, w, 10),
        Paint()..color = _bearColor.withValues(alpha: 0.35 + i * 0.1),
      );
    }
  }

  void _drawSessionTimeline(Canvas canvas, Size size) {
    final sessions = [
      ('Asia', 0.0, 0.25, _supportColor),
      ('London', 0.25, 0.55, _lineColor),
      ('New York', 0.55, 1.0, _bullColor),
    ];
    for (final (name, start, end, color) in sessions) {
      canvas.drawRect(
        Rect.fromLTRB(size.width * start, size.height * 0.4, size.width * end, size.height * 0.6),
        Paint()..color = color.withValues(alpha: 0.3),
      );
      _drawLabel(
        canvas,
        name,
        Offset(size.width * (start + end) / 2 - 20, size.height * 0.45),
        color,
      );
    }
    _drawLabel(canvas, '24h Timeline', Offset(8, 8), Colors.white38);
  }

  void _drawCorrelation(Canvas canvas, Size size) {
    _drawLineChart(canvas, Size(size.width, size.height * 0.45), []);
    final paint2 = Paint()
      ..color = _supportColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width * 0.05, size.height * 0.55)
      ..lineTo(size.width * 0.25, size.height * 0.48)
      ..lineTo(size.width * 0.45, size.height * 0.42)
      ..lineTo(size.width * 0.65, size.height * 0.35)
      ..lineTo(size.width * 0.95, size.height * 0.28);
    canvas.drawPath(path, paint2);
    _drawLabel(canvas, 'Asset A', Offset(8, 8), _lineColor);
    _drawLabel(canvas, 'Asset B', Offset(8, size.height * 0.5), _supportColor);
  }

  @override
  bool shouldRepaint(covariant _LessonChartPainter oldDelegate) =>
      oldDelegate.chartType != chartType;
}
