import 'package:flutter/material.dart';

import '../models/trade_plan.dart';
import '../services/locale_service.dart';
import '../services/sim_mode.dart';
import '../services/trade_plan_service.dart';
import '../theme.dart';
import '../utils/num_format.dart';

/// Trade plan: entry, stop, take and size — in words the course has already explained.
/// The deal opens at the market price, so the entry always shows the current price;
/// stop and take stay where the learner put them.
class TradePlanForm extends StatefulWidget {
  final double currentPrice;
  final double balance;
  /// Lesson the practice belongs to (or the lesson the user has reached).
  final int lesson;
  final double minRiskReward;
  final ValueChanged<TradePlan?> onPlanChanged;

  const TradePlanForm({
    super.key,
    required this.currentPrice,
    required this.balance,
    required this.lesson,
    required this.onPlanChanged,
    this.minRiskReward = 0,
  });

  SimLevel get level => SimMode.forLesson(lesson);

  @override
  State<TradePlanForm> createState() => _TradePlanFormState();
}

class _TradePlanFormState extends State<TradePlanForm> {
  final _stopCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  final _riskCtrl = TextEditingController(text: '1');
  final _amountCtrl = TextEditingController(text: '1000');
  String _direction = 'long';
  int _leverage = 1;
  String? _error;
  /// Stop and take were set by “Set stop and take from the current price” and follow the price.
  bool _auto = true;

  bool get _futures => widget.level == SimLevel.futures;
  bool get _leverageOn => _futures && widget.lesson >= SimMode.leverageFrom;
  bool get _riskSizing => widget.level == SimLevel.spotRisk || _futures;

  String _fmt(double v) => fmtNum(v).replaceAll('\u00A0', '');
  double _num(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.').replaceAll(' ', '').replaceAll('\u00A0', '')) ?? 0;

  @override
  void initState() {
    super.initState();
    _fillAround(widget.currentPrice);
    _loadSaved();
    _validate(silent: true);
  }

  @override
  void didUpdateWidget(covariant TradePlanForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPrice != widget.currentPrice || oldWidget.lesson != widget.lesson) {
      if (_auto && widget.currentPrice > 0) _fillAround(widget.currentPrice);
      _validate(silent: true);
    }
  }

  Future<void> _loadSaved() async {
    final saved = await TradePlanService.getActive();
    if (!mounted) return;
    if (saved == null || widget.currentPrice <= 0 ||
        (saved.entry - widget.currentPrice).abs() / widget.currentPrice > 0.05 ||
        (!_futures && saved.direction == 'short')) {
      return;
    }
    _auto = false;
    setState(() {
      _direction = saved.direction;
      _stopCtrl.text = _fmt(saved.stop);
      _targetCtrl.text = _fmt(saved.target);
      _riskCtrl.text = _fmt(saved.riskPercent.clamp(0.25, 1)).replaceAll(RegExp(r',?0+$'), '');
      _amountCtrl.text = saved.amountUsdt.toStringAsFixed(0);
      _leverage = saved.leverage.clamp(1, 3);
    });
    _validate(silent: true);
  }

  void _fillAround(double price, {String? direction}) {
    final dir = direction ?? _direction;
    final p = TradePlanService.around(price, long: dir == 'long');
    _direction = dir;
    _stopCtrl.text = _fmt(p.stop);
    _targetCtrl.text = _fmt(p.target);
    _auto = true;
  }

  TradePlan get _plan => TradePlan(
        direction: _futures ? _direction : 'long',
        entry: widget.currentPrice,
        stop: _num(_stopCtrl),
        target: _num(_targetCtrl),
        riskPercent: _riskSizing ? _num(_riskCtrl) : 1,
        amountUsdt: _num(_amountCtrl),
        leverage: _leverageOn ? _leverage : 1,
      );

  void _validate({bool silent = false}) {
    final l10n = LocaleService.instance.strings;
    final plan = _plan;
    var err = TradePlanService.validate(plan, level: widget.level, minRiskReward: widget.minRiskReward);
    // Before lesson 49 the reader doesn't know liquidation: keep leverage-1 checks only.
    if (err == TradePlanService.stopPastLiquidation && widget.lesson < SimMode.liquidationFrom) {
      err = l10n.planStopTooFarForLev;
    }
    if (err == null && widget.level == SimLevel.spot && plan.amountUsdt > widget.balance) {
      err = l10n.paperBalanceOnly(fmtNum(widget.balance, 0));
    }
    void report() {
      if (!mounted) return;
      widget.onPlanChanged(err == null ? plan : null);
    }

    if (silent) {
      _error = err;
      // Called while the parent is building: report after this frame.
      WidgetsBinding.instance.addPostFrameCallback((_) => report());
    } else {
      setState(() => _error = err);
      if (err == null) TradePlanService.save(plan);
      report();
    }
  }

  @override
  void dispose() {
    for (final c in [_stopCtrl, _targetCtrl, _riskCtrl, _amountCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Coins, money at risk and possible profit for the current plan.
  ({double coins, double cost, double loss, double gain}) _numbers() {
    final p = _plan;
    final dist = (p.entry - p.stop).abs();
    if (p.entry <= 0 || dist <= 0) return (coins: 0, cost: 0, loss: 0, gain: 0);
    double coins;
    if (_riskSizing) {
      coins = widget.balance * p.riskPercent / 100 / dist;
      final lev = _futures ? p.leverage : 1;
      final fee = widget.lesson >= SimMode.feeFrom ? SimMode.feeRate : 0.0;
      final maxCoins = widget.balance * lev / (p.entry * (1 + lev * fee));
      if (coins > maxCoins) coins = maxCoins;
    } else {
      coins = p.amountUsdt / p.entry;
    }
    return (
      coins: coins,
      cost: coins * p.entry,
      loss: coins * dist,
      gain: coins * (p.target - p.entry).abs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final n = _numbers();
    final plan = _plan;
    final long = plan.direction == 'long';
    final liq = _futures ? plan.liquidationPrice : null;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(
        color: AppTheme.accent.withValues(alpha: 0.07),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note, color: AppTheme.accentText, size: 20),
              const SizedBox(width: 8),
              Text(l10n.tradePlanTitle, style: AppTheme.display(18, color: AppTheme.accentText)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.tradePlanIntro,
            style: const TextStyle(color: AppTheme.muted, fontSize: 12.5, height: 1.35),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() => _fillAround(widget.currentPrice));
                _validate();
              },
              icon: const Icon(Icons.sync, size: 16),
              label: Text(l10n.setStopTakeFromPrice),
            ),
          ),
          if (_futures) ...[
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'long', label: Text(l10n.sideLong), icon: const Icon(Icons.arrow_upward, size: 14)),
                ButtonSegment(value: 'short', label: Text(l10n.sideShort), icon: const Icon(Icons.arrow_downward, size: 14)),
              ],
              selected: {_direction},
              onSelectionChanged: (s) {
                setState(() => _fillAround(widget.currentPrice, direction: s.first));
                _validate();
              },
            ),
            const SizedBox(height: 4),
            Text(
              _direction == 'long' ? l10n.longHint : l10n.shortHint,
              style: const TextStyle(color: AppTheme.muted, fontSize: 12),
            ),
          ],
          const SizedBox(height: 12),
          _row(l10n.entryCurrentPrice, fmtPrice(widget.currentPrice), AppTheme.text),
          const SizedBox(height: 8),
          _field(l10n.planStop, long ? l10n.stopHintLong : l10n.stopHintShort, _stopCtrl, price: true),
          _field(l10n.planTarget, long ? l10n.takeHintLong : l10n.takeHintShort, _targetCtrl, price: true),
          if (_riskSizing)
            _field(l10n.riskPerTradeLabel, l10n.riskPerTradeHint, _riskCtrl)
          else
            _field(l10n.buyAmountLabel, l10n.buyAmountHint, _amountCtrl),
          if (_leverageOn) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Text(l10n.leverageLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(width: 12),
                for (final l in [1, 2, 3])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('$l'),
                      selected: _leverage == l,
                      onSelected: (_) {
                        setState(() => _leverage = l);
                        _validate();
                      },
                    ),
                  ),
              ],
            ),
            Text(
                [
                  _leverage == 1 ? l10n.leverage1Hint : l10n.leverageNHint(_leverage),
                  if (widget.lesson >= SimMode.isolatedFrom) l10n.isolatedMarginHint,
                ].join(' '),
                style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
          ],
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _futures
                    ? _row(l10n.contractLabel, l10n.contractRow(fmtNum(n.coins), fmtNum(n.cost, 0)), AppTheme.text)
                    : _row(l10n.willBuyLabel, l10n.willBuyRow(fmtNum(n.coins), fmtNum(n.cost, 0)), AppTheme.text),
                if (_futures && plan.leverage > 1)
                  _row(l10n.marginLabel, '${fmtNum(n.cost / plan.leverage, 0)} USDT', AppTheme.text),
                _row(l10n.ifStopHits, '−${fmtNum(n.loss)} USDT', AppTheme.bear),
                _row(l10n.ifTakeHits, '+${fmtNum(n.gain)} USDT', AppTheme.bull),
                if (widget.lesson >= SimMode.ratioFrom && n.loss > 0)
                  _row(l10n.riskToRewardLabel, l10n.riskRewardValue(TradePlanService.ratioText(n.gain / n.loss)),
                      widget.minRiskReward > 0 && !TradePlanService.ratioOk(n.gain / n.loss, widget.minRiskReward)
                          ? AppTheme.warn
                          : AppTheme.text),
                if (widget.minRiskReward > 0 && n.loss > 0 && !TradePlanService.ratioOk(n.gain / n.loss, widget.minRiskReward))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      l10n.rrNeedHint(TradePlanService.ratioText(widget.minRiskReward)),
                      style: const TextStyle(color: AppTheme.warn, fontSize: 12, height: 1.35),
                    ),
                  ),
                if (liq != null && widget.lesson >= SimMode.liquidationFrom)
                  _row(l10n.liqPriceApprox, fmtPrice(liq), AppTheme.bear),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_error == null ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                  size: 18, color: _error == null ? AppTheme.bull : AppTheme.warn),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _error ?? l10n.planReady,
                  style: TextStyle(
                    color: _error == null ? AppTheme.bull : AppTheme.warn,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String k, String v, Color c) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(child: Text(k, style: const TextStyle(color: AppTheme.muted, fontSize: 13))),
            Text(v, style: TextStyle(color: c, fontWeight: FontWeight.w800, fontSize: 13.5)),
          ],
        ),
      );

  Widget _field(String label, String hint, TextEditingController ctrl, {bool price = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          labelText: label,
          helperText: hint,
          helperMaxLines: 2,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        onChanged: (_) {
          if (price) _auto = false;
          _validate();
        },
      ),
    );
  }
}
