import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/locale_service.dart';
import '../theme.dart';
import 'lesson_charts.dart';

class AnimatedChartCard extends StatefulWidget {
  final String chartType;
  final String? title;
  final String? caption;

  const AnimatedChartCard({
    super.key,
    required this.chartType,
    this.title,
    this.caption,
  });

  @override
  State<AnimatedChartCard> createState() => _AnimatedChartCardState();
}

class _AnimatedChartCardState extends State<AnimatedChartCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;
  bool _explored = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.cardDecoration(
            color: AppTheme.surface,
            border: Border.all(
              color: _explored ? AppTheme.gold.withValues(alpha: 0.4) : Colors.white12,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.insights, size: 18, color: AppTheme.gold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.title ?? l10n.sectionChartExample,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
                  if (!_explored)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        l10n.tapToExplore,
                        style: const TextStyle(color: AppTheme.gold, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => setState(() => _explored = true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _explored ? 220 : 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: _explored
                        ? [BoxShadow(color: AppTheme.gold.withValues(alpha: 0.15), blurRadius: 20)]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        LessonChartWidget(chartType: widget.chartType),
                        if (!_explored)
                          Container(
                            color: Colors.black26,
                            child: Center(
                              child: Icon(Icons.touch_app, color: Colors.white.withValues(alpha: 0.7), size: 32),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.caption != null) ...[
                const SizedBox(height: 12),
                AnimatedOpacity(
                  opacity: _explored ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    widget.caption!,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: _explored ? Colors.white70 : Colors.white38,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class InteractiveBulletList extends StatefulWidget {
  final List<String> items;

  const InteractiveBulletList({super.key, required this.items});

  @override
  State<InteractiveBulletList> createState() => _InteractiveBulletListState();
}

class _InteractiveBulletListState extends State<InteractiveBulletList> {
  final Set<int> _revealed = {};

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.sectionKeyPoints, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 4),
        Text(l10n.tapEachPoint, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        const SizedBox(height: 12),
        ...List.generate(widget.items.length, (i) {
          final revealed = _revealed.contains(i);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: revealed ? AppTheme.gold.withValues(alpha: 0.08) : AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => _revealed.add(i)),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: revealed ? AppTheme.gold.withValues(alpha: 0.3) : Colors.white10,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        revealed ? Icons.check_circle : Icons.radio_button_unchecked,
                        size: 18,
                        color: revealed ? AppTheme.gold : Colors.white38,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          revealed ? widget.items[i] : '• • • • •',
                          style: TextStyle(
                            height: 1.4,
                            color: revealed ? Colors.white70 : Colors.white30,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class PriceSliderDemo extends StatefulWidget {
  const PriceSliderDemo({super.key});

  @override
  State<PriceSliderDemo> createState() => _PriceSliderDemoState();
}

class _PriceSliderDemoState extends State<PriceSliderDemo> {
  double _price = 50;
  static const _support = 45.0;
  static const _resistance = 55.0;

  String _zone(AppLocalizations l10n) {
    if (_price <= _support + 1) return l10n.zoneSupport;
    if (_price >= _resistance - 1) return l10n.zoneResistance;
    return l10n.zoneNeutral;
  }

  Color _zoneColor() {
    if (_price <= _support + 1) return const Color(0xFF26A69A);
    if (_price >= _resistance - 1) return const Color(0xFFEF5350);
    return Colors.white54;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(color: AppTheme.accent.withValues(alpha: 0.06)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.slideshow, color: AppTheme.accent, size: 18),
              const SizedBox(width: 8),
              Text(l10n.interactiveDemo, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFEF5350).withValues(alpha: 0.15),
                      Colors.transparent,
                      const Color(0xFF26A69A).withValues(alpha: 0.15),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 12,
                child: Text('R ${_resistance.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFFEF5350), fontSize: 11)),
              ),
              Positioned(
                bottom: 8,
                left: 12,
                child: Text('S ${_support.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF26A69A), fontSize: 11)),
              ),
              Text(
                '\$${_price.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppTheme.gold),
              ),
            ],
          ),
          Slider(
            value: _price,
            min: 40,
            max: 60,
            divisions: 40,
            activeColor: AppTheme.gold,
            onChanged: (v) => setState(() => _price = v),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _zoneColor().withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                _zone(l10n),
                style: TextStyle(color: _zoneColor(), fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
