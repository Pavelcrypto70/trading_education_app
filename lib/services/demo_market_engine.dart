import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

import '../models/demo_candle.dart';

/// Volatile alt demo market (SOL/USDT). 1m candles, fast ticks, no manual refresh.
class DemoMarketEngine {
  DemoMarketEngine._();
  static final DemoMarketEngine instance = DemoMarketEngine._();

  static const symbol = 'SOL';
  static const pair = 'SOL/USDT';
  static const defaultPrice = 168.42;
  static const marketVersion = 3;

  static const _versionKey = 'demoMarketVersion';
  static const _candlesKey = 'demoMarketCandles';
  static const _priceKey = 'demoMarketPrice';
  static const maxCandles = 80;
  /// 1m timeframe — each candle closes after this many ticks (not a smaller TF).
  static const ticksPerCandle = 10;
  static const tickMs = 420;

  final _random = math.Random();
  final List<DemoCandle> candles = [];
  Timer? _timer;

  double _price = defaultPrice;
  int _tickInCandle = 0;
  double _drift = 0;
  int _burstTicks = 0;

  double get currentPrice => _price;

  bool get isRunning => _timer != null;

  void Function()? onUpdate;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedVersion = prefs.getInt(_versionKey) ?? 0;
    _price = prefs.getDouble(_priceKey) ?? defaultPrice;

    if (savedVersion < marketVersion || _price > 5000) {
      await reset();
      return;
    }

    final raw = prefs.getString(_candlesKey);
    candles.clear();
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      for (final item in list) {
        candles.add(DemoCandle.fromJson(Map<String, dynamic>.from(item as Map)));
      }
    }
    if (candles.isEmpty) {
      _seedHistory(_price);
    } else {
      _price = candles.last.close;
    }
    _openNewCandle();
  }

  void _seedHistory(double endPrice) {
    var p = endPrice * 0.965;
    final now = DateTime.now();
    for (var i = 59; i >= 0; i--) {
      final o = p;
      final bias = _random.nextDouble() < 0.5 ? 1.0 : -1.0;
      final move = bias * _random.nextDouble() * endPrice * 0.0075;
      p = (p + move).clamp(endPrice * 0.82, endPrice * 1.18);
      final wick = endPrice * (0.0025 + _random.nextDouble() * 0.0055);
      final h = math.max(o, p) + wick * _random.nextDouble();
      final l = math.min(o, p) - wick * _random.nextDouble();
      candles.add(DemoCandle(
        open: o,
        high: h,
        low: l,
        close: p,
        time: now.subtract(Duration(minutes: i)),
      ));
    }
    _price = candles.last.close;
  }

  void _openNewCandle() {
    candles.add(DemoCandle(
      open: _price,
      high: _price,
      low: _price,
      close: _price,
      time: DateTime.now(),
    ));
    if (candles.length > maxCandles) {
      candles.removeAt(0);
    }
    _tickInCandle = 0;
  }

  void start() {
    _timer ??= Timer.periodic(const Duration(milliseconds: tickMs), (_) => tick());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _persistTimer?.cancel();
    _persistTimer = null;
  }

  void tick() {
    if (_burstTicks <= 0 && _random.nextDouble() < 0.14) {
      _burstTicks = 4 + _random.nextInt(7);
    }

    _drift += (_random.nextDouble() - 0.5) * 0.55;
    _drift = _drift.clamp(-3.8, 3.8);

    final burstMul = _burstTicks > 0 ? 4.2 : 1.0;
    if (_burstTicks > 0) _burstTicks--;

    final volatility = _price * 0.0034 * burstMul;
    var change = (_nextGaussian() * volatility * 0.78) + (_drift * volatility * 0.38);

    if (_random.nextDouble() < 0.2) {
      change += (_random.nextDouble() - 0.5) * volatility * 5.2;
    }

    _price = (_price + change).clamp(_price * 0.985, _price * 1.015);

    if (candles.isEmpty) _openNewCandle();

    final last = candles.last;
    var high = math.max(last.high, _price);
    var low = math.min(last.low, _price);

    if (_random.nextDouble() < 0.38) {
      final wick = _price * (0.0028 + _random.nextDouble() * 0.0042);
      if (_random.nextBool()) {
        high += wick;
      } else {
        low -= wick;
      }
    }

    candles[candles.length - 1] = last.copyWith(
      close: _price,
      high: high,
      low: low,
    );

    _tickInCandle++;
    if (_tickInCandle >= ticksPerCandle) {
      _openNewCandle();
    }

    onUpdate?.call();
    _persistDebounced();
  }

  double _nextGaussian() {
    final u1 = _random.nextDouble();
    final u2 = _random.nextDouble();
    return math.sqrt(-2 * math.log(u1.clamp(1e-10, 1))) * math.cos(2 * math.pi * u2);
  }

  Timer? _persistTimer;
  void _persistDebounced() {
    _persistTimer?.cancel();
    _persistTimer = Timer(const Duration(seconds: 2), _persist);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_versionKey, marketVersion);
    await prefs.setDouble(_priceKey, _price);
    final slice = candles.length > maxCandles ? candles.sublist(candles.length - maxCandles) : candles;
    await prefs.setString(
      _candlesKey,
      jsonEncode(slice.map((c) => c.toJson()).toList()),
    );
  }

  Future<void> reset({double startPrice = defaultPrice}) async {
    _price = startPrice;
    _drift = 0;
    _burstTicks = 0;
    candles.clear();
    _seedHistory(startPrice);
    _openNewCandle();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_versionKey, marketVersion);
    await prefs.remove(_candlesKey);
    await prefs.setDouble(_priceKey, _price);
    onUpdate?.call();
  }
}
