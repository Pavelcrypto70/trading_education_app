import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Clear schematic pattern diagrams — animated line drawing for lesson cards.
class PatternDiagramWidget extends StatefulWidget {
  final String patternType;
  final double height;

  const PatternDiagramWidget({
    super.key,
    required this.patternType,
    this.height = 220,
  });

  @override
  State<PatternDiagramWidget> createState() => _PatternDiagramWidgetState();
}

class _PatternDiagramWidgetState extends State<PatternDiagramWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))
      ..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => CustomPaint(
          painter: _PatternPainter(
            patternType: widget.patternType,
            progress: Curves.easeOutCubic.transform(_ctrl.value),
          ),
        ),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  final String patternType;
  final double progress;

  _PatternPainter({required this.patternType, required this.progress});

  static const _bull = AppTheme.bull;
  static const _bear = AppTheme.bear;
  static const _gold = AppTheme.gold;
  static const _line = Color(0xAAFFFFFF);
  static const _grid = Color(0x18FFFFFF);

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);
    switch (patternType) {
      case 'pattern_asc_triangle':
      case 'ascending_triangle':
        _ascTriangle(canvas, size);
      case 'pattern_desc_triangle':
      case 'descending_triangle':
        _descTriangle(canvas, size);
      case 'pattern_sym_triangle':
      case 'symmetric_triangle':
        _symTriangle(canvas, size);
      case 'pattern_head_shoulders':
      case 'head_shoulders':
        _headShoulders(canvas, size, inverse: false);
      case 'pattern_head_shoulders_inv':
      case 'inverse_head_shoulders':
        _headShoulders(canvas, size, inverse: true);
      case 'pattern_channel':
      case 'channel':
        _channel(canvas, size);
      case 'pattern_wedge_up':
        _wedge(canvas, size, up: true);
      case 'pattern_wedge_down':
        _wedge(canvas, size, up: false);
      case 'pattern_fibonacci':
      case 'fibonacci':
        _fibonacci(canvas, size);
      case 'pattern_double_top':
        _doubleTop(canvas, size);
      case 'pattern_double_bottom':
        _doubleBottom(canvas, size);
      default:
        _ascTriangle(canvas, size);
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final p = Paint()..color = _grid..strokeWidth = 1;
    for (var i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
    for (var i = 1; i < 8; i++) {
      final x = size.width * i / 8;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
  }

  void _drawPolyline(Canvas canvas, List<Offset> pts, Color color, {double width = 2.5, bool dashed = false}) {
    if (pts.length < 2) return;
    final total = pts.length - 1;
    final endSeg = (progress * total).floor().clamp(0, total);
    final partial = (progress * total) - endSeg;

    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (!dashed) {
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (var i = 1; i <= endSeg; i++) {
        path.lineTo(pts[i].dx, pts[i].dy);
      }
      if (endSeg < total && partial > 0) {
        final a = pts[endSeg];
        final b = pts[endSeg + 1];
        path.lineTo(a.dx + (b.dx - a.dx) * partial, a.dy + (b.dy - a.dy) * partial);
      }
      canvas.drawPath(path, paint);
      return;
    }

    for (var i = 0; i < endSeg; i++) {
      _drawDashedLine(canvas, pts[i], pts[i + 1], paint);
    }
    if (endSeg < total && partial > 0) {
      final a = pts[endSeg];
      final b = pts[endSeg + 1];
      _drawDashedLine(canvas, a, Offset(a.dx + (b.dx - a.dx) * partial, a.dy + (b.dy - a.dy) * partial), paint);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dash = 6.0;
    const gap = 4.0;
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    final len = math.sqrt(dx * dx + dy * dy);
    if (len < 1) return;
    final ux = dx / len;
    final uy = dy / len;
    var dist = 0.0;
    while (dist < len) {
      final start = Offset(a.dx + ux * dist, a.dy + uy * dist);
      final endDist = (dist + dash).clamp(0.0, len);
      final end = Offset(a.dx + ux * endDist, a.dy + uy * endDist);
      canvas.drawLine(start, end, paint);
      dist += dash + gap;
    }
  }

  void _drawHLine(Canvas canvas, Size size, double yFrac, Color color, {String? label}) {
    if (progress < 0.15) return;
    final y = size.height * yFrac;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final w = ((progress - 0.15) / 0.85).clamp(0.0, 1.0);
    canvas.drawLine(Offset(size.width * 0.08, y), Offset(size.width * (0.08 + 0.84 * w), y), paint);
    if (label != null && w > 0.9) {
      final tp = TextPainter(
        text: TextSpan(text: label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(size.width * 0.86, y - 6));
    }
  }

  void _ascTriangle(Canvas canvas, Size size) {
    // Flat resistance (horizontal) + rising lows → breakout up.
    final w = size.width;
    final h = size.height;
    const resY = 0.30;
    final price = [
      Offset(w * 0.08, h * 0.72),
      Offset(w * 0.20, h * resY),
      Offset(w * 0.32, h * 0.62),
      Offset(w * 0.44, h * resY),
      Offset(w * 0.56, h * 0.52),
      Offset(w * 0.68, h * resY),
      Offset(w * 0.78, h * 0.42),
      Offset(w * 0.92, h * 0.18),
    ];
    _drawPolyline(canvas, price, _bull, width: 3);
    _drawHLine(canvas, size, resY, _bear, label: 'Сопротивление');
    _drawPolyline(
      canvas,
      [Offset(w * 0.08, h * 0.72), Offset(w * 0.78, h * 0.42)],
      _gold,
      width: 2,
      dashed: true,
    );
    if (progress > 0.85) {
      _label(canvas, size, 'Восходящий треугольник', h * 0.10);
    }
  }

  void _descTriangle(Canvas canvas, Size size) {
    // Flat support (horizontal) + lower highs → breakout down.
    final w = size.width;
    final h = size.height;
    const supY = 0.70;
    final price = [
      Offset(w * 0.08, h * 0.26),
      Offset(w * 0.20, h * supY),
      Offset(w * 0.32, h * 0.34),
      Offset(w * 0.44, h * (supY - 0.02)),
      Offset(w * 0.56, h * 0.42),
      Offset(w * 0.68, h * (supY - 0.01)),
      Offset(w * 0.78, h * 0.50),
      Offset(w * 0.92, h * 0.86),
    ];
    _drawPolyline(canvas, price, _bear, width: 3);
    _drawHLine(canvas, size, supY, _bull, label: 'Поддержка');
    _drawPolyline(
      canvas,
      [Offset(w * 0.08, h * 0.26), Offset(w * 0.78, h * 0.50)],
      _gold,
      width: 2,
      dashed: true,
    );
    if (progress > 0.85) _label(canvas, size, 'Нисходящий треугольник', h * 0.10);
  }

  void _symTriangle(Canvas canvas, Size size) {
    // Converging highs↓ + lows↑ — lines meet near apex, do not cross.
    final w = size.width;
    final h = size.height;
    final price = [
      Offset(w * 0.08, h * 0.28),
      Offset(w * 0.24, h * 0.72),
      Offset(w * 0.40, h * 0.36),
      Offset(w * 0.55, h * 0.62),
      Offset(w * 0.68, h * 0.44),
      Offset(w * 0.80, h * 0.52),
      Offset(w * 0.92, h * 0.30),
    ];
    _drawPolyline(canvas, price, _line, width: 3);
    _drawPolyline(
      canvas,
      [Offset(w * 0.08, h * 0.28), Offset(w * 0.80, h * 0.48)],
      _bear,
      width: 2,
      dashed: true,
    );
    _drawPolyline(
      canvas,
      [Offset(w * 0.08, h * 0.72), Offset(w * 0.80, h * 0.54)],
      _bull,
      width: 2,
      dashed: true,
    );
    if (progress > 0.85) _label(canvas, size, 'Симметричный треугольник', h * 0.10);
  }

  void _headShoulders(Canvas canvas, Size size, {required bool inverse}) {
    final w = size.width;
    final h = size.height;
    // Classic: LS → trough → HEAD → trough → RS → break below neck.
    // Inverse: LS → peak → HEAD → peak → RS → break above neck.
    final pts = inverse
        ? [
            Offset(w * 0.06, h * 0.42),
            Offset(w * 0.18, h * 0.68),
            Offset(w * 0.32, h * 0.40),
            Offset(w * 0.48, h * 0.84),
            Offset(w * 0.62, h * 0.38),
            Offset(w * 0.76, h * 0.66),
            Offset(w * 0.92, h * 0.22),
          ]
        : [
            Offset(w * 0.06, h * 0.52),
            Offset(w * 0.18, h * 0.30),
            Offset(w * 0.32, h * 0.50),
            Offset(w * 0.48, h * 0.12),
            Offset(w * 0.62, h * 0.52),
            Offset(w * 0.76, h * 0.32),
            Offset(w * 0.92, h * 0.72),
          ];
    _drawPolyline(canvas, pts, inverse ? _bull : _bear, width: 3);
    final neckY = inverse ? 0.39 : 0.51;
    _drawHLine(canvas, size, neckY, _gold, label: 'Линия шеи');
    if (progress > 0.85) {
      _label(
        canvas,
        size,
        inverse ? 'Перевёрнутая голова и плечи' : 'Голова и плечи',
        h * 0.08,
      );
    }
  }

  void _channel(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final price = [
      Offset(w * 0.08, h * 0.65),
      Offset(w * 0.25, h * 0.50),
      Offset(w * 0.42, h * 0.58),
      Offset(w * 0.58, h * 0.45),
      Offset(w * 0.75, h * 0.52),
      Offset(w * 0.92, h * 0.40),
    ];
    _drawPolyline(canvas, price, _bull, width: 3);
    _drawPolyline(canvas, [Offset(w * 0.08, h * 0.72), Offset(w * 0.92, h * 0.48)], _gold, width: 2, dashed: true);
    _drawPolyline(canvas, [Offset(w * 0.08, h * 0.55), Offset(w * 0.92, h * 0.32)], _gold, width: 2, dashed: true);
    if (progress > 0.85) _label(canvas, size, 'Ценовой канал', h * 0.12);
  }

  void _wedge(Canvas canvas, Size size, {required bool up}) {
    final w = size.width;
    final h = size.height;
    if (up) {
      final price = [
        Offset(w * 0.08, h * 0.78),
        Offset(w * 0.30, h * 0.62),
        Offset(w * 0.52, h * 0.68),
        Offset(w * 0.74, h * 0.55),
        Offset(w * 0.92, h * 0.48),
      ];
      _drawPolyline(canvas, price, _bull, width: 3);
      _drawPolyline(canvas, [Offset(w * 0.08, h * 0.78), Offset(w * 0.92, h * 0.35)], _bear, width: 2, dashed: true);
      _drawPolyline(canvas, [Offset(w * 0.08, h * 0.65), Offset(w * 0.92, h * 0.48)], _gold, width: 2, dashed: true);
      if (progress > 0.85) _label(canvas, size, 'Восходящий клин', h * 0.12);
    } else {
      final price = [
        Offset(w * 0.08, h * 0.22),
        Offset(w * 0.30, h * 0.38),
        Offset(w * 0.52, h * 0.30),
        Offset(w * 0.74, h * 0.45),
        Offset(w * 0.92, h * 0.52),
      ];
      _drawPolyline(canvas, price, _bear, width: 3);
      _drawPolyline(canvas, [Offset(w * 0.08, h * 0.22), Offset(w * 0.92, h * 0.65)], _bull, width: 2, dashed: true);
      _drawPolyline(canvas, [Offset(w * 0.08, h * 0.35), Offset(w * 0.92, h * 0.52)], _gold, width: 2, dashed: true);
      if (progress > 0.85) _label(canvas, size, 'Нисходящий клин', h * 0.12);
    }
  }

  void _fibonacci(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final price = [
      Offset(w * 0.08, h * 0.78),
      Offset(w * 0.35, h * 0.25),
      Offset(w * 0.55, h * 0.48),
      Offset(w * 0.75, h * 0.38),
      Offset(w * 0.92, h * 0.42),
    ];
    _drawPolyline(canvas, price, _bull, width: 3);
    final levels = [0.0, 0.236, 0.382, 0.5, 0.618, 1.0];
    for (var i = 0; i < levels.length; i++) {
      final y = h * (0.25 + levels[i] * 0.53);
      if (progress > 0.2 + i * 0.12) {
        _drawHLine(canvas, size, y / h, i.isEven ? _gold : _line);
      }
    }
    if (progress > 0.9) {
      _label(canvas, size, 'Коррекция по Фибоначчи', h * 0.10);
      final tp = TextPainter(
        text: const TextSpan(text: '61.8%', style: TextStyle(color: _gold, fontSize: 9)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(w * 0.02, h * 0.58));
    }
  }

  void _doubleTop(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final pts = [
      Offset(w * 0.08, h * 0.55),
      Offset(w * 0.25, h * 0.22),
      Offset(w * 0.42, h * 0.48),
      Offset(w * 0.58, h * 0.20),
      Offset(w * 0.75, h * 0.50),
      Offset(w * 0.92, h * 0.72),
    ];
    _drawPolyline(canvas, pts, _bear, width: 3);
    _drawHLine(canvas, size, 0.48, _gold, label: 'Шея');
    if (progress > 0.85) _label(canvas, size, 'Двойная вершина', h * 0.12);
  }

  void _doubleBottom(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final pts = [
      Offset(w * 0.08, h * 0.45),
      Offset(w * 0.25, h * 0.78),
      Offset(w * 0.42, h * 0.52),
      Offset(w * 0.58, h * 0.80),
      Offset(w * 0.75, h * 0.50),
      Offset(w * 0.92, h * 0.28),
    ];
    _drawPolyline(canvas, pts, _bull, width: 3);
    _drawHLine(canvas, size, 0.52, _gold, label: 'Шея');
    if (progress > 0.85) _label(canvas, size, 'Двойное дно', h * 0.12);
  }

  void _label(Canvas canvas, Size size, String text, double y) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: AppTheme.textSoft, fontSize: 11, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);
    tp.paint(canvas, Offset((size.width - tp.width) / 2, y));
  }

  @override
  bool shouldRepaint(covariant _PatternPainter old) =>
      old.progress != progress || old.patternType != patternType;
}
