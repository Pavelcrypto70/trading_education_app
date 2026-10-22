import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/lessons_repository.dart';
import '../models/journal_entry.dart';
import '../models/trade_plan.dart';
import '../services/demo_market_engine.dart';
import '../services/gamification_service.dart';
import '../services/journal_service.dart';
import '../services/lesson_practice_service.dart';
import '../services/practice_brief_service.dart';
import '../services/progress_service.dart';
import '../services/sim_mode.dart';
import '../services/trade_plan_service.dart';
import '../l10n/app_localizations.dart';
import '../services/locale_service.dart';
import '../theme.dart';
import '../utils/num_format.dart';
import '../widgets/demo_trading_chart.dart';
import '../widgets/trade_plan_form.dart';

/// Учебная биржа. What it shows grows with the course: buy-only spot first,
/// size from risk from lesson 38, long/short with leverage ≤ 3 from lesson 48.
class TradingScreen extends StatefulWidget {
  const TradingScreen({super.key});

  @override
  State<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  final _engine = DemoMarketEngine.instance;

  static const _kLev = 'simLeverage';
  static const _kStop = 'simStop';
  static const _kTarget = 'simTarget';
  static const _kOpenFee = 'simOpenFee';
  static const _kStopOk = 'simStopFarEnough';

  double _balance = 10000;
  String? _side; // long | short
  double _coins = 0;
  double _entry = 0;
  double _locked = 0; // money taken from the account for the open deal
  double _openFee = 0;
  /// The stop of the open deal was a real one when it opened (not glued to the entry).
  bool _stopFarEnough = true;
  int _leverage = 1;
  double? _stop;
  double? _target;

  bool _loading = true;
  bool _coachOpen = true;
  ({String reason, double pnl})? _lastClose;
  List<JournalEntry> _history = const [];
  int _lossesInRowToday = 0;
  bool _bigCandles = false;

  Future<void> _loadHistory() async {
    final all = await JournalService.getEntries();
    final sim = all.where((e) => e.closeReason != null).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final now = DateTime.now();
    var losses = 0;
    for (final e in sim) {
      final d = e.createdAt;
      if (d.year != now.year || d.month != now.month || d.day != now.day) break;
      if (e.closeReason == 'breakeven' || !(e.result ?? '').trim().startsWith('-')) break;
      losses++;
    }
    if (mounted) {
      setState(() {
        _history = sim.take(5).toList();
        _lossesInRowToday = losses;
      });
    }
  }

  /// Stop-day rule from lesson 45: two losses in a row today — no new deals until tomorrow.
  bool get _stopDay => _lesson >= SimMode.stopDayFrom && _lossesInRowToday >= 2;

  int _lesson = 0;
  LessonPracticeContext? _practice;
  PracticeBrief? _brief;
  TradePlan? _plan;
  int? _returnLessonId;
  bool _practiceDone = false;
  Timer? _saveDebounce;

  SimLevel get _level => SimMode.forLesson(_lesson);
  double get _px => _engine.currentPrice;

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
    final prefs = await SharedPreferences.getInstance();
    _balance = await ProgressService.getVirtualBalance();
    _side = await ProgressService.getPosition();
    _coins = await ProgressService.getPositionSize();
    _entry = await ProgressService.getEntryPrice();
    _leverage = prefs.getInt(_kLev) ?? 1;
    _stop = prefs.getDouble(_kStop);
    _target = prefs.getDouble(_kTarget);
    _openFee = prefs.getDouble(_kOpenFee) ?? 0;
    _stopFarEnough = prefs.getBool(_kStopOk) ?? true;
    if (_side != null) _locked = _entry * _coins / _leverage;

    _practice = await LessonPracticeService.getActive();
    // An old unfinished task of another lesson must not take over the lesson the learner came from.
    if (_returnLessonId != null && _practice?.lessonId != _returnLessonId) _practice = null;
    final lessonId = _returnLessonId ?? _practice?.lessonId;
    if (lessonId != null) {
      _lesson = lessonId;
      _brief = await PracticeBriefService.load(lessonId);
      _practiceDone = _practice == null && await LessonPracticeService.isDone(lessonId);
      if (_practice == null && !_practiceDone && _lesson >= SimMode.firstOpenLesson) {
        final lesson = await LessonsRepository().getLessonById(lessonId);
        await LessonPracticeService.startPractice(
            lessonId: lessonId, lessonTitle: lesson?.title ?? LocaleService.instance.strings.lessonFallback(lessonId), symbol: DemoMarketEngine.pair);
        _practice = await LessonPracticeService.getActive();
      }
    } else {
      _lesson = await SimMode.reachedLesson();
      _brief = PracticeBriefService.free();
    }

    await _loadHistory();
    await _engine.load();
    _engine.onUpdate = () {
      if (!mounted) return;
      _checkExits();
      setState(() {});
      _scheduleSave();
    };
    _engine.start();
    if (mounted) setState(() => _loading = false);
  }

  double get _openPnl {
    if (_side == null) return 0;
    return _side == 'long' ? (_px - _entry) * _coins : (_entry - _px) * _coins;
  }

  double get _total => _balance + _locked + _openPnl;

  double? get _liqPrice {
    if (_side == null || _leverage <= 1) return null;
    return TradePlan(direction: _side!, entry: _entry, stop: 0, target: 0, riskPercent: 1, leverage: _leverage)
        .liquidationPrice;
  }

  void _checkExits() {
    if (_side == null) return;
    final px = _px;
    final long = _side == 'long';
    final liq = _liqPrice;
    if (liq != null && (long ? px <= liq : px >= liq)) {
      _close(at: liq, reason: 'liquidation');
    } else if (_stop != null && (long ? px <= _stop! : px >= _stop!)) {
      _close(at: _stop!, reason: 'stop');
    } else if (_target != null && (long ? px >= _target! : px <= _target!)) {
      _close(at: _target!, reason: 'target');
    }
  }

  /// Coins for the plan: from amount (spot) or from risk and stop distance.
  double _coinsFor(TradePlan p) {
    final dist = (p.entry - p.stop).abs();
    if (_level == SimLevel.spot) return p.amountUsdt / _px;
    if (dist <= 0) return 0;
    final byRisk = _balance * p.riskPercent / 100 / dist;
    final fee = _lesson >= SimMode.feeFrom ? SimMode.feeRate : 0.0;
    final maxCoins = _balance * p.leverage / (_px * (1 + p.leverage * fee));
    return math.min(byRisk, maxCoins);
  }

  Future<void> _open(String side) async {
    final plan = _plan;
    final l10n = LocaleService.instance.strings;
    if (plan == null) {
      _msg(l10n.fillStopTakeFirst);
      return;
    }
    if (plan.direction != side) {
      _msg(side == 'long' ? l10n.planIsShortPickLong : l10n.planIsLongPickShort);
      return;
    }
    if (_side != null) {
      _msg(l10n.tradeAlreadyOpen);
      return;
    }
    if (_stopDay) {
      _msg(l10n.stopDaySnack);
      return;
    }
    // A market deal opens at the price of this moment; stop and take stay exactly where the plan put them.
    final now = TradePlan(
      direction: plan.direction,
      entry: _px,
      stop: plan.stop,
      target: plan.target,
      riskPercent: plan.riskPercent,
      amountUsdt: plan.amountUsdt,
      leverage: plan.leverage,
    );
    final minRr = _minRiskReward(_brief);
    final err = TradePlanService.validate(now, minRiskReward: minRr, level: _level);
    if (err != null) {
      _msg(l10n.priceNowWithErr(fmtPrice(_px), err));
      return;
    }
    final long = side == 'long';
    final lev = _level == SimLevel.futures ? now.leverage : 1;
    final coins = _coinsFor(now);
    final locked = coins * _px / lev;
    final fee = _feeFor(coins * _px);
    if (coins <= 0 || locked + fee > _balance + 0.01) {
      _msg(l10n.notEnoughPaperMoney);
      return;
    }
    setState(() {
      _balance -= locked + fee;
      _openFee = fee;
      _stopFarEnough = TradePlanService.stopFarEnough(_px, now.stop);
      _locked = locked;
      _side = side;
      _coins = coins;
      _entry = _px;
      _leverage = lev;
      _stop = now.stop;
      _target = now.target;
      _lastClose = null;
    });
    await _save();
    final what = _level != SimLevel.futures
        ? l10n.boughtSol(fmtNum(coins))
        : (long ? l10n.openedLongContract(fmtNum(coins)) : l10n.openedShortContract(fmtNum(coins)));
    final feePart = fee > 0 ? l10n.feePartUsdt(fmtNum(fee)) : '';
    _msg(l10n.openTradeSnack(what, fmtPrice(_px), fmtPrice(_stop!), fmtPrice(_target!), feePart));
  }

  /// Exchange fee, charged once the course has explained it (lesson 53).
  double _feeFor(double notional) => _lesson >= SimMode.feeFrom ? notional * SimMode.feeRate : 0;

  /// Stop may only move closer to the price: to the entry once half the way to the take is done.
  bool get _canBreakeven {
    if (_side == null || _stop == null || _target == null) return false;
    final long = _side == 'long';
    final half = (_entry + _target!) / 2;
    final halfway = long ? _px >= half : _px <= half;
    final alreadyThere = long ? _stop! >= _entry : _stop! <= _entry;
    return halfway && !alreadyThere;
  }

  Future<void> _moveStopToEntry() async {
    final l10n = LocaleService.instance.strings;
    if (!_canBreakeven) {
      _msg(l10n.moveStopHalfwayOnly);
      return;
    }
    setState(() => _stop = _entry);
    await _save();
    _msg(l10n.stopMovedToEntry(fmtPrice(_entry)));
  }

  void _close({required double at, required String reason}) {
    if (_side == null) return;
    final side = _side!;
    final entry = _entry;
    if (reason == 'stop' && _stop == entry) reason = 'breakeven';
    var pnl = side == 'long' ? (at - entry) * _coins : (entry - at) * _coins;
    if (reason == 'liquidation') pnl = -_locked;
    final exitFee = reason == 'liquidation' ? 0.0 : _feeFor(_coins * at);
    _balance += _locked + pnl - exitFee;
    pnl -= _openFee + exitFee;
    _openFee = 0;
    final stop = _stop, target = _target;
    final stopOk = _stopFarEnough;
    _stopFarEnough = true;
    _locked = 0;
    _side = null;
    _coins = 0;
    _entry = 0;
    _stop = null;
    _target = null;
    _lastClose = (reason: reason, pnl: pnl);
    if (mounted) setState(() {});
    _finish(side: side, entry: entry, exit: at, pnl: pnl, reason: reason, stop: stop, target: target, stopOk: stopOk);
  }

  /// From the risk-to-reward lesson on, every plan (free practice too) needs at least 1 to 2.
  double _minRiskReward(PracticeBrief? brief) {
    if (_lesson < SimMode.ratioFrom) return 0;
    final m = brief?.minRiskReward ?? 0;
    return m < 2 ? 2 : m;
  }

  String _sideName(String side) {
    final l10n = LocaleService.instance.strings;
    return _level != SimLevel.futures
        ? l10n.sideBuy
        : (side == 'long' ? l10n.sideLong : l10n.sideShort);
  }

  Future<void> _finish({
    required String side,
    required double entry,
    required double exit,
    required double pnl,
    required String reason,
    double? stop,
    double? target,
    bool stopOk = true,
  }) async {
    final practice = _practice;
    await JournalService.saveEntry(
      JournalEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        lessonId: practice?.lessonId,
        lessonTitle: practice?.lessonTitle,
        pair: DemoMarketEngine.pair,
        setup: _brief?.idea ?? LocaleService.instance.strings.paperTradeSetup,
        entry: fmtPrice(entry),
        stop: stop == null ? '' : fmtPrice(stop),
        target: target == null ? '' : fmtPrice(target),
        emotion: '',
        notes: LocaleService.instance.strings.tradeNotesLine(_sideName(side), fmtPrice(entry), fmtPrice(exit), _reasonText(reason)),
        result: '${fmtSigned(pnl)} USDT',
        closeReason: reason,
      ),
      awardPoints: false,
    );
    // Points and the lesson task reward following the plan, never the profit:
    // only a close by stop or take counts, and only with a real stop.
    final closedByPlan = stop != null && target != null && (reason == 'stop' || reason == 'breakeven' || reason == 'target');
    final byPlan = closedByPlan && stopOk;
    final award = byPlan
        ? await GamificationService.award(PointsReason.paperTrade,
            uniqueKey: 'trade-${DateTime.now().millisecondsSinceEpoch}')
        : null;
    if (practice != null && byPlan) await LessonPracticeService.markDone(practice.lessonId);
    if (!mounted) return;
    final l10n = LocaleService.instance.strings;
    final pts = award == null || award.isZero
        ? ''
        : l10n.pointsForPlanTrade(award.awarded, pointsWord(award.awarded));
    final tooClose = closedByPlan && !stopOk ? l10n.stopTooCloseNoPoints : '';
    final task = practice == null
        ? ''
        : byPlan
            ? l10n.lessonTaskDone
            : closedByPlan
                ? l10n.openNewFartherStop
                : l10n.taskNotCountedOpenNew;
    _msg(l10n.closeSnack(_reasonText(reason), fmtSigned(pnl), '$pts$tooClose$task'));
    setState(() {
      if (byPlan && practice != null) {
        _practiceDone = true;
        _returnLessonId ??= practice.lessonId;
        _practice = null;
      }
    });
    await _save();
    await _loadHistory();
  }

  String _reasonText(String r) {
    final l10n = LocaleService.instance.strings;
    return switch (r) {
      'stop' => l10n.reasonStopHit,
      'breakeven' => l10n.reasonBreakevenHit,
      'target' => l10n.reasonTakeHit,
      'liquidation' => l10n.reasonLiquidation,
      _ => l10n.reasonManualClose,
    };
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
      currentPrice: _px,
      priceHistory: _engine.candles.map((c) => c.close).toList(),
      position: _side,
      positionSize: _coins,
      entryPrice: _entry,
      recordActivityOnSave: false,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kLev, _leverage);
    _stop == null ? await prefs.remove(_kStop) : await prefs.setDouble(_kStop, _stop!);
    _target == null ? await prefs.remove(_kTarget) : await prefs.setDouble(_kTarget, _target!);
    await prefs.setDouble(_kOpenFee, _openFee);
    await prefs.setBool(_kStopOk, _stopFarEnough);
  }

  Future<void> _save() async {
    await _saveQuiet();
    if (mounted) setState(() {});
  }

  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final d = ctx.l10n;
        return AlertDialog(
          title: Text(d.resetPaperTitle),
          content: Text(d.resetPaperBody),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(d.cancel)),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(d.reset)),
          ],
        );
      },
    );
    if (ok != true || !mounted) return;
    setState(() {
      _balance = 10000;
      _side = null;
      _coins = 0;
      _entry = 0;
      _locked = 0;
      _openFee = 0;
      _stopFarEnough = true;
      _stop = null;
      _target = null;
      _lastClose = null;
    });
    await _engine.reset();
    await _save();
  }

  void _msg(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  void _back() {
    final id = _returnLessonId ?? _practice?.lessonId;
    context.go(id != null ? '/lesson/$id' : '/learning');
  }

  String _usdt(double v) => '${fmtNum(v)} USDT';

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final l10n = context.l10n;
    final fromLesson = _returnLessonId != null || _practice != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.paperExchangeTitle),
        leading: fromLesson
            ? IconButton(icon: const Icon(Icons.arrow_back), tooltip: l10n.backToLessonTooltip, onPressed: _back)
            : null,
        actions: [
          if (_level != SimLevel.locked)
            PopupMenuButton<String>(
              onSelected: (v) => v == 'reset' ? _confirmReset() : null,
              itemBuilder: (_) => [
                PopupMenuItem(value: 'reset', child: Text(l10n.resetPaperAccount)),
              ],
            ),
        ],
      ),
      body: _level == SimLevel.locked ? _lockedView(l10n) : _simView(),
    );
  }

  Widget _lockedView(AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 24),
        Container(
          width: 72,
          height: 72,
          decoration: AppTheme.claySquare(AppTheme.lavender),
          child: const Icon(Icons.lock_clock_rounded, color: AppTheme.onPastel, size: 36),
        ),
        const SizedBox(height: 20),
        Text(l10n.paperExchangeOpensAfter(13), style: AppTheme.display(24)),
        const SizedBox(height: 12),
        Text(
          l10n.paperExchangeLockedBody,
          style: const TextStyle(color: AppTheme.textSoft, height: 1.5, fontSize: 15.5),
        ),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () => context.go('/learning'), child: Text(l10n.toLessonsBtn)),
      ],
    );
  }

  Widget _simView() {
    final l10n = context.l10n;
    final brief = _brief;
    final up = _engine.candles.isEmpty || _engine.candles.last.isBullish;
    final futures = _level == SimLevel.futures;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        if (brief != null)
          _CoachCard(
            brief: brief,
            open: _coachOpen,
            done: _practiceDone,
            onToggle: () => setState(() => _coachOpen = !_coachOpen),
            onBack: _returnLessonId != null || _practice != null ? _back : null,
          ),
        if (_lastClose != null) ...[
          const SizedBox(height: 12),
          _ResultBanner(code: _lastClose!.reason, title: _reasonText(_lastClose!.reason), pnl: _lastClose!.pnl),
        ],
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.paperAccountLabel, style: const TextStyle(color: AppTheme.muted, fontSize: 12.5)),
                  Text(_usdt(_total), style: AppTheme.display(24)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(l10n.freeBalanceLabel(_usdt(_balance)), style: const TextStyle(color: AppTheme.muted, fontSize: 12.5)),
                if (_side != null)
                  Text(l10n.onTradePnl(fmtSigned(_openPnl)),
                      style: TextStyle(fontWeight: FontWeight.w800, color: _openPnl >= 0 ? AppTheme.bull : AppTheme.bear)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: AppTheme.cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(DemoMarketEngine.pair, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  const Spacer(),
                  Text(l10n.priceNowLabel, style: const TextStyle(color: AppTheme.muted, fontSize: 12.5)),
                  Text(fmtPrice(_px),
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: up ? AppTheme.bull : AppTheme.bear)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                  l10n.priceDisclaimer(_bigCandles ? l10n.candleAbout17s : l10n.candleAbout4s),
                  style: const TextStyle(color: AppTheme.faint, fontSize: 11.5, height: 1.35)),
              if (_lesson >= SimMode.bigCandlesFrom) ...[
                const SizedBox(height: 10),
                SegmentedButton<bool>(
                  segments: [
                    ButtonSegment(value: false, label: Text(l10n.normalCandles)),
                    ButtonSegment(value: true, label: Text(l10n.bigCandles)),
                  ],
                  selected: {_bigCandles},
                  showSelectedIcon: false,
                  onSelectionChanged: (s) => setState(() => _bigCandles = s.first),
                ),
                const SizedBox(height: 4),
                Text(l10n.bigCandleHint,
                    style: const TextStyle(color: AppTheme.faint, fontSize: 11.5)),
              ],
              const SizedBox(height: 10),
              DemoTradingChart(
                candles: _bigCandles ? _engine.grouped(4) : _engine.candles.sublist(math.max(0, _engine.candles.length - 80)),
                currentPrice: _px,
                shortSide: (_side ?? _plan?.direction) == 'short',
                entryPrice: _side != null ? _entry : _plan?.entry,
                stopPrice: _side != null ? _stop : _plan?.stop,
                targetPrice: _side != null ? _target : _plan?.target,
                liquidationPrice: _lesson >= SimMode.liquidationFrom
                    ? (_side != null ? _liqPrice : _plan?.liquidationPrice)
                    : null,
                height: 260,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_side != null)
          _PositionCard(
            side: _side!,
            futures: futures,
            coins: _coins,
            entry: _entry,
            stop: _stop,
            target: _target,
            pnl: _openPnl,
            onClose: () => _close(at: _px, reason: 'manual'),
            onBreakeven: _lesson >= SimMode.breakevenFrom ? _moveStopToEntry : null,
            canBreakeven: _canBreakeven,
          )
        else ...[
          TradePlanForm(
            currentPrice: _px,
            balance: _balance,
            lesson: _lesson,
            minRiskReward: _minRiskReward(brief),
            onPlanChanged: (p) => setState(() => _plan = p),
          ),
          const SizedBox(height: 14),
          if (_stopDay)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: AppTheme.cardDecoration(color: AppTheme.bear.withValues(alpha: 0.12)),
              child: Text(
                l10n.stopDayBanner,
                style: const TextStyle(color: AppTheme.text, height: 1.45, fontWeight: FontWeight.w600),
              ),
            )
          else if (futures)
            Row(
              children: [
                Expanded(child: _tradeButton(l10n.openLongBtn, AppTheme.bull, AppTheme.onPastel, () => _open('long'))),
                const SizedBox(width: 12),
                Expanded(child: _tradeButton(l10n.openShortBtn, AppTheme.bear, Colors.white, () => _open('short'))),
              ],
            )
          else
            _tradeButton(l10n.buyBtn, AppTheme.bull, AppTheme.onPastel, () => _open('long')),
        ],
        const SizedBox(height: 22),
        Text(l10n.tradeHistoryTitle, style: AppTheme.display(18)),
        const SizedBox(height: 8),
        if (_history.isEmpty)
          Text(l10n.tradeHistoryEmpty,
              style: const TextStyle(color: AppTheme.muted, fontSize: 13))
        else
          for (final e in _history) _HistoryRow(entry: e, title: _reasonText(e.closeReason ?? '')),
        SizedBox(height: math.max(24, MediaQuery.paddingOf(context).bottom + 12)),
      ],
    );
  }

  Widget _tradeButton(String label, Color bg, Color fg, VoidCallback onTap) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: _plan == null ? bg.withValues(alpha: 0.35) : bg,
            foregroundColor: fg,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ),
      );
}

class _HistoryRow extends StatelessWidget {
  final JournalEntry entry;
  final String title;
  const _HistoryRow({required this.entry, required this.title});

  @override
  Widget build(BuildContext context) {
    final result = entry.result ?? '';
    final reason = entry.closeReason;
    // Breakeven: same neutral/ok colour as the result banner (pnl around 0), not pure green.
    final Color c;
    if (reason == 'breakeven') {
      c = AppTheme.gold;
    } else if (result.trim().startsWith('-') || reason == 'stop' || reason == 'liquidation') {
      c = AppTheme.bear;
    } else {
      c = AppTheme.bull;
    }
    final details = entry.notes.contains('·') ? entry.notes.split('·').first.trim() : entry.notes;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: AppTheme.cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(details, style: const TextStyle(color: AppTheme.muted, fontSize: 12.5)),
              ],
            ),
          ),
          Text(result, style: TextStyle(color: c, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _ResultBanner extends StatelessWidget {
  final String code;
  final String title;
  final double pnl;
  const _ResultBanner({required this.code, required this.title, required this.pnl});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final comment = switch (code) {
      'target' => l10n.resultCommentTarget,
      'stop' => l10n.resultCommentStop,
      'breakeven' => pnl < 0 ? l10n.resultCommentBreakevenFee : l10n.resultCommentBreakevenFlat,
      'liquidation' => l10n.resultCommentLiq,
      _ => l10n.resultCommentManual,
    };
    final good = pnl >= 0 && code != 'manual';
    final c = code == 'liquidation' ? AppTheme.bear : (pnl >= 0 ? AppTheme.bull : AppTheme.bear);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration(color: c.withValues(alpha: 0.12)),
      child: Row(
        children: [
          Icon(good ? Icons.check_circle_rounded : Icons.info_rounded, color: c),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$title: ${fmtSigned(pnl)} USDT. $comment ${l10n.resultInHistoryBelow}',
              style: TextStyle(color: c, fontWeight: FontWeight.w700, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionCard extends StatelessWidget {
  final String side;
  final bool futures;
  final double coins;
  final double entry;
  final double? stop;
  final double? target;
  final double pnl;
  final VoidCallback onClose;
  final VoidCallback? onBreakeven;
  final bool canBreakeven;

  const _PositionCard({
    required this.side,
    required this.futures,
    required this.coins,
    required this.entry,
    required this.stop,
    required this.target,
    required this.pnl,
    required this.onClose,
    this.onBreakeven,
    this.canBreakeven = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final long = side == 'long';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(color: AppTheme.surface2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              !futures
                  ? l10n.positionOpenBuy
                  : (long ? l10n.positionOpenLong : l10n.positionOpenShort),
              style: AppTheme.display(18)),
          const SizedBox(height: 8),
          Text(
              futures
                  ? l10n.contractOnSol(fmtNum(coins), fmtPrice(entry))
                  : l10n.spotPositionLine(fmtNum(coins), fmtPrice(entry)),
              style: const TextStyle(color: AppTheme.textSoft, fontWeight: FontWeight.w700)),
          if (stop != null)
            Text(
                (stop! - entry).abs() < 0.005
                    ? l10n.stopAtEntryLine(fmtPrice(stop!))
                    : l10n.stopWillCloseLoss(fmtPrice(stop!)),
                style: const TextStyle(color: AppTheme.bear, fontSize: 13, height: 1.5)),
          if (target != null)
            Text(l10n.takeWillCloseProfit(fmtPrice(target!)),
                style: const TextStyle(color: AppTheme.progress, fontSize: 13, height: 1.5)),
          const SizedBox(height: 8),
          Text(l10n.pnlNowLine(fmtSigned(pnl)),
              style: TextStyle(fontWeight: FontWeight.w800, color: pnl >= 0 ? AppTheme.bull : AppTheme.bear)),
          const SizedBox(height: 6),
          Text(l10n.waitForStopTakeHint,
              style: const TextStyle(color: AppTheme.muted, fontSize: 12.5)),
          if (onBreakeven != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: canBreakeven ? onBreakeven : null,
                icon: const Icon(Icons.shield_outlined, size: 18),
                label: Text(l10n.moveStopToEntryBtn),
              ),
            ),
            Text(
              canBreakeven ? l10n.breakevenBtnReady : l10n.breakevenBtnLocked,
              style: const TextStyle(color: AppTheme.muted, fontSize: 12),
            ),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(onPressed: onClose, child: Text(l10n.closeTradeNowBtn)),
          ),
        ],
      ),
    );
  }
}

class _CoachCard extends StatelessWidget {
  final PracticeBrief brief;
  final bool open;
  final bool done;
  final VoidCallback onToggle;
  final VoidCallback? onBack;

  const _CoachCard({
    required this.brief,
    required this.open,
    required this.onToggle,
    this.done = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
      decoration: AppTheme.cardDecoration(
        color: AppTheme.bull.withValues(alpha: 0.09),
        border: Border.all(color: AppTheme.bull.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(done ? Icons.check_circle_rounded : Icons.school_rounded, color: AppTheme.bull, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(done ? l10n.taskDoneTitle(brief.ideaTitle) : brief.ideaTitle,
                    style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.bull, height: 1.3)),
              ),
              IconButton(
                icon: Icon(open ? Icons.expand_less : Icons.expand_more, color: AppTheme.bull),
                tooltip: open ? l10n.collapseTaskTooltip : l10n.showTaskTooltip,
                onPressed: onToggle,
              ),
            ],
          ),
          if (open) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(brief.idea, style: const TextStyle(color: AppTheme.text, height: 1.45, fontSize: 15)),
            ),
            const SizedBox(height: 12),
            Text(l10n.whatToDoLabel, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            for (var i = 0; i < brief.steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 6, right: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${i + 1}.', style: const TextStyle(color: AppTheme.progress, fontWeight: FontWeight.w900)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(brief.steps[i], style: const TextStyle(height: 1.4))),
                  ],
                ),
              ),
            for (final term in brief.terms)
              Padding(
                padding: const EdgeInsets.only(bottom: 4, right: 8),
                child: Text('${term.$1} — ${term.$2}', style: const TextStyle(color: AppTheme.muted, fontSize: 12.5, height: 1.4)),
              ),
            if (brief.howToFinish.isNotEmpty) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(brief.howToFinish,
                    style: const TextStyle(color: AppTheme.progress, fontWeight: FontWeight.w700, height: 1.4)),
              ),
            ],
            if (onBack != null) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: Text(l10n.returnToLessonBtn),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
