/// Explicit chart from tools/course/build.py: real candles plus every level,
/// zone, marker, frame and line with its label. Nothing is generated at runtime,
/// so what the lesson text says is exactly what the chart shows.
class CourseChartSpec {
  final String style; // candles | line
  final String tf;
  final String pair;
  final List<List<double>> candles; // [o, h, l, c]
  final List<double>? volume;
  final List<CourseLevel> levels;
  final List<CourseZone> zones;
  final List<CourseMarker> markers;
  final List<CourseBox> boxes;
  final List<CourseLine> lines;
  final String look;
  final double? height;

  const CourseChartSpec({
    required this.style,
    required this.tf,
    required this.pair,
    required this.candles,
    this.volume,
    this.levels = const [],
    this.zones = const [],
    this.markers = const [],
    this.boxes = const [],
    this.lines = const [],
    this.look = '',
    this.height,
  });

  static double _d(Object? v) => (v as num?)?.toDouble() ?? 0;

  static List<T> _list<T>(Object? raw, T Function(Map<String, dynamic>) f) {
    if (raw is! List) return const [];
    return raw.map((e) => f(Map<String, dynamic>.from(e as Map))).toList();
  }

  factory CourseChartSpec.fromJson(Map<String, dynamic> j) {
    final rawCandles = j['candles'] as List? ?? const [];
    final rawVol = j['volume'];
    return CourseChartSpec(
      style: j['style'] as String? ?? 'candles',
      tf: j['tf'] as String? ?? '',
      pair: j['pair'] as String? ?? 'SOL/USDT',
      candles: rawCandles.map((c) => (c as List).map(_d).toList()).toList(),
      volume: rawVol is List ? rawVol.map(_d).toList() : null,
      levels: _list(j['levels'], CourseLevel.fromJson),
      zones: _list(j['zones'], CourseZone.fromJson),
      markers: _list(j['markers'], CourseMarker.fromJson),
      boxes: _list(j['boxes'], CourseBox.fromJson),
      lines: _list(j['lines'], CourseLine.fromJson),
      look: j['look'] as String? ?? '',
      height: (j['height'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'style': style,
        'tf': tf,
        'pair': pair,
        'candles': candles,
        if (volume != null) 'volume': volume,
        'levels': levels.map((e) => e.toJson()).toList(),
        'zones': zones.map((e) => e.toJson()).toList(),
        'markers': markers.map((e) => e.toJson()).toList(),
        'boxes': boxes.map((e) => e.toJson()).toList(),
        'lines': lines.map((e) => e.toJson()).toList(),
        'look': look,
        if (height != null) 'height': height,
      };
}

class CourseLevel {
  final double price;
  final String label;
  final String color;
  final bool dashed;
  /// Candle index the line starts from (plan lines start at the entry candle); null — whole width.
  final int? from;
  const CourseLevel(this.price, this.label, this.color, this.dashed, [this.from]);
  factory CourseLevel.fromJson(Map<String, dynamic> j) => CourseLevel(
      CourseChartSpec._d(j['price']),
      j['label'] as String? ?? '',
      j['color'] as String? ?? 'lavender',
      j['dashed'] == true,
      (j['from'] as num?)?.toInt());
  Map<String, dynamic> toJson() =>
      {'price': price, 'label': label, 'color': color, 'dashed': dashed, if (from != null) 'from': from};
}

class CourseZone {
  final double top;
  final double bottom;
  final String label;
  final String color;
  /// Candle index the band starts from (stop/take bands start at the entry candle); null — whole width.
  final int? from;
  const CourseZone(this.top, this.bottom, this.label, this.color, [this.from]);
  factory CourseZone.fromJson(Map<String, dynamic> j) => CourseZone(CourseChartSpec._d(j['top']),
      CourseChartSpec._d(j['bottom']), j['label'] as String? ?? '', j['color'] as String? ?? 'bull',
      (j['from'] as num?)?.toInt());
  Map<String, dynamic> toJson() =>
      {'top': top, 'bottom': bottom, 'label': label, 'color': color, if (from != null) 'from': from};
}

class CourseMarker {
  final int i;
  final double price;
  final String label;
  final String kind;
  const CourseMarker(this.i, this.price, this.label, this.kind);
  factory CourseMarker.fromJson(Map<String, dynamic> j) => CourseMarker((j['i'] as num?)?.toInt() ?? 0,
      CourseChartSpec._d(j['price']), j['label'] as String? ?? '', j['kind'] as String? ?? 'note');
  Map<String, dynamic> toJson() => {'i': i, 'price': price, 'label': label, 'kind': kind};
}

class CourseBox {
  final int i1;
  final int i2;
  final double top;
  final double bottom;
  final String label;
  final String color;
  const CourseBox(this.i1, this.i2, this.top, this.bottom, this.label, this.color);
  factory CourseBox.fromJson(Map<String, dynamic> j) => CourseBox(
        (j['i1'] as num?)?.toInt() ?? 0,
        (j['i2'] as num?)?.toInt() ?? 0,
        CourseChartSpec._d(j['top']),
        CourseChartSpec._d(j['bottom']),
        j['label'] as String? ?? '',
        j['color'] as String? ?? 'lavender',
      );
  Map<String, dynamic> toJson() =>
      {'i1': i1, 'i2': i2, 'top': top, 'bottom': bottom, 'label': label, 'color': color};
}

class CourseLine {
  final int i1;
  final double p1;
  final int i2;
  final double p2;
  final String label;
  final String color;
  final bool dashed;
  const CourseLine(this.i1, this.p1, this.i2, this.p2, this.label, this.color, this.dashed);
  factory CourseLine.fromJson(Map<String, dynamic> j) => CourseLine(
        (j['i1'] as num?)?.toInt() ?? 0,
        CourseChartSpec._d(j['p1']),
        (j['i2'] as num?)?.toInt() ?? 0,
        CourseChartSpec._d(j['p2']),
        j['label'] as String? ?? '',
        j['color'] as String? ?? 'lavender',
        j['dashed'] == true,
      );
  Map<String, dynamic> toJson() =>
      {'i1': i1, 'p1': p1, 'i2': i2, 'p2': p2, 'label': label, 'color': color, 'dashed': dashed};
}
