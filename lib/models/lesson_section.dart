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
  });

  factory LessonSection.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List?;
    List<String>? items;
    if (rawItems != null && rawItems.isNotEmpty && rawItems.first is String) {
      items = rawItems.cast<String>();
    }
    return LessonSection(
      type: json['type'] ?? 'text',
      title: json['title'],
      body: json['body'],
      chartType: json['chartType'],
      caption: json['caption'],
      items: items,
      url: json['url'],
      symbol: json['symbol'],
      interval: json['interval'],
      market: json['market'],
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
    };
  }
}
