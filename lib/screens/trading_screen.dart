import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/journal_entry.dart';
import '../models/trade_plan.dart';
import '../services/demo_market_engine.dart';
import '../services/gamification_service.dart';
import '../services/journal_service.dart';
import '../services/lesson_practice_service.dart';
import '../services/locale_service.dart';
import '../services/progress_service.dart';
import '../services/trade_plan_service.dart';
import '../theme.dart';
import '../widgets/demo_trading_chart.dart';
import '../widgets/trade_plan_form.dart';

class TradingScreen extends StatefulWidget {
  const TradingScreen({super.key});

  @override
  State<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  final _engine = DemoMarketEngine.instance;

  double _balance = 10000;
  String? _position;
  double _positionSize = 0;
  double _entryPrice = 0;
  double _orderSize = 2.0;
  bool _loading = true;

  LessonPracticeContext? _practice;
  TradePlan? _plan;
  int? _returnLessonId;

  static const _pair = DemoMarketEngine.pair;
  static const _asset = DemoMarketEngine.symbol;

  Timer? _saveDebounce;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final q = GoRouterState.of(context).uri.queryParameters['returnLesson'];
    _returnLessonId = int.tryParse(q ?? '') ?? _returnLessonId;
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    _engine.onUpdate = null;
    _engine.stop();
    super.dispose();
  }

  Future<void> _load() async {
    _balance = await ProgressService.getVirtualBalance();
    _position = await ProgressService.getPosition();
    _positionSize = await ProgressService.getPositionSize();
    _entryPrice = await ProgressService.getEntryPrice();
    _practice = await LessonPracticeService.getActive();
    _plan = await TradePlanService.getActive();

    await _engine.load();

    _engine.onUpdate = () {
      if (!mounted) return;
      setState(() {});
      _scheduleSave();
    };
    _engine.start();

    if (!mounted) return;
    setState(() => _loading = false);
  }

  double get _currentPrice => _engine.currentPrice;

  double get _unrealizedPnl {
    if (_position == null || _positionSize == 0) return 0;
    if (_position == 'long') {
      return (_currentPrice - _entryPrice) * _positionSize;
    }
    return (_entryPrice - _currentPrice) * _positionSize;
  }

  double get _equity => _balance + _unrealizedPnl;

  bool get _planRequired => _practice != null;

  bool get _hasValidPlan {
    if (!_planRequired) return true;
    if (_plan == null) return false;
    return TradePlanService.validate(_plan!) == null;
  }

  double get _change24h {
    final cs = _engine.candles;
    if (cs.length < 2) return 0;
    final open = cs.first.open;
    if (open == 0) return 0;
    return ((_currentPrice - open) / open) * 100;
  }

  void _scheduleSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(seconds: 2), () {
      if (mounted) _saveQuiet();
    });
  }

  Future<void> _saveQuiet() async {
    await ProgressService.saveTradingState(
      balance: _balance,
      currentPrice: _currentPrice,
      priceHistory: _engine.candles.map((c) => c.close).toList(),
      position: _position,
      positionSize: _positionSize,
      entryPrice: _entryPrice,
      recordActivityOnSave: false,
    );
  }

  Future<void> _save() async {
    await _saveQuiet();
    if (mounted) setState(() {});
  }

  String _fmtMoney(double v) {
    final s = v.toStringAsFixed(2);
    final parts = s.split('.');
    final intPart = parts[0];
    final buf = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buf.write(',');
      buf.write(intPart[i]);
    }
    return '\$$buf.${parts[1]}';
  }

  Future<void> _buy() async {
    if (!_hasValidPlan) {
      _showMsg(context.l10n.planRequiredMsg);
      return;
    }

    if (_position == 'short') _closePositionInternal();

    if (_position == 'long') return;

    final size = _orderSize;
    final margin = _currentPrice * size * 0.1;
    if (_balance < margin) {
      _showMsg(context.l10n.insufficientBalance);
      return;
    }

    _balance -= margin;
    _position = 'long';
    _positionSize = size;
    _entryPrice = _currentPrice;

    final openedMsg = context.l10n.positionOpened;
    final priceLabel = _fmtMoney(_currentPrice);
    await _save();
    if (!mounted) return;
    _showMsg('$openedMsg $priceLabel');
  }

  Future<void> _sell() async {
    if (!_hasValidPlan) {
      _showMsg(context.l10n.planRequiredMsg);
      return;
    }

    if (_position == 'long') _closePositionInternal();

    if (_position == 'short') return;

    final size = _orderSize;
    _position = 'short';
    _positionSize = size;
    _entryPrice = _currentPrice;

    final openedMsg = context.l10n.positionOpened;
    final priceLabel = _fmtMoney(_currentPrice);
    await _save();
    if (!mounted) return;
    _showMsg('$openedMsg $priceLabel');
  }

  void _closePositionInternal() {
    if (_position == null) return;
    _balance += _unrealizedPnl;
    _position = null;
    _positionSize = 0;
    _entryPrice = 0;
  }

  Future<void> _closePosition() async {
    if (_position == null) return;

    final pnl = _unrealizedPnl;
    final side = _position!;
    final entry = _entryPrice;
    final exit = _currentPrice;

    _closePositionInternal();

    final plan = _plan;
    final practice = _practice;
    final completeMsg = practice != null
        ? context.l10n.lessonPracticeComplete(practice.lessonId)
        : null;
    final closedMsg = practice == null ? context.l10n.positionClosed : null;

    await JournalService.saveEntry(
      JournalEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        lessonId: practice?.lessonId,
        lessonTitle: practice?.lessonTitle,
        pair: practice?.symbol ?? _pair,
        setup: practice?.scenario ?? 'Paper trade',
        entry: plan?.entry.toStringAsFixed(2) ?? entry.toStringAsFixed(2),
        stop: plan?.stop.toStringAsFixed(2) ?? '',
        target: plan?.target.toStringAsFixed(2) ?? '',
        emotion: 'practice',
        notes: 'Paper $side @ ${_fmtMoney(entry)} → ${_fmtMoney(exit)}',
        result: '\$${pnl.toStringAsFixed(2)}',
      ),
    );
    await TradePlanService.clear();

    final practiceAfter = _practice;
    if (practiceAfter != null) {
      await LessonPracticeService.markDone(practiceAfter.lessonId);
      final xp = await GamificationService.addXp(GamificationService.xpPerCheckpoint);
      if (mounted) {
        _showMsg('$completeMsg +$xp XP');
        setState(() {
          _practice = null;
          _plan = null;
        });
      }
    } else if (mounted) {
      _showMsg('$closedMsg P&L: \$${pnl.toStringAsFixed(2)}');
    }

    await _save();
  }

  Future<void> _confirmReset() async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.reset),
        content: Text(l10n.resetAccountBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.reset)),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    _balance = 10000;
    _position = null;
    _positionSize = 0;
    _entryPrice = 0;
    _orderSize = 2.0;
    await _engine.reset();
    await _save();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.accountReset)),
      );
    }
  }

  void _showMsg(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final change = _change24h;
    final isUp = change >= 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.paperTrading),
        leading: (_returnLessonId != null || _practice != null)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: l10n.backToLesson(_returnLessonId ?? _practice!.lessonId),
                onPressed: () {
                  final id = _returnLessonId ?? _practice?.lessonId;
                  if (id != null) {
                    context.go('/lesson/$id');
                  } else {
                    context.go('/learning');
                  }
                },
              )
            : null,
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'reset') _confirmReset();
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(value: 'reset', child: Text(l10n.resetAccount)),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_practice != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: AppTheme.cardDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.school, color: Colors.greenAccent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.practiceLessonBanner(_practice!.lessonId, _practice!.lessonTitle),
                          style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.greenAccent),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: Colors.white38),
                        onPressed: () async {
                          await LessonPracticeService.clearActive();
                          setState(() => _practice = null);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_practice!.scenario, style: const TextStyle(color: Colors.white70, height: 1.45)),
                  Text(
                    _practice!.symbol,
                    style: const TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final id = _returnLessonId ?? _practice?.lessonId;
                        if (id != null) {
                          context.go('/lesson/$id');
                        } else {
                          context.go('/learning');
                        }
                      },
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: Text(
                        l10n.backToLesson(_returnLessonId ?? _practice!.lessonId),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          TradePlanForm(
            currentPrice: _currentPrice,
            required: _planRequired,
            onPlanChanged: (p) => setState(() => _plan = p),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.heroGradient(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.portfolioEquity, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 6),
                Text(
                  _fmtMoney(_equity),
                  style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: AppTheme.gold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cash: ${_fmtMoney(_balance)} · P&L: \$${_unrealizedPnl.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(_pair, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.live,
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _fmtMoney(_currentPrice),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: isUp ? Colors.greenAccent : Colors.redAccent,
                          ),
                        ),
                        Text(
                          '${isUp ? '+' : ''}${change.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: isUp ? Colors.greenAccent : Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '1m · ${l10n.demoMarketNote}',
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
                const SizedBox(height: 12),
                DemoTradingChart(
                  candles: List.of(_engine.candles),
                  currentPrice: _currentPrice,
                  entryPrice: _position != null ? _entryPrice : null,
                  stopPrice: _plan?.stop,
                  targetPrice: _plan?.target,
                  height: 300,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (_position != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.cardDecoration(color: AppTheme.gold.withValues(alpha: 0.08)),
              child: Row(
                children: [
                  Icon(
                    _position == 'long' ? Icons.arrow_upward : Icons.arrow_downward,
                    color: AppTheme.gold,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_position!.toUpperCase()} · ${_positionSize.toStringAsFixed(2)} $_asset',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Entry: ${_fmtMoney(_entryPrice)}',
                          style: const TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                        Text(
                          'P&L: \$${_unrealizedPnl.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: _unrealizedPnl >= 0 ? Colors.greenAccent : Colors.redAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(onPressed: _closePosition, child: Text(l10n.close)),
                ],
              ),
            ),

          if (_position == null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Text(l10n.positionSize, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const Spacer(),
                Text(
                  '${_orderSize.toStringAsFixed(2)} $_asset',
                  style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Slider(
              value: _orderSize,
              min: 0.5,
              max: 15,
              divisions: 29,
              activeColor: AppTheme.gold,
              onChanged: (v) => setState(() => _orderSize = v),
            ),
            Text(
              '${l10n.marginRequired}: ${_fmtMoney(_currentPrice * _orderSize * 0.1)} (10×)',
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 12),
          ],

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _buy,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(l10n.buy),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _sell,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(l10n.sell),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.howItWorks, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  l10n.tradingHowItWorks,
                  style: const TextStyle(color: Colors.white54, height: 1.5, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
