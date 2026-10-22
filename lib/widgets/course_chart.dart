import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/course_chart_spec.dart';
import '../services/locale_service.dart';
import '../theme.dart';

Color courseColor(String name) => switch (name) {
      'bull' => AppTheme.bull,
      'bear' => AppTheme.bear,
      'gold' => AppTheme.progress,
      'lavender' => AppTheme.lavender,
      'info' => AppTheme.info,
      'accent' => AppTheme.accent,
      'muted' => AppTheme.muted,
      'warn' => AppTheme.warn,
      _ => AppTheme.text,
    };

Color _kindColor(String kind) => switch (kind) {
      'buy' || 'entry' => AppTheme.bull,
      'sell' || 'stop' => AppTheme.bear,
      'target' => AppTheme.progress,
      'exit' => AppTheme.info,
      'short' => AppTheme.text,
      'muted' => AppTheme.muted,
      _ => AppTheme.lavender,
    };

/// Size of the «Увеличить» badge in the top-right corner of the card; the painter keeps it free.
const _badgeSize = Size(96, 22);

/// Lesson chart card: the chart, then «Смотри: …» — what exactly to look at.
/// Tap opens a large version.
class CourseChartCard extends StatelessWidget {
  final CourseChartSpec spec;
  final double height;

  const CourseChartCard({super.key, required this.spec, this.height = 290});

  void _openLarge(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        final size = MediaQuery.of(ctx).size;
        return Dialog(
          backgroundColor: AppTheme.bg,
          insetPadding: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: math.min(size.height * 0.62, 520),
                  child: InteractiveViewer(
                    maxScale: 4,
                    child: CourseChart(spec: spec, full: true),
                  ),
                ),
                const SizedBox(height: 8),
                if (spec.look.isNotEmpty) _LookRow(text: spec.look),
                TextButton(onPressed: () => Navigator.pop(ctx), child: Text(ctx.l10n.closeBtn)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.bg2,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: AppTheme.lineSoft),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: context.l10n.chartZoomHint,
            button: true,
            child: GestureDetector(
              onTap: () => _openLarge(context),
              child: SizedBox(
                height: spec.height ?? height,
                child: Stack(
                  children: [
                    Positioned.fill(child: CourseChart(spec: spec, badge: true)),
                    Positioned(
                      top: 3,
                      right: 6,
                      child: Container(
                        height: _badgeSize.height,
                        constraints: BoxConstraints(maxWidth: _badgeSize.width),
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: AppTheme.bg.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.lineSoft),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.zoom_out_map_rounded, size: 13, color: AppTheme.muted),
                            const SizedBox(width: 4),
                            Text(context.l10n.zoomIn, style: const TextStyle(color: AppTheme.muted, fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (spec.look.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: _LookRow(text: spec.look),
            ),
        ],
      ),
    );
  }
}

class _LookRow extends StatelessWidget {
  final String text;
  const _LookRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(Icons.visibility_rounded, size: 18, color: AppTheme.progress),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppTheme.text, height: 1.45, fontSize: 14.5, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class CourseChart extends StatelessWidget {
  final CourseChartSpec spec;
  /// Large view: every candle. The card shows only the last candles of long charts.
  final bool full;
  /// Keep the top-right corner free for the «Увеличить» badge.
  final bool badge;
  const CourseChart({super.key, required this.spec, this.full = false, this.badge = false});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CoursePainter(spec, full: full, badge: badge), size: Size.infinite);
  }
}

class _CoursePainter extends CustomPainter {
  final CourseChartSpec s;
  final bool full;
  final bool badge;
  _CoursePainter(this.s, {this.full = false, this.badge = false});

  static const _scaleW = 54.0;
  static const _headerH = 28.0;
  static const _dotR = 6.5;
  /// Longer charts are unreadable on a phone: the card shows the last [_window] candles
  /// (never cutting off a marker, frame or plan line), the large view shows all.
  static const _maxCandles = 34;
  static const _window = 32;
  /// Level label ↔ its line.
  static const _levelGap = 6.0;
  /// How much worse it is to cover a candle: the one a marker points at, its neighbours / framed candles.
  static const _keyOwn = 6.0, _keyNear = 3.0;

  late Rect plot;
  late double lo;
  late double hi;
  late double gap;
  /// First visible candle; every spec index is shifted by it.
  late int _off;
  late List<List<double>> _cs;
  final List<Rect> _placed = [];
  /// Placed label pills only: a leader line must not cross them.
  final List<Rect> _labels = [];
  /// Candles and the header: labels may cover them only when nothing else fits.
  final List<Rect> _soft = [];
  /// Per [_soft] rect: cost weight, [_keyOwn]/[_keyNear] for candles the lesson points at.
  final List<double> _key = [];
  final List<Offset> _dots = [];
  /// Price tags of levels on the scale, top to bottom.
  List<(CourseLevel, Rect, TextPainter)> _tags = const [];

  double y(double p) => plot.bottom - (p - lo) / (hi - lo) * plot.height;
  double x(num i) => plot.left + (i + 0.5) * gap;
  double xi(int i) => x(i - _off);

  bool _shown(CourseMarker m) => m.i >= _off && m.i < s.candles.length;

  /// Visible candle [i]: the candle a marker points at, its neighbours and framed candles are key.
  double _keyWeight(int i) {
    final g = i + _off;
    final shown = s.markers.where(_shown);
    if (shown.any((m) => m.i == g)) return _keyOwn;
    if (shown.any((m) => (m.i - g).abs() <= 2) || s.boxes.any((b) => b.i1 <= g && g <= b.i2)) return _keyNear;
    return 1;
  }

  /// Current layout: marker labels first or last, price padding above and below.
  late bool _markersFirst;
  late double _padTop;
  late double _padBottom;
  /// Area where a label had to overlap another label or a dot.
  double _clash = 0;
  /// Sum of the chosen label scores.
  double _cost = 0;

  /// Label layouts tried for every chart, the cheapest wins (same list as tools/course/preview.py).
  /// The roomy padding shrinks candles, so it costs extra.
  static const _layouts = [
    (true, 0.16, 0.10, 0.0),
    (false, 0.16, 0.10, 0.0),
    (true, 0.34, 0.22, 400.0),
    (false, 0.34, 0.22, 400.0),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    ui.Picture? best;
    var bestCost = double.infinity;
    for (final (first, top, bottom, penalty) in _layouts) {
      _markersFirst = first;
      _padTop = top;
      _padBottom = bottom;
      final rec = ui.PictureRecorder();
      _paintOnce(Canvas(rec), size);
      final pic = rec.endRecording();
      final cost = _cost + _clash * 20 + penalty;
      if (cost < bestCost) {
        best?.dispose();
        best = pic;
        bestCost = cost;
      } else {
        pic.dispose();
      }
    }
    if (best == null) return;
    canvas.drawPicture(best);
    best.dispose();
  }

  void _paintOnce(Canvas canvas, Size size) {
    _clash = 0;
    _cost = 0;
    _placed.clear();
    _labels.clear();
    _soft.clear();
    _key.clear();
    _dots.clear();
    if (s.candles.isEmpty) return;
    _off = _windowStart();
    _cs = s.candles.sublist(_off);
    final n = _cs.length;
    final hasVol = s.volume != null && s.volume!.length > _off;
    final volH = hasVol ? size.height * 0.17 : 0.0;
    plot = Rect.fromLTRB(6, _headerH, size.width - _scaleW, size.height - volH - 8);
    gap = plot.width / (n + 1.0);
    if (badge) {
      _placed.add(Rect.fromLTWH(size.width - 6 - _badgeSize.width, 1, _badgeSize.width, _badgeSize.height + 4));
    }

    _bounds();
    _tags = _tagLayout(size);
    _background(canvas, size);
    _header(canvas);

    for (final z in s.zones) {
      _zone(canvas, z);
    }
    for (final b in s.boxes) {
      _box(canvas, b);
    }
    if (s.style == 'line') {
      _closeLine(canvas);
    } else {
      _candles(canvas);
    }
    for (final l in s.lines) {
      _line(canvas, l);
    }
    for (final l in s.levels) {
      _level(canvas, l);
    }
    if (hasVol) _volume(canvas, size, volH);
    _priceTags(canvas, size);

    // Labels last, with collision avoidance, so nothing hides behind candles.
    for (final m in s.markers) {
      _markerDot(canvas, m);
    }
    if (_markersFirst) {
      for (final m in s.markers) {
        _markerLabel(canvas, m);
      }
    }
    for (final b in s.boxes) {
      _boxLabel(canvas, b);
    }
    for (final z in s.zones) {
      _zoneLabel(canvas, z);
    }
    for (final l in s.levels) {
      _levelLabel(canvas, l);
    }
    for (final l in s.lines) {
      _lineLabel(canvas, l);
    }
    if (!_markersFirst) {
      for (final m in s.markers) {
        _markerLabel(canvas, m);
      }
    }
  }

  int _windowStart() {
    final n = s.candles.length;
    if (full || n <= _maxCandles) return 0;
    var start = n - _window;
    void keep(int? i) {
      if (i != null && i >= 0 && i < n) start = math.min(start, i - 2);
    }

    for (final m in s.markers) {
      keep(m.i);
    }
    for (final b in s.boxes) {
      keep(b.i1);
    }
    for (final l in s.levels) {
      keep(l.from);
    }
    for (final z in s.zones) {
      keep(z.from);
    }
    return math.max(0, start);
  }

  /// Line end points in visible coordinates; the part left of the window is cut off.
  (double, double, double, double)? _clip(CourseLine l) {
    if (l.i1 < _off && l.i2 < _off) return null;
    double cut(int i, double p, int j, double q) => i == j ? p : p + (q - p) * (_off - i) / (j - i);
    final p1 = l.i1 < _off ? cut(l.i1, l.p1, l.i2, l.p2) : l.p1;
    final p2 = l.i2 < _off ? cut(l.i2, l.p2, l.i1, l.p1) : l.p2;
    return ((math.max(l.i1, _off) - _off).toDouble(), p1, (math.max(l.i2, _off) - _off).toDouble(), p2);
  }

  void _bounds() {
    var mn = double.infinity, mx = -double.infinity;
    void take(double v) {
      mn = math.min(mn, v);
      mx = math.max(mx, v);
    }

    for (final c in _cs) {
      take(c[1]);
      take(c[2]);
    }
    for (final l in s.levels) {
      take(l.price);
    }
    for (final z in s.zones) {
      take(z.top);
      take(z.bottom);
    }
    for (final m in s.markers) {
      if (_shown(m)) take(m.price);
    }
    for (final l in s.lines) {
      final c = _clip(l);
      if (c == null) continue;
      take(c.$2);
      take(c.$4);
    }
    final span = math.max(mx - mn, 0.5);
    lo = mn - span * _padBottom;
    hi = mx + span * _padTop;
  }

  void _background(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF241C3D), AppTheme.bg2],
        ).createShader(rect),
    );
    final grid = Paint()
      ..color = AppTheme.grid
      ..strokeWidth = 1;
    final tags = [for (final l in s.levels) y(l.price)];
    // Price tags (pushed apart, so not always at their level) and the badge cover the scale.
    final busy = [
      for (final t in _tags) t.$2.inflate(3),
      if (badge) Rect.fromLTWH(size.width - 6 - _badgeSize.width, 1, _badgeSize.width, _badgeSize.height + 4),
    ];
    final step = _niceStep(hi - lo);
    final start = (lo / step).ceil() * step;
    for (var p = start; p <= hi; p += step) {
      final yy = y(p);
      canvas.drawLine(Offset(plot.left, yy), Offset(plot.right, yy), grid);
      // Price tags of levels cover the scale; a half-hidden number under them only confuses.
      final tick = Rect.fromLTRB(plot.right + 6, yy - 7, size.width, yy + 7);
      if (yy < plot.top + 5 || tags.any((t) => (t - yy).abs() < 12) || busy.any(tick.overlaps)) continue;
      _text(canvas, _fmt(p, step), Offset(plot.right + 6, yy - 7),
          const TextStyle(color: AppTheme.muted, fontSize: 10.5, fontWeight: FontWeight.w600));
    }
  }

  double _niceStep(double span) {
    final raw = span / 5;
    final mag = math.pow(10, (math.log(raw) / math.ln10).floor()).toDouble();
    for (final m in [1.0, 2.0, 2.5, 5.0, 10.0]) {
      if (raw <= m * mag) return m * mag;
    }
    return 10 * mag;
  }

  /// Course text writes prices with a decimal comma (145,8), the chart does the same.
  String _fmt(double p, [double step = 1]) {
    final tenths = step * 10;
    final digits = step >= 1
        ? (p == p.roundToDouble() ? 0 : 1)
        : ((tenths - tenths.round()).abs() < 1e-9 ? 1 : 2);
    var t = p.toStringAsFixed(digits);
    if (digits > 0) t = t.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
    return t.replaceAll('.', ',');
  }

  void _header(Canvas canvas) {
    final t = [s.pair, s.tf].where((e) => e.isNotEmpty).join(' · ');
    if (t.isEmpty) return;
    final tp = _layout(
        t, const TextStyle(color: AppTheme.textSoft, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.3));
    final o = Offset(plot.left + 4, 7);
    tp.paint(canvas, o);
    _soft.add((o & tp.size).inflate(3));
    _key.add(1);
  }

  void _zone(Canvas canvas, CourseZone z) {
    final c = courseColor(z.color);
    final plan = z.color == 'bear' || z.color == 'gold' || z.color == 'bull';
    final r = Rect.fromLTRB(_startX(z.from), y(z.top), plot.right, y(z.bottom));
    canvas.drawRect(r, Paint()..color = c.withValues(alpha: plan ? 0.32 : 0.17));
    final edge = Paint()
      ..color = c
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    if (plan) {
      canvas.drawRect(r, edge);
    } else {
      canvas.drawLine(r.topLeft, r.topRight, edge);
      canvas.drawLine(r.bottomLeft, r.bottomRight, edge);
    }
  }

  Rect _boxRect(CourseBox b) {
    final pad = gap * 0.45;
    return Rect.fromLTRB(xi(math.max(b.i1, _off)) - pad, y(b.top) - 6, xi(b.i2) + pad, y(b.bottom) + 6);
  }

  void _box(Canvas canvas, CourseBox b) {
    if (b.i2 < _off) return;
    final c = courseColor(b.color);
    final r = RRect.fromRectAndRadius(_boxRect(b), const Radius.circular(8));
    canvas.drawRRect(r, Paint()..color = c.withValues(alpha: 0.08));
    _dashedRRect(canvas, r, Paint()
      ..color = c
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke);
  }

  void _line(Canvas canvas, CourseLine l) {
    final cl = _clip(l);
    if (cl == null) return;
    final p = Paint()
      ..color = courseColor(l.color)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final a = Offset(x(cl.$1), y(cl.$2));
    final b = Offset(x(cl.$3), y(cl.$4));
    if (l.dashed) {
      _dashed(canvas, a, b, p);
    } else {
      canvas.drawLine(a, b, p);
    }
    // Labels must not hide the line itself.
    final len = (b - a).distance;
    for (var t = 0.0; t <= len; t += 6) {
      _placed.add(Rect.fromCenter(center: Offset.lerp(a, b, len == 0 ? 0 : t / len)!, width: 6, height: 6));
    }
  }

  void _candles(Canvas canvas) {
    final n = _cs.length;
    final w = (gap * 0.66).clamp(3.0, 22.0);
    for (var i = 0; i < n; i++) {
      final c = _cs[i];
      final o = c[0], h = c[1], l = c[2], cl = c[3];
      final col = cl >= o ? AppTheme.bull : AppTheme.bear;
      final xx = x(i);
      canvas.drawLine(Offset(xx, y(h)), Offset(xx, y(l)), Paint()
        ..color = col
        ..strokeWidth = n > 20 ? 1.2 : 1.8);
      final top = y(math.max(o, cl)), bot = y(math.min(o, cl));
      _soft.add(Rect.fromLTRB(xx - w / 2 - 1, y(h) - 1, xx + w / 2 + 1, y(l) + 1));
      _key.add(_keyWeight(i));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(xx - w / 2, top, xx + w / 2, math.max(bot, top + 1.6)),
          const Radius.circular(1.5),
        ),
        Paint()..color = col,
      );
    }
  }

  void _closeLine(Canvas canvas) {
    final n = _cs.length;
    final path = Path();
    for (var i = 0; i < n; i++) {
      final pt = Offset(x(i), y(_cs[i][3]));
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
      _soft.add(Rect.fromCenter(center: pt, width: gap + 2, height: 8));
      _key.add(1);
    }
    final fill = Path.from(path)
      ..lineTo(x(n - 1), plot.bottom)
      ..lineTo(x(0), plot.bottom)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.lavender.withValues(alpha: 0.28), AppTheme.lavender.withValues(alpha: 0.0)],
        ).createShader(plot),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppTheme.lavender
        ..strokeWidth = 2.6
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  double _startX(int? f) {
    if (f == null || f - _off <= 0) return plot.left;
    return x(math.min(f - _off, _cs.length - 1)) - gap * 0.5;
  }

  void _level(Canvas canvas, CourseLevel l) {
    final c = courseColor(l.color);
    final yy = y(l.price);
    final x0 = _startX(l.from);
    final p = Paint()
      ..color = c
      ..strokeWidth = 1.8;
    l.dashed
        ? _dashed(canvas, Offset(x0, yy), Offset(plot.right, yy), p)
        : canvas.drawLine(Offset(x0, yy), Offset(plot.right, yy), p);
    // Labels must not lie on a level line (an entry label hiding the stop line).
    _placed.add(Rect.fromLTRB(x0, yy - 2.5, plot.right, yy + 2.5));
  }

  /// Exact level prices on the scale, in the level colour; close tags are pushed apart.
  List<(CourseLevel, Rect, TextPainter)> _tagLayout(Size size) {
    final items = [for (final l in s.levels) (l, y(l.price))]..sort((a, b) => a.$2.compareTo(b.$2));
    final out = <(CourseLevel, Rect, TextPainter)>[];
    var prevBottom = -double.infinity;
    for (final (l, yy) in items) {
      final tp = _layout(_fmt(l.price, 0.01),
          const TextStyle(color: AppTheme.onPastel, fontSize: 9.5, fontWeight: FontWeight.w900));
      final w = tp.width + 8, h = tp.height + 5;
      final top = math.max(yy - h / 2, prevBottom + 1);
      final left = math.min(plot.right + 3, size.width - 1 - w);
      out.add((l, Rect.fromLTWH(left, top, w, h), tp));
      prevBottom = top + h;
    }
    return out;
  }

  void _priceTags(Canvas canvas, Size size) {
    for (final (l, r, tp) in _tags) {
      canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(4)), Paint()..color = courseColor(l.color));
      tp.paint(canvas, Offset(r.left + 4, r.top + 2.5));
    }
  }

  void _volume(Canvas canvas, Size size, double volH) {
    final v = s.volume!.sublist(_off);
    final mx = v.reduce(math.max);
    final base = size.height - 4;
    final w = (gap * 0.55).clamp(2.0, 16.0);
    for (var i = 0; i < math.min(v.length, _cs.length); i++) {
      final c = _cs[i];
      final h = v[i] / mx * (volH - 16);
      final col = (c[3] >= c[0] ? AppTheme.bull : AppTheme.bear).withValues(alpha: 0.55);
      canvas.drawRect(Rect.fromLTRB(x(i) - w / 2, base - h, x(i) + w / 2, base), Paint()..color = col);
    }
    _text(canvas, LocaleService.instance.strings.volumeLabel, Offset(plot.left + 4, size.height - volH),
        const TextStyle(color: AppTheme.muted, fontSize: 10.5, fontWeight: FontWeight.w700));
  }

  void _markerDot(Canvas canvas, CourseMarker m) {
    if (!_shown(m)) return;
    final c = _kindColor(m.kind);
    final o = Offset(xi(m.i), y(m.price));
    final candle = s.candles[m.i];
    final bodyTop = y(math.max(candle[0], candle[3])), bodyBot = y(math.min(candle[0], candle[3]));
    final onBody = o.dy + _dotR >= bodyTop && o.dy - _dotR <= bodyBot;
    if (m.kind == 'muted') {
      // Current price, not an action: a quiet dashed ring.
      canvas.drawCircle(o, _dotR + 1, Paint()
        ..color = AppTheme.bg
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4);
      final ring = Path()..addOval(Rect.fromCircle(center: o, radius: _dotR + 1));
      final p = Paint()
        ..color = c
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8;
      for (final metric in ring.computeMetrics()) {
        for (var t = 0.0; t < metric.length; t += 6) {
          canvas.drawPath(metric.extractPath(t, math.min(t + 3.5, metric.length)), p);
        }
      }
    } else if (onBody || y(candle[2]) - y(candle[1]) < _dotR * 2 + 3) {
      // A filled dot would hide the body (or a tiny candle): a ring keeps it visible.
      canvas.drawCircle(o, _dotR + 1, Paint()
        ..color = AppTheme.bg
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4);
      canvas.drawCircle(o, _dotR + 1, Paint()
        ..color = c
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2);
    } else {
      canvas.drawCircle(o, _dotR + 2, Paint()..color = AppTheme.bg);
      canvas.drawCircle(o, _dotR, Paint()..color = c);
      canvas.drawCircle(o, _dotR, Paint()
        ..color = Colors.white.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6);
    }
    _dots.add(o);
    _placed.add(Rect.fromCircle(center: o, radius: _dotR + 2.5));
  }

  // ── labels ──

  void _zoneLabel(Canvas canvas, CourseZone z) {
    if (z.label.isEmpty) return;
    final top = y(z.top), bot = y(z.bottom);
    final tp = _pillText(z.label);
    final w = tp.width + 18, h = tp.height + 10;
    final mid = (top + bot) / 2 - h / 2;
    final x0 = _startX(z.from) + 6;
    final right = plot.right - w - 4;
    final r = _place(tp, [
      (Offset(x0, mid), 0),
      (Offset(x0, top - h - 3), 6),
      (Offset(x0, bot + 3), 8),
      for (final (k, f) in const [(0, 0.25), (1, 0.5), (2, 0.75), (3, 1.0)]) ...[
        (Offset(x0 + (right - x0) * f, mid), 10.0 + k * 2),
        (Offset(x0 + (right - x0) * f, top - h - 3), 11.0 + k * 2),
        (Offset(x0 + (right - x0) * f, bot + 3), 12.0 + k * 2),
      ],
    ]);
    _pill(canvas, tp, r, courseColor(z.color));
  }

  void _levelLabel(Canvas canvas, CourseLevel l) {
    if (l.label.isEmpty) return;
    final yy = y(l.price);
    final tp = _pillText(l.label);
    final w = tp.width + 18, h = tp.height + 10;
    final x0 = _startX(l.from);
    final right = plot.right - w - 4;
    final up = yy - h - _levelGap, down = yy + _levelGap;
    final r = _place(tp, [
      (Offset(right, up), 0),
      (Offset(right, down), 4),
      (Offset(x0 + 6, up), 6),
      (Offset(x0 + 6, down), 8),
      for (final (k, f) in const [(0, 0.25), (1, 0.5), (2, 0.75)]) ...[
        (Offset(x0 + 6 + (right - x0 - 6) * f, up), 10.0 + k * 2),
        (Offset(x0 + 6 + (right - x0 - 6) * f, down), 11.0 + k * 2),
      ],
      // Between close levels: better on its own line than next to a neighbour's line.
      (Offset(right, yy - h / 2), 2),
      if (x0 - w - 4 >= plot.left) (Offset(x0 - w - 4, yy - h / 2), 6),
    ]);
    _pill(canvas, tp, r, courseColor(l.color));
  }

  void _boxLabel(Canvas canvas, CourseBox b) {
    if (b.label.isEmpty || b.i2 < _off) return;
    final tp = _pillText(b.label);
    final w = tp.width + 18, h = tp.height + 10;
    final box = _boxRect(b);
    final r = _place(tp, [
      (Offset(box.left, box.top - h - 3), 0),
      (Offset(box.right - w, box.top - h - 3), 4),
      (Offset(box.center.dx - w / 2, box.top - h - 3), 6),
      (Offset(box.left, box.bottom + 3), 12),
      (Offset(box.right + 4, box.top), 16),
      (Offset(box.left - w - 4, box.top), 18),
      (Offset(box.left + 4, box.top + 4), 22),
      (Offset(box.left + 4, box.bottom - h - 4), 24),
    ]);
    _pill(canvas, tp, r, courseColor(b.color));
  }

  void _lineLabel(Canvas canvas, CourseLine l) {
    final cl = _clip(l);
    if (l.label.isEmpty || cl == null) return;
    final tp = _pillText(l.label);
    final w = tp.width + 18, h = tp.height + 10;
    final sx = x(cl.$1), sy = y(cl.$2);
    final ex = x(cl.$3), ey = y(cl.$4);
    final mx = (sx + ex) / 2, my = (sy + ey) / 2;
    // A steep line (the gap between stop and liquidation) is labelled beside its middle.
    final steep = (ex - sx).abs() < (ey - sy).abs();
    final e = steep ? 10.0 : 0.0;
    final r = _place(tp, [
      (Offset(ex - w, ey - h - 6), e),
      (Offset(ex - w, ey + 6), e + 4),
      (Offset(mx - w / 2, my - h - 8), 8),
      (Offset(mx - w / 2, my + 8), 10),
      (Offset(mx + 8, my - h / 2), steep ? 0 : 6),
      (Offset(mx - w - 8, my - h / 2), steep ? 1 : 7),
    ]);
    _pill(canvas, tp, r, courseColor(l.color));
  }

  void _markerLabel(Canvas canvas, CourseMarker m) {
    if (m.label.isEmpty || !_shown(m)) return;
    final c = _kindColor(m.kind);
    final o = Offset(xi(m.i), y(m.price));
    final tp = _pillText(m.label);
    final w = tp.width + 18, h = tp.height + 10;
    // An entry reads best right above its dot; other marks start up-right.
    final up = m.kind == 'entry' || m.kind == 'buy' || m.kind == 'sell' || m.kind == 'short';
    final cands = <(Offset, double)>[];
    for (final d in const [6.0, 16.0, 30.0, 50.0, 78.0]) {
      final dd = (_dotR + d) * 0.72;
      cands.addAll([
        (Offset(o.dx - w / 2, o.dy - _dotR - d - h), up ? 0 : 3),
        (Offset(o.dx + dd, o.dy - dd - h), up ? 4 : 0),
        (Offset(o.dx - dd - w, o.dy - dd - h), up ? 5 : 2),
        (Offset(o.dx + dd, o.dy + dd), up ? 14 : 6),
        (Offset(o.dx - dd - w, o.dy + dd), up ? 15 : 8),
        (Offset(o.dx - w / 2, o.dy + _dotR + d), up ? 18 : 10),
        (Offset(o.dx + _dotR + d, o.dy - h / 2), up ? 10 : 9),
        (Offset(o.dx - _dotR - d - w, o.dy - h / 2), 11),
      ]);
    }
    final r = _place(tp, cands, anchor: o, softWeight: 1);
    // Leader line from the dot to its label; the pill covers the inner end.
    final target = _leaderEnd(r, o);
    final v = target - o;
    if (_rectDist(r, o) > _dotR + 4) {
      final leader = Paint()
        ..color = c.withValues(alpha: 0.9)
        ..strokeWidth = 1.5;
      final a = o + v / v.distance * (_dotR + 1.5);
      m.kind == 'muted' ? _dashed(canvas, a, target, leader, dash: 4, space: 3) : canvas.drawLine(a, target, leader);
    }
    _pill(canvas, tp, r, c);
  }

  TextPainter _pillText(String t) => _layout(
        t,
        const TextStyle(color: AppTheme.text, fontSize: 11.5, fontWeight: FontWeight.w800, height: 1.15),
        maxWidth: math.min(170.0, plot.width * 0.62),
      );

  static double _rectDist(Rect r, Offset p) {
    final dx = math.max(math.max(r.left - p.dx, 0.0), p.dx - r.right);
    final dy = math.max(math.max(r.top - p.dy, 0.0), p.dy - r.bottom);
    return math.sqrt(dx * dx + dy * dy);
  }

  static Offset _leaderEnd(Rect r, Offset o) =>
      Offset(o.dx.clamp(r.left + 6, r.right - 6), o.dy.clamp(r.top + 4, r.bottom - 4));

  /// Does segment a→b pass through [r] (Liang–Barsky)?
  static bool _segHits(Offset a, Offset b, Rect r) {
    var t0 = 0.0, t1 = 1.0;
    final dx = b.dx - a.dx, dy = b.dy - a.dy;
    for (final (p, q) in [(-dx, a.dx - r.left), (dx, r.right - a.dx), (-dy, a.dy - r.top), (dy, r.bottom - a.dy)]) {
      if (p == 0) {
        if (q < 0) return false;
      } else {
        final t = q / p;
        p < 0 ? t0 = math.max(t0, t) : t1 = math.min(t1, t);
        if (t0 > t1) return false;
      }
    }
    return true;
  }

  /// Scores every candidate: overlap with placed labels, dots and lines is 10× worse than covering
  /// candles. With an [anchor] (marker dot) a far label costs more the farther it is, a label that
  /// sits closer to someone else's dot than to its own is almost never chosen, and its leader line
  /// must not cross other labels.
  Rect _place(TextPainter tp, List<(Offset, double)> candidates, {Offset? anchor, double softWeight = 2}) {
    final w = tp.width + 18, h = tp.height + 10;
    final area = Rect.fromLTRB(plot.left, 2, plot.right, plot.bottom + 4);
    Rect clampR(Offset o) {
      final l = o.dx.clamp(area.left + 2, math.max(area.left + 2, area.right - w - 2)).toDouble();
      final t = o.dy.clamp(area.top + 2, math.max(area.top + 2, area.bottom - h - 2)).toDouble();
      return Rect.fromLTWH(l, t, w, h);
    }

    Rect? best;
    var bestScore = double.infinity;
    for (final (o, pref) in candidates) {
      final r = clampR(o);
      var overlap = 0.0;
      for (final p in _placed) {
        final i = r.intersect(p);
        if (i.width > 0 && i.height > 0) overlap += i.width * i.height;
      }
      var covered = 0.0;
      for (var k = 0; k < _soft.length; k++) {
        final i = r.intersect(_soft[k]);
        // No label may hide the candles the lesson points at.
        if (i.width > 0 && i.height > 0) covered += i.width * i.height * _key[k];
      }
      var score = overlap * 10 + covered * softWeight + (r.topLeft - o).distance + pref;
      if (anchor != null) {
        final d = math.max(0.0, _rectDist(r, anchor) - _dotR - 3);
        score += d * 10 + d * d * 0.3;
        final own = _rectDist(r, anchor);
        if (_dots.any((p) => p != anchor && _rectDist(r, p) + 4 < own)) score += 2500;
        final end = _leaderEnd(r, anchor);
        score += 3000 * _labels.where((p) => _segHits(anchor, end, p.deflate(2))).length;
      }
      if (score < bestScore) {
        bestScore = score;
        best = r;
      }
    }
    final r = best!;
    for (final p in [..._labels, for (final d in _dots) Rect.fromCircle(center: d, radius: _dotR)]) {
      final i = r.intersect(p);
      if (i.width > 0 && i.height > 0) _clash += i.width * i.height;
    }
    _cost += bestScore;
    _placed.add(r.inflate(2));
    _labels.add(r.inflate(2));
    return r;
  }

  void _pill(Canvas canvas, TextPainter tp, Rect r, Color c) {
    final rr = RRect.fromRectAndRadius(r, const Radius.circular(8));
    canvas.drawRRect(rr.shift(const Offset(0, 1.5)), Paint()..color = const Color(0x55000000));
    canvas.drawRRect(rr, Paint()..color = const Color(0xF2191329));
    canvas.drawRRect(rr, Paint()
      ..color = c.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3);
    canvas.drawRRect(
      RRect.fromRectAndCorners(Rect.fromLTWH(r.left, r.top, 4, r.height),
          topLeft: const Radius.circular(8), bottomLeft: const Radius.circular(8)),
      Paint()..color = c,
    );
    tp.paint(canvas, Offset(r.left + 11, r.top + 5));
  }

  TextPainter _layout(String t, TextStyle st, {double maxWidth = 400}) =>
      TextPainter(text: TextSpan(text: t, style: st), textDirection: TextDirection.ltr, maxLines: 2, ellipsis: '…')
        ..layout(maxWidth: maxWidth);

  void _text(Canvas canvas, String t, Offset o, TextStyle st) => _layout(t, st).paint(canvas, o);

  void _dashed(Canvas canvas, Offset a, Offset b, Paint p, {double dash = 7, double space = 5}) {
    final d = b - a;
    final len = d.distance;
    if (len == 0) return;
    final u = d / len;
    for (var t = 0.0; t < len; t += dash + space) {
      canvas.drawLine(a + u * t, a + u * math.min(t + dash, len), p);
    }
  }

  void _dashedRRect(Canvas canvas, RRect r, Paint p) {
    final path = Path()..addRRect(r);
    for (final metric in path.computeMetrics()) {
      for (var t = 0.0; t < metric.length; t += 12) {
        canvas.drawPath(metric.extractPath(t, math.min(t + 7, metric.length)), p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CoursePainter old) => old.s != s || old.full != full || old.badge != badge;
}
