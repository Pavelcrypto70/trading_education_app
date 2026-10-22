import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/demo_candle.dart';
import '../services/locale_service.dart';
import '../theme.dart';
import '../utils/num_format.dart';

/// Line colors on the simulator chart, same meaning as on lesson charts.
class SimChartColors {
  SimChartColors._();
  static const entry = AppTheme.bull;
  static const shortEntry = AppTheme.text;
  static const stop = AppTheme.bear;
  static const take = AppTheme.progress;
  static const liquidation = AppTheme.bear;
  /// Current price: dotted and muted, so it is never mistaken for a support level.
  static const current = AppTheme.muted;
}

/// Live candlestick chart for paper trading with pinch / button zoom and pan.
class DemoTradingChart extends StatefulWidget {
  final List<DemoCandle> candles;
  final double currentPrice;
  final double? entryPrice;
  final double? stopPrice;
  final double? targetPrice;
  final double? liquidationPrice;
  final double height;
  /// Short deal: entry is not drawn green, green means buying.
  final bool shortSide;

  const DemoTradingChart({
    super.key,
    required this.candles,
    required this.currentPrice,
    this.shortSide = false,
    this.entryPrice,
    this.stopPrice,
    this.targetPrice,
    this.liquidationPrice,
    this.height = 300,
  });

  @override
  State<DemoTradingChart> createState() => _DemoTradingChartState();
}

class _DemoTradingChartState extends State<DemoTradingChart> {
  /// How many candles are visible (smaller = more zoom).
  int _visible = 48;
  /// Offset from the right edge (0 = follow live price).
  int _panFromEnd = 0;
  double _scaleStartVisible = 48;

  static const _minVisible = 12;
  static const _maxVisible = 80;

  void _zoomIn() => setState(() {
        _visible = (_visible - 6).clamp(_minVisible, _maxVisible);
        _clampPan();
      });

  void _zoomOut() => setState(() {
        _visible = (_visible + 6).clamp(_minVisible, _maxVisible);
        _clampPan();
      });

  void _resetView() => setState(() {
        _visible = 48;
        _panFromEnd = 0;
      });

  void _clampPan() {
    final maxPan = math.max(0, widget.candles.length - _visible);
    _panFromEnd = _panFromEnd.clamp(0, maxPan);
  }

  List<DemoCandle> get _slice {
    if (widget.candles.isEmpty) return const [];
    _clampPan();
    final end = widget.candles.length - _panFromEnd;
    final start = math.max(0, end - _visible);
    return widget.candles.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.practiceZoomHint,
                style: const TextStyle(color: AppTheme.faint, fontSize: 11.5),
              ),
            ),
            const SizedBox(width: 8),
            _ZoomBtn(icon: Icons.remove, tooltip: l10n.chartZoomOut, onTap: _zoomOut),
            const SizedBox(width: 4),
            _ZoomBtn(icon: Icons.add, tooltip: l10n.chartZoomIn, onTap: _zoomIn),
            const SizedBox(width: 4),
            _ZoomBtn(icon: Icons.center_focus_strong, tooltip: l10n.chartResetView, onTap: _resetView),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: widget.height,
            width: double.infinity,
            child: GestureDetector(
              onScaleStart: (_) => _scaleStartVisible = _visible.toDouble(),
              onScaleUpdate: (d) {
                if (d.pointerCount >= 2) {
                  final next = (_scaleStartVisible / d.scale).round().clamp(_minVisible, _maxVisible);
                  if (next != _visible) {
                    setState(() {
                      _visible = next;
                      _clampPan();
                    });
                  }
                } else if (d.pointerCount == 1 && d.focalPointDelta.dx.abs() > 0.5) {
                  setState(() {
                    // Drag right → look at older candles.
                    _panFromEnd += (d.focalPointDelta.dx / 8).round();
                    _clampPan();
                  });
                }
              },
              onDoubleTap: _resetView,
              child: CustomPaint(
                painter: _DemoChartPainter(
                  candles: _slice,
                  currentPrice: widget.currentPrice,
                  entryPrice: widget.entryPrice,
                  stopPrice: widget.stopPrice,
                  targetPrice: widget.targetPrice,
                  liquidationPrice: widget.liquidationPrice,
                  shortSide: widget.shortSide,
                  followLive: _panFromEnd == 0,
                  labelTake: l10n.chartLabelTake,
                  labelEntry: l10n.chartLabelEntry,
                  labelStop: l10n.chartLabelStop,
                  labelLiq: l10n.chartLabelLiq,
                  labelLiqOff: (price, below) => l10n.chartLiqOff(
                    price,
                    below ? l10n.chartBelow : l10n.chartAbove,
                  ),
                  pastCandlesHint: l10n.chartPastCandlesHint,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ZoomBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ZoomBtn({required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 34,
            height: 30,
            child: Icon(icon, size: 17, color: AppTheme.textSoft),
          ),
        ),
      ),
    );
  }
}

class _Level {
  final double price;
  final Color color;
  final String label;
  final bool dashed;
  const _Level(this.price, this.color, this.label, {this.dashed = false});
}

class _DemoChartPainter extends CustomPainter {
  final List<DemoCandle> candles;
  final double currentPrice;
  final double? entryPrice;
  final double? stopPrice;
  final double? targetPrice;
  final double? liquidationPrice;
  final bool shortSide;
  final bool followLive;
  final String labelTake;
  final String labelEntry;
  final String labelStop;
  final String labelLiq;
  final String Function(String price, bool below) labelLiqOff;
  final String pastCandlesHint;

  _DemoChartPainter({
    required this.candles,
    required this.currentPrice,
    this.entryPrice,
    this.stopPrice,
    this.targetPrice,
    this.liquidationPrice,
    this.shortSide = false,
    this.followLive = true,
    required this.labelTake,
    required this.labelEntry,
    required this.labelStop,
    required this.labelLiq,
    required this.labelLiqOff,
    required this.pastCandlesHint,
  });

  static const _bullColor = AppTheme.bull;
  static const _bearColor = AppTheme.bear;
  static const _gridColor = AppTheme.grid;
  static const _padRight = 64.0;
  static const _pillH = 20.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chartW = size.width - _padRight;
    final chartSize = Size(chartW, size.height);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AppTheme.bg2,
    );

    if (candles.isEmpty) return;

    final bounds = _priceBounds(candles);
    var lo = bounds.$1;
    var hi = bounds.$2;

    for (final level in [currentPrice, entryPrice, stopPrice, targetPrice]) {
      if (level != null) {
        lo = math.min(lo, level);
        hi = math.max(hi, level);
      }
    }
    final pad = (hi - lo) * 0.1 + 0.02;
    lo -= pad;
    hi += pad;

    final last = candles.last;
    final y = _y(chartSize, last.close, lo, hi);

    _drawGrid(canvas, chartSize);
    _drawPriceScale(canvas, chartSize, lo, hi, y);
    _drawCandles(canvas, chartSize, candles, lo, hi);

    _drawLine(canvas, chartSize, _y(chartSize, currentPrice, lo, hi), SimChartColors.current,
        dashed: true, width: 1.4, dash: 1.5, space: 3.5);

    final levels = <_Level>[
      if (targetPrice != null) _Level(targetPrice!, SimChartColors.take, labelTake),
      if (entryPrice != null)
        _Level(entryPrice!, shortSide ? SimChartColors.shortEntry : SimChartColors.entry, labelEntry),
      if (stopPrice != null) _Level(stopPrice!, SimChartColors.stop, labelStop),
    ];
    final liq = liquidationPrice;
    String? liqOffChart;
    if (liq != null) {
      if (liq >= lo && liq <= hi) {
        levels.add(_Level(liq, SimChartColors.liquidation, labelLiq, dashed: true));
      } else {
        liqOffChart = labelLiqOff(fmtPrice(liq), liq < lo);
      }
    }

    for (final l in levels) {
      _drawLine(canvas, chartSize, _y(chartSize, l.price, lo, hi), l.color, dashed: l.dashed, width: 1.6);
    }
    _drawLevelPills(canvas, chartSize, levels, lo, hi);

    final gap = chartSize.width / candles.length;
    final x = gap * (candles.length - 1) + gap / 2;
    final liveColor = last.isBullish ? _bullColor : _bearColor;

    canvas.drawCircle(Offset(x, y), 4.5, Paint()..color = liveColor);
    canvas.drawCircle(
      Offset(x, y),
      8,
      Paint()
        ..color = liveColor.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    _pill(canvas, fmtPrice(currentPrice), Offset(chartW + 2, y - _pillH / 2), liveColor,
        filled: true, maxWidth: _padRight - 4);

    if (liqOffChart != null) {
      _pill(canvas, liqOffChart, Offset(6, liq! < lo ? size.height - _pillH - 6 : 6), SimChartColors.liquidation,
          maxWidth: chartW - 12);
    }
    if (!followLive) {
      _pill(canvas, pastCandlesHint,
          Offset(6, liqOffChart != null && liq! >= lo ? 6 + _pillH + 4 : 6), AppTheme.textSoft,
          maxWidth: chartW - 12);
    }
  }

  /// Level names sit on solid pills on top of the candles; close levels are pushed apart.
  void _drawLevelPills(Canvas canvas, Size size, List<_Level> levels, double lo, double hi) {
    if (levels.isEmpty) return;
    final items = [
      for (final l in levels) (l, _y(size, l.price, lo, hi) - _pillH / 2),
    ]..sort((a, b) => a.$2.compareTo(b.$2));
    final ys = items.map((e) => e.$2).toList();
    for (var i = 1; i < ys.length; i++) {
      ys[i] = math.max(ys[i], ys[i - 1] + _pillH + 2);
    }
    final overflow = ys.last + _pillH - size.height;
    if (overflow > 0) {
      for (var i = 0; i < ys.length; i++) {
        ys[i] -= overflow;
      }
      for (var i = ys.length - 2; i >= 0; i--) {
        ys[i] = math.min(ys[i], ys[i + 1] - _pillH - 2);
      }
    }
    for (var i = 0; i < items.length; i++) {
      final l = items[i].$1;
      _pill(canvas, '${l.label} ${fmtPrice(l.price)}', Offset(6, ys[i].clamp(0, size.height - _pillH)), l.color,
          maxWidth: size.width - 12);
    }
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

  /// Scale numbers; the one under the current-price pill at [liveY] is skipped, not half-covered.
  void _drawPriceScale(Canvas canvas, Size size, double lo, double hi, double liveY) {
    for (var i = 1; i < 5; i++) {
      final t = i / 5;
      final yy = size.height * t;
      if ((yy - liveY).abs() < _pillH) continue;
      final price = lo + (hi - lo) * (1 - t);
      _text(canvas, fmtPrice(price), Offset(size.width + 6, yy - 7), AppTheme.muted);
    }
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

  void _drawLine(Canvas canvas, Size size, double y, Color color,
      {required bool dashed, required double width, double dash = 6, double space = 4}) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    if (!dashed) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      return;
    }
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(math.min(x + dash, size.width), y), paint);
      x += dash + space;
    }
  }

  void _text(Canvas canvas, String text, Offset pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: _padRight - 6);
    tp.paint(canvas, pos);
  }

  void _pill(Canvas canvas, String text, Offset pos, Color color, {bool filled = false, required double maxWidth}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: filled ? AppTheme.onPastel : color,
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: math.max(20, maxWidth - 12));
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(pos.dx, pos.dy, tp.width + 12, _pillH),
      const Radius.circular(6),
    );
    canvas.drawRRect(r, Paint()..color = filled ? color : AppTheme.bg.withValues(alpha: 0.92));
    if (!filled) {
      canvas.drawRRect(
        r,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    }
    tp.paint(canvas, Offset(pos.dx + 6, pos.dy + (_pillH - tp.height) / 2));
  }

  @override
  bool shouldRepaint(covariant _DemoChartPainter old) =>
      old.candles != candles ||
      old.currentPrice != currentPrice ||
      old.entryPrice != entryPrice ||
      old.stopPrice != stopPrice ||
      old.targetPrice != targetPrice ||
      old.liquidationPrice != liquidationPrice ||
      old.shortSide != shortSide ||
      old.followLive != followLive ||
      old.labelTake != labelTake ||
      old.labelEntry != labelEntry ||
      old.labelStop != labelStop ||
      old.labelLiq != labelLiq ||
      old.pastCandlesHint != pastCandlesHint;
}
