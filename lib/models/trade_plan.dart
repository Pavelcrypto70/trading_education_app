class TradePlan {
  final String direction;
  final double entry;
  final double stop;
  final double target;
  final double riskPercent;
  /// Spot level (lessons 14–37): how many USDT to spend.
  final double amountUsdt;
  /// Futures level (lessons 47+): 1–3, isolated margin only.
  final int leverage;

  const TradePlan({
    required this.direction,
    required this.entry,
    required this.stop,
    required this.target,
    required this.riskPercent,
    this.amountUsdt = 1000,
    this.leverage = 1,
  });

  double get riskReward {
    final risk = (entry - stop).abs();
    if (risk == 0) return 0;
    return (target - entry).abs() / risk;
  }

  /// Approximate isolated-margin liquidation price (the exchange shows the exact one).
  double? get liquidationPrice {
    if (leverage <= 1 || entry <= 0) return null;
    return direction == 'long' ? entry * (1 - 1 / leverage + 0.005) : entry * (1 + 1 / leverage - 0.005);
  }

  Map<String, dynamic> toJson() => {
        'direction': direction,
        'entry': entry,
        'stop': stop,
        'target': target,
        'riskPercent': riskPercent,
        'amountUsdt': amountUsdt,
        'leverage': leverage,
      };

  factory TradePlan.fromJson(Map<String, dynamic> json) => TradePlan(
        direction: json['direction'] as String? ?? 'long',
        entry: (json['entry'] as num).toDouble(),
        stop: (json['stop'] as num).toDouble(),
        target: (json['target'] as num).toDouble(),
        riskPercent: (json['riskPercent'] as num?)?.toDouble() ?? 1,
        amountUsdt: (json['amountUsdt'] as num?)?.toDouble() ?? 1000,
        leverage: (json['leverage'] as num?)?.toInt() ?? 1,
      );
}
