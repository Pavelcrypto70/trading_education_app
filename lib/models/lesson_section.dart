import 'course_chart_spec.dart';

class LessonSection {
  final String type;
  final String? title;
  final String? body;
  final String? chartType;
  final String? caption;
  final List<String>? items;
  final String? url;
  final String? symbol;
  final String? interval;
  final String? market;
  /// For type == choice: index of the correct option in [items].
  final int? correctIndex;
  /// Unique chart variant within the lesson (0, 1, 2…).
  final int? cardIndex;

  /// Explicit, fully labelled chart authored in tools/course (rebuilt course).
  final CourseChartSpec? chart;
  /// For type == choice: one explanation per option.
  final List<String>? explain;
  /// For type == practice: how the simulator task ends.
  final String? finish;
  /// For type == practice: 'long' or 'short'.
  final String? direction;
  /// For type == practice: minimal reward/risk the plan must have.
  final double? minRiskReward;

  const LessonSection({
    required this.type,
    this.title,
    this.body,
    this.chartType,
    this.caption,
    this.items,
    this.url,
    this.symbol,
    this.interval,
    this.market,
    this.correctIndex,
    this.cardIndex,
    this.chart,
    this.explain,
    this.finish,
    this.direction,
    this.minRiskReward,
  });

  factory LessonSection.fromJson(Map<String, dynamic> json) {
    List<String>? strings(Object? raw) {
      if (raw is List && raw.isNotEmpty && raw.first is String) return raw.cast<String>();
      return null;
    }

    final chartJson = json['chart'];
    return LessonSection(
      type: json['type'] ?? 'text',
      title: json['title'],
      body: json['body'],
      chartType: json['chartType'],
      caption: json['caption'],
      items: strings(json['items']),
      url: json['url'],
      symbol: json['symbol'],
      interval: json['interval'],
      market: json['market'],
      correctIndex: json['correctIndex'] as int?,
      cardIndex: json['cardIndex'] as int?,
      chart: chartJson is Map ? CourseChartSpec.fromJson(Map<String, dynamic>.from(chartJson)) : null,
      explain: strings(json['explain']),
      finish: json['finish'] as String?,
      direction: json['direction'] as String?,
      minRiskReward: (json['minRiskReward'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (chartType != null) 'chartType': chartType,
      if (caption != null) 'caption': caption,
      if (items != null) 'items': items,
      if (url != null) 'url': url,
      if (symbol != null) 'symbol': symbol,
      if (interval != null) 'interval': interval,
      if (market != null) 'market': market,
      if (correctIndex != null) 'correctIndex': correctIndex,
      if (cardIndex != null) 'cardIndex': cardIndex,
      if (chart != null) 'chart': chart!.toJson(),
      if (explain != null) 'explain': explain,
      if (finish != null) 'finish': finish,
      if (direction != null) 'direction': direction,
      if (minRiskReward != null) 'minRiskReward': minRiskReward,
    };
  }
}
