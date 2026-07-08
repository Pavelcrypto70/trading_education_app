import 'package:flutter/material.dart';

import '../models/trade_plan.dart';
import '../services/locale_service.dart';
import '../services/trade_plan_service.dart';
import '../theme.dart';

class TradePlanForm extends StatefulWidget {
  final double currentPrice;
  final bool required;
  final ValueChanged<TradePlan?> onPlanChanged;

  const TradePlanForm({
    super.key,
    required this.currentPrice,
    required this.required,
    required this.onPlanChanged,
  });

  @override
  State<TradePlanForm> createState() => _TradePlanFormState();
}

class _TradePlanFormState extends State<TradePlanForm> {
  final _entryCtrl = TextEditingController();
  final _stopCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  final _riskCtrl = TextEditingController(text: '1');
  String _direction = 'long';
  String? _errorKey;

  @override
  void initState() {
    super.initState();
    _entryCtrl.text = widget.currentPrice.toStringAsFixed(2);
    _stopCtrl.text = (widget.currentPrice * 0.98).toStringAsFixed(2);
    _targetCtrl.text = (widget.currentPrice * 1.04).toStringAsFixed(2);
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final saved = await TradePlanService.getActive();
    if (saved == null || !mounted) return;
    setState(() {
      _direction = saved.direction;
      _entryCtrl.text = saved.entry.toStringAsFixed(2);
      _stopCtrl.text = saved.stop.toStringAsFixed(2);
      _targetCtrl.text = saved.target.toStringAsFixed(2);
      _riskCtrl.text = saved.riskPercent.toStringAsFixed(1);
    });
    widget.onPlanChanged(saved);
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _stopCtrl.dispose();
    _targetCtrl.dispose();
    _riskCtrl.dispose();
    super.dispose();
  }

  void _validateAndSave() {
    final plan = TradePlan(
      direction: _direction,
      entry: double.tryParse(_entryCtrl.text) ?? 0,
      stop: double.tryParse(_stopCtrl.text) ?? 0,
      target: double.tryParse(_targetCtrl.text) ?? 0,
      riskPercent: double.tryParse(_riskCtrl.text) ?? 1,
    );
    final err = TradePlanService.validate(plan);
    setState(() => _errorKey = err);
    if (err == null) {
      TradePlanService.save(plan);
      widget.onPlanChanged(plan);
    } else {
      widget.onPlanChanged(null);
    }
  }

  String? _errorText() {
    final l10n = context.l10n;
    switch (_errorKey) {
      case 'invalidLevels':
        return l10n.planErrorLevels;
      case 'invalidRisk':
        return l10n.planErrorRisk;
      case 'stopAboveEntry':
        return l10n.planErrorStopLong;
      case 'targetBelowEntry':
        return l10n.planErrorTargetLong;
      case 'stopBelowEntry':
        return l10n.planErrorStopShort;
      case 'targetAboveEntry':
        return l10n.planErrorTargetShort;
      case 'lowRR':
        return l10n.planErrorRR;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final plan = TradePlan(
      direction: _direction,
      entry: double.tryParse(_entryCtrl.text) ?? 0,
      stop: double.tryParse(_stopCtrl.text) ?? 0,
      target: double.tryParse(_targetCtrl.text) ?? 0,
      riskPercent: double.tryParse(_riskCtrl.text) ?? 1,
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(
        color: AppTheme.accent.withValues(alpha: 0.08),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note, color: AppTheme.accent, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.required ? l10n.tradePlanRequired : l10n.tradePlanTitle,
                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'long', label: Text(l10n.buy), icon: const Icon(Icons.arrow_upward, size: 14)),
              ButtonSegment(value: 'short', label: Text(l10n.sell), icon: const Icon(Icons.arrow_downward, size: 14)),
            ],
            selected: {_direction},
            onSelectionChanged: (s) => setState(() => _direction = s.first),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _field(l10n.planEntry, _entryCtrl)),
              const SizedBox(width: 8),
              Expanded(child: _field(l10n.planStop, _stopCtrl)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _field(l10n.planTarget, _targetCtrl)),
              const SizedBox(width: 8),
              Expanded(child: _field(l10n.planRisk, _riskCtrl)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.planRR(plan.riskReward.toStringAsFixed(2)),
            style: TextStyle(
              color: plan.riskReward >= 1.5 ? Colors.greenAccent : Colors.orangeAccent,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (_errorKey != null) ...[
            const SizedBox(height: 6),
            Text(_errorText()!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _validateAndSave,
              child: Text(l10n.saveTradePlan),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      onChanged: (_) => _validateAndSave(),
    );
  }
}
