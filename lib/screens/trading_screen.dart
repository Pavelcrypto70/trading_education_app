import 'dart:math';



import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';



import '../services/gamification_service.dart';
import '../models/journal_entry.dart';
import '../models/trade_plan.dart';
import '../services/journal_service.dart';
import '../services/lesson_practice_service.dart';
import '../services/locale_service.dart';
import '../services/progress_service.dart';
import '../services/trade_plan_service.dart';

import '../theme.dart';
import '../widgets/trade_plan_form.dart';



class TradingScreen extends StatefulWidget {

  const TradingScreen({super.key});



  @override

  State<TradingScreen> createState() => _TradingScreenState();

}



class _TradingScreenState extends State<TradingScreen> {

  final _random = Random();

  double _balance = 10000;

  double _currentPrice = 100;

  List<double> _priceHistory = [100];

  String? _position;

  double _positionSize = 0;

  double _entryPrice = 0;

  bool _loading = true;

  LessonPracticeContext? _practice;
  TradePlan? _plan;



  @override

  void initState() {

    super.initState();

    _load();

  }



  Future<void> _load() async {

    _balance = await ProgressService.getVirtualBalance();

    _currentPrice = await ProgressService.getCurrentPrice();

    _priceHistory = await ProgressService.getPriceHistory();

    _position = await ProgressService.getPosition();

    _positionSize = await ProgressService.getPositionSize();

    _entryPrice = await ProgressService.getEntryPrice();

    _practice = await LessonPracticeService.getActive();
    _plan = await TradePlanService.getActive();

    if (!mounted) return;

    setState(() => _loading = false);

  }



  Future<void> _tickPrice() async {

    final change = (_random.nextDouble() - 0.48) * 2.5;

    _currentPrice = (_currentPrice + change).clamp(50.0, 200.0);

    _priceHistory = [..._priceHistory, _currentPrice];

    if (_priceHistory.length > 40) {

      _priceHistory = _priceHistory.sublist(_priceHistory.length - 40);

    }

    await _save();

    if (mounted) setState(() {});

  }



  Future<void> _save() async {

    await ProgressService.saveTradingState(

      balance: _balance,

      currentPrice: _currentPrice,

      priceHistory: _priceHistory,

      position: _position,

      positionSize: _positionSize,

      entryPrice: _entryPrice,

    );

  }



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

  Future<void> _buy() async {
    if (!_hasValidPlan) {
      _showMsg(context.l10n.planRequiredMsg);
      return;
    }

    await _tickPrice();

    if (_position == 'short') {

      _closePosition();

    }

    if (_position == 'long') return;

    const size = 10.0;

    final cost = _currentPrice * size * 0.1;

    if (_balance < cost) {

      _showMsg('Insufficient balance');

      return;

    }

    _balance -= cost;

    _position = 'long';

    _positionSize = size;

    _entryPrice = _currentPrice;

    await _save();

    _showMsg('${context.l10n.positionOpened} \$${_currentPrice.toStringAsFixed(2)}');

  }



  Future<void> _sell() async {
    if (!_hasValidPlan) {
      _showMsg(context.l10n.planRequiredMsg);
      return;
    }

    await _tickPrice();

    if (_position == 'long') {

      _closePosition();

    }

    if (_position == 'short') return;

    const size = 10.0;

    _position = 'short';

    _positionSize = size;

    _entryPrice = _currentPrice;

    await _save();

    _showMsg('${context.l10n.positionOpened} \$${_currentPrice.toStringAsFixed(2)}');

  }



  void _closePosition() async {
    if (_position == null) return;

    final pnl = _unrealizedPnl;
    final side = _position!;
    final entry = _entryPrice;
    final exit = _currentPrice;
    _balance += pnl;

    _position = null;
    _positionSize = 0;
    _entryPrice = 0;

    final plan = _plan;
    await JournalService.saveEntry(
      JournalEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        lessonId: _practice?.lessonId,
        lessonTitle: _practice?.lessonTitle,
        pair: _practice?.symbol ?? 'DEMO/USD',
        setup: _practice?.scenario ?? 'Paper trade',
        entry: plan?.entry.toStringAsFixed(2) ?? entry.toStringAsFixed(2),
        stop: plan?.stop.toStringAsFixed(2) ?? '',
        target: plan?.target.toStringAsFixed(2) ?? '',
        emotion: 'practice',
        notes: 'Paper $side @ \$${entry.toStringAsFixed(2)} → \$${exit.toStringAsFixed(2)}',
        result: '\$${pnl.toStringAsFixed(2)}',
      ),
    );
    await TradePlanService.clear();

    final practice = _practice;
    if (practice != null) {
      await LessonPracticeService.markDone(practice.lessonId);
      final xp = await GamificationService.addXp(GamificationService.xpPerCheckpoint);
      if (mounted) {
        _showMsg('${context.l10n.lessonPracticeComplete(practice.lessonId)} +$xp XP');
        setState(() {
          _practice = null;
          _plan = null;
        });
      }
    } else {
      _showMsg('${context.l10n.positionClosed} P&L: \$${pnl.toStringAsFixed(2)}');
    }

    await _save();
    if (mounted) setState(() {});
  }



  Future<void> _reset() async {

    _balance = 10000;

    _currentPrice = 100;

    _priceHistory = [100];

    _position = null;

    _positionSize = 0;

    _entryPrice = 0;

    await _save();

    if (mounted) setState(() {});

  }



  void _showMsg(String msg) {

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

    setState(() {});

  }



  @override

  Widget build(BuildContext context) {

    final l10n = context.l10n;



    if (_loading) {

      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    }



    final isUp = _priceHistory.length >= 2 &&

        _priceHistory.last >= _priceHistory[_priceHistory.length - 2];



    return Scaffold(

      appBar: AppBar(

        title: Text(l10n.paperTrading),

        actions: [

          IconButton(

            onPressed: _reset,

            icon: const Icon(Icons.refresh),

            tooltip: l10n.reset,

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

                  '\$${_equity.toStringAsFixed(2)}',

                  style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: AppTheme.gold),

                ),

                const SizedBox(height: 8),

                Text(

                  'Cash: \$${_balance.toStringAsFixed(2)} · P&L: \$${_unrealizedPnl.toStringAsFixed(2)}',

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

                    const Text('DEMO/USD', style: TextStyle(fontWeight: FontWeight.w700)),

                    const Spacer(),

                    Text(

                      '\$${_currentPrice.toStringAsFixed(2)}',

                      style: TextStyle(

                        fontWeight: FontWeight.w800,

                        color: isUp ? Colors.greenAccent : Colors.redAccent,

                      ),

                    ),

                    IconButton(

                      onPressed: _tickPrice,

                      icon: const Icon(Icons.update, size: 20),

                      tooltip: 'Update price',

                    ),

                  ],

                ),

                const SizedBox(height: 12),

                SizedBox(

                  height: 180,

                  child: LineChart(

                    LineChartData(

                      gridData: const FlGridData(show: false),

                      titlesData: const FlTitlesData(show: false),

                      borderData: FlBorderData(show: false),

                      minY: (_priceHistory.reduce((a, b) => a < b ? a : b)) - 5,

                      maxY: (_priceHistory.reduce((a, b) => a > b ? a : b)) + 5,

                      lineBarsData: [

                        LineChartBarData(

                          spots: List.generate(

                            _priceHistory.length,

                            (i) => FlSpot(i.toDouble(), _priceHistory[i]),

                          ),

                          isCurved: true,

                          barWidth: 2.5,

                          color: isUp ? Colors.greenAccent : Colors.redAccent,

                          dotData: const FlDotData(show: false),

                          belowBarData: BarAreaData(

                            show: true,

                            gradient: LinearGradient(

                              colors: [

                                (isUp ? Colors.greenAccent : Colors.redAccent).withValues(alpha: 0.2),

                                Colors.transparent,

                              ],

                              begin: Alignment.topCenter,

                              end: Alignment.bottomCenter,

                            ),

                          ),

                        ),

                      ],

                    ),

                  ),

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

                          '${_position!.toUpperCase()} · ${_positionSize.toStringAsFixed(0)} units',

                          style: const TextStyle(fontWeight: FontWeight.w700),

                        ),

                        Text(

                          'Entry: \$${_entryPrice.toStringAsFixed(2)}',

                          style: const TextStyle(color: Colors.white54, fontSize: 13),

                        ),

                      ],

                    ),

                  ),

                  TextButton(onPressed: _closePosition, child: Text(l10n.close)),

                ],

              ),

            ),

          const SizedBox(height: 16),

          Row(

            children: [

              Expanded(

                child: ElevatedButton(

                  onPressed: _buy,

                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),

                  child: Text(l10n.buy),

                ),

              ),

              const SizedBox(width: 12),

              Expanded(

                child: ElevatedButton(

                  onPressed: _sell,

                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),

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


