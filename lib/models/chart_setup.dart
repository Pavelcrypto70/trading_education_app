import 'package:flutter/material.dart';

import '../widgets/lesson_charts.dart';

enum ChartMarkerKind { entry, stop, target, note, buy, sell }

class ChartLevel {
  final double price;
  final String label;
  final Color color;
  final bool dashed;

  const ChartLevel({
    required this.price,
    required this.label,
    this.color = const Color(0xFFD4AF37),
    this.dashed = false,
  });
}

class ChartMarker {
  final int candleIndex;
  final String label;
  final ChartMarkerKind kind;

  const ChartMarker({
    required this.candleIndex,
    required this.label,
    this.kind = ChartMarkerKind.note,
  });
}

class ChartLine {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final String? label;
  final Color color;
  final bool dashed;

  const ChartLine({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    this.label,
    this.color = const Color(0xFFD4AF37),
    this.dashed = false,
  });
}

class ChartZone {
  final double top;
  final double bottom;
  final Color color;
  final String? label;

  const ChartZone({
    required this.top,
    required this.bottom,
    this.color = const Color(0x3326A69A),
    this.label,
  });
}

class ChartAnnotation {
  final String text;
  final double x;
  final double y;
  final Color color;

  const ChartAnnotation({
    required this.text,
    required this.x,
    required this.y,
    this.color = Colors.white70,
  });
}

class ChartSetup {
  final List<CandleData> candles;
  final List<ChartLevel> levels;
  final List<ChartLine> lines;
  final List<ChartMarker> markers;
  final List<ChartZone> zones;
  final List<ChartAnnotation> annotations;
  final bool showVolume;
  final List<double>? volumes;

  const ChartSetup({
    required this.candles,
    this.levels = const [],
    this.lines = const [],
    this.markers = const [],
    this.zones = const [],
    this.annotations = const [],
    this.showVolume = false,
    this.volumes,
  });
}
