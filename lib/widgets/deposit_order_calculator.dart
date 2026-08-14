import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';

/// Interactive deposit → working order size (percent range from lesson JSON items).
class DepositOrderCalculatorCard extends StatefulWidget {
  final String? title;
  final String? body;
  final double minPercent;
  final double maxPercent;

  const DepositOrderCalculatorCard({
    super.key,
    this.title,
    this.body,
    this.minPercent = 3,
    this.maxPercent = 5,
  });

  @override
  State<DepositOrderCalculatorCard> createState() => _DepositOrderCalculatorCardState();
}

class _DepositOrderCalculatorCardState extends State<DepositOrderCalculatorCard>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController(text: '500');
  late AnimationController _pulse;
  double _sliderPercent = 4;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulse.dispose();
    super.dispose();
  }

  double? get _deposit {
    final raw = _controller.text.replaceAll(',', '.').trim();
    if (raw.isEmpty) return null;
    return double.tryParse(raw);
  }

  @override
  Widget build(BuildContext context) {
    final deposit = _deposit;
    final order = deposit != null ? deposit * _sliderPercent / 100 : null;
    final minOrder = deposit != null ? deposit * widget.minPercent / 100 : null;
    final maxOrder = deposit != null ? deposit * widget.maxPercent / 100 : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(
        color: const Color(0xFF1A2332),
        border: Border.all(color: AppTheme.gold.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calculate_outlined, color: AppTheme.gold, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title ?? 'Калькулятор рабочего ордера',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ],
          ),
          if (widget.body != null) ...[
            const SizedBox(height: 10),
            Text(widget.body!, style: const TextStyle(height: 1.55, color: Colors.white70)),
          ],
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
            ],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Депозит, USDT',
              labelStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.account_balance_wallet_outlined, color: AppTheme.gold),
              filled: true,
              fillColor: Colors.black26,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.gold),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          Text(
            'Доля одного ордера: ${_sliderPercent.toStringAsFixed(0)}%',
            style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          Slider(
            value: _sliderPercent,
            min: widget.minPercent,
            max: widget.maxPercent,
            divisions: ((widget.maxPercent - widget.minPercent) * 2).round().clamp(1, 20),
            activeColor: AppTheme.gold,
            label: '${_sliderPercent.toStringAsFixed(1)}%',
            onChanged: (v) => setState(() => _sliderPercent = v),
          ),
          const SizedBox(height: 8),
          FadeTransition(
            opacity: Tween<double>(begin: 0.85, end: 1).animate(_pulse),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.gold.withValues(alpha: 0.18),
                    AppTheme.accent.withValues(alpha: 0.12),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.gold.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Рабочий ордер',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order != null ? '${order.toStringAsFixed(2)} USDT' : '—',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.gold,
                    ),
                  ),
                  if (minOrder != null && maxOrder != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Диапазон ${widget.minPercent.toStringAsFixed(0)}–${widget.maxPercent.toStringAsFixed(0)}%: '
                      '${minOrder.toStringAsFixed(0)} – ${maxOrder.toStringAsFixed(0)} USDT',
                      style: const TextStyle(color: Colors.white60, height: 1.4, fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
