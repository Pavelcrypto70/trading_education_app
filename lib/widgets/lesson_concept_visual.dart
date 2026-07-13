import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

enum ConceptVisualType {
  chart,
  support,
  resistance,
  risk,
  pattern,
  strategy,
  market,
  ethics,
  general,
}

ConceptVisualType conceptTypeFromText(String? heading, String module) {
  final h = (heading ?? '').toLowerCase();
  if (h.contains('support') || h.contains('поддерж') || h.contains('suporte')) {
    return ConceptVisualType.support;
  }
  if (h.contains('resist') || h.contains('сопротив') || h.contains('resistên')) {
    return ConceptVisualType.resistance;
  }
  if (h.contains('risk') || h.contains('риск') || h.contains('risco') || h.contains('стоп')) {
    return ConceptVisualType.risk;
  }
  if (h.contains('pattern') || h.contains('паттерн') || h.contains('padr')) {
    return ConceptVisualType.pattern;
  }
  if (h.contains('strategy') || h.contains('стратег') || h.contains('estrat')) {
    return ConceptVisualType.strategy;
  }
  if (h.contains('market') || h.contains('рынок') || h.contains('mercado')) {
    return ConceptVisualType.market;
  }
  if (h.contains('ethic') || h.contains('этик') || h.contains('ética')) {
    return ConceptVisualType.ethics;
  }
  if (h.contains('chart') || h.contains('график') || h.contains('gráfico') || h.contains('candle')) {
    return ConceptVisualType.chart;
  }
  switch (module.toLowerCase()) {
    case 'chart':
      return ConceptVisualType.chart;
    case 'patterns':
      return ConceptVisualType.pattern;
    case 'risk':
      return ConceptVisualType.risk;
    case 'strategy':
      return ConceptVisualType.strategy;
    case 'market':
      return ConceptVisualType.market;
    default:
      return ConceptVisualType.general;
  }
}

class LessonConceptVisual extends StatefulWidget {
  final ConceptVisualType type;
  final double height;

  const LessonConceptVisual({
    super.key,
    required this.type,
    this.height = 120,
  });

  @override
  State<LessonConceptVisual> createState() => _LessonConceptVisualState();
}

class _LessonConceptVisualState extends State<LessonConceptVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Container(
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppTheme.accent.withValues(alpha: 0.15),
                AppTheme.gold.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white12),
          ),
          child: CustomPaint(
            painter: _ConceptPainter(type: widget.type, t: _ctrl.value),
            child: Center(
              child: Icon(_iconFor(widget.type), color: AppTheme.gold.withValues(alpha: 0.7), size: 28),
            ),
          ),
        );
      },
    );
  }

  IconData _iconFor(ConceptVisualType t) => switch (t) {
        ConceptVisualType.support => Icons.trending_up,
        ConceptVisualType.resistance => Icons.trending_down,
        ConceptVisualType.risk => Icons.shield_outlined,
        ConceptVisualType.pattern => Icons.change_history,
        ConceptVisualType.strategy => Icons.route_outlined,
        ConceptVisualType.market => Icons.public,
        ConceptVisualType.ethics => Icons.gavel_outlined,
        ConceptVisualType.chart => Icons.candlestick_chart,
        ConceptVisualType.general => Icons.auto_awesome,
      };
}

class _ConceptPainter extends CustomPainter {
  final ConceptVisualType type;
  final double t;

  _ConceptPainter({required this.type, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppTheme.gold.withValues(alpha: 0.35);

    switch (type) {
      case ConceptVisualType.support:
      case ConceptVisualType.resistance:
        final y = size.height * (0.55 + 0.08 * math.sin(t * math.pi * 2));
        canvas.drawLine(Offset(16, y), Offset(size.width - 16, y), paint);
        break;
      case ConceptVisualType.risk:
        final path = Path();
        path.moveTo(size.width * 0.5, size.height * 0.2);
        path.lineTo(size.width * 0.75, size.height * 0.45);
        path.lineTo(size.width * 0.65, size.height * 0.45);
        path.lineTo(size.width * 0.65, size.height * 0.75);
        path.lineTo(size.width * 0.35, size.height * 0.75);
        path.lineTo(size.width * 0.35, size.height * 0.45);
        path.lineTo(size.width * 0.25, size.height * 0.45);
        path.close();
        canvas.drawPath(path, paint);
        break;
      case ConceptVisualType.pattern:
        final w = size.width * 0.6;
        final left = size.width * 0.2;
        final top = size.height * 0.25 + 8 * t;
        canvas.drawLine(Offset(left, top + w * 0.5), Offset(left + w * 0.5, top), paint);
        canvas.drawLine(Offset(left + w * 0.5, top), Offset(left + w, top + w * 0.5), paint);
        canvas.drawLine(Offset(left, top + w * 0.5), Offset(left + w, top + w * 0.5), paint);
        break;
      default:
        final path = Path();
        for (var i = 0; i <= 12; i++) {
          final x = 16 + (size.width - 32) * i / 12;
          final y = size.height * 0.55 + 20 * math.sin((i / 2) + t * math.pi * 2);
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConceptPainter old) => old.t != t;
}
