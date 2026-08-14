/// OHLC candle for demo trading simulator.
class DemoCandle {
  final double open;
  final double high;
  final double low;
  final double close;
  final DateTime time;

  const DemoCandle({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.time,
  });

  bool get isBullish => close >= open;

  DemoCandle copyWith({
    double? high,
    double? low,
    double? close,
  }) {
    return DemoCandle(
      open: open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      time: time,
    );
  }

  Map<String, dynamic> toJson() => {
        'o': open,
        'h': high,
        'l': low,
        'c': close,
        't': time.millisecondsSinceEpoch,
      };

  factory DemoCandle.fromJson(Map<String, dynamic> j) => DemoCandle(
        open: (j['o'] as num).toDouble(),
        high: (j['h'] as num).toDouble(),
        low: (j['l'] as num).toDouble(),
        close: (j['c'] as num).toDouble(),
        time: DateTime.fromMillisecondsSinceEpoch(j['t'] as int),
      );
}
