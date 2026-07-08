class TradePlan {
  final String direction;
  final double entry;
  final double stop;
  final double target;
  final double riskPercent;

  const TradePlan({
    required this.direction,
    required this.entry,
    required this.stop,
    required this.target,
    required this.riskPercent,
  });

  double get riskReward {
    final risk = (entry - stop).abs();
    if (risk == 0) return 0;
    return (target - entry).abs() / risk;
  }

  Map<String, dynamic> toJson() => {
        'direction': direction,
        'entry': entry,
        'stop': stop,
        'target': target,
        'riskPercent': riskPercent,
      };

  factory TradePlan.fromJson(Map<String, dynamic> json) => TradePlan(
        direction: json['direction'] as String? ?? 'long',
        entry: (json['entry'] as num).toDouble(),
        stop: (json['stop'] as num).toDouble(),
        target: (json['target'] as num).toDouble(),
        riskPercent: (json['riskPercent'] as num?)?.toDouble() ?? 1,
      );
}
