import 'package:flutter/material.dart';

import '../models/chart_setup.dart';
import '../widgets/lesson_charts.dart';
import 'chart_sequence_builder.dart';

/// Учебные сетапы для каждого урока: уровни, вход/стоп/цель, паттерны.
class LessonChartSetups {
  LessonChartSetups._();

  static const _bull = Color(0xFF26A69A);
  static const _bear = Color(0xFFEF5350);
  static const _gold = Color(0xFFD4AF37);
  static const _purple = Color(0xFF6C5CE7);

  static ChartSetup forLesson(int lessonId, String chartType) {
    return _byLesson[lessonId] ?? _fallback(chartType);
  }

  static ChartSetup forChartType(String chartType) => _fallback(chartType);

  static CandleData c(double o, double h, double l, double cl) =>
      CandleData(open: o, high: h, low: l, close: cl);

  static List<ChartMarker> _shiftMarkers(List<ChartMarker> markers, int offset) =>
      markers
          .map(
            (m) => ChartMarker(
              candleIndex: m.candleIndex + offset,
              label: m.label,
              kind: m.kind,
            ),
          )
          .toList();

  /// Ядро сетапа + контекст до/после (минимум ~18–24 свечи на графике).
  static ChartSetup _rich(
    List<CandleData> core, {
    List<CandleData>? before,
    List<CandleData>? after,
    List<ChartLevel> levels = const [],
    List<ChartLine> lines = const [],
    List<ChartMarker> markers = const [],
    List<ChartZone> zones = const [],
    List<ChartAnnotation> annotations = const [],
    bool showVolume = false,
    List<double>? volumes,
    int? volumeSpikeIndex,
  }) {
    final prelude = before ?? ChartSequenceBuilder.trendDown(12, start: core.first.open + 12, end: core.first.open + 0.6);
    final epilogue = after ?? ChartSequenceBuilder.trendUp(6, start: core.last.close, end: core.last.close + 4);
    final candles = ChartSequenceBuilder.merge([prelude, core, epilogue]);
    final off = prelude.length;
    final vol = showVolume
        ? ((volumes != null && volumes.length == candles.length)
            ? volumes
            : ChartSequenceBuilder.volumes(
                candles.length,
                spikeIndex: volumeSpikeIndex != null ? volumeSpikeIndex + off : null,
              ))
        : volumes;
    return _eset(
      candles,
      levels: levels,
      lines: lines,
      markers: _shiftMarkers(markers, off),
      zones: zones,
      annotations: annotations,
      showVolume: showVolume,
      volumes: vol,
    );
  }

  static ChartSetup _eset(
    List<CandleData> candles, {
    List<ChartLevel> levels = const [],
    List<ChartLine> lines = const [],
    List<ChartMarker> markers = const [],
    List<ChartZone> zones = const [],
    List<ChartAnnotation> annotations = const [],
    bool showVolume = false,
    List<double>? volumes,
  }) =>
      ChartSetup(
        candles: candles,
        levels: levels,
        lines: lines,
        markers: markers,
        zones: zones,
        annotations: annotations,
        showVolume: showVolume,
        volumes: volumes,
      );

  static final Map<int, ChartSetup> _byLesson = {
    1: _lesson01SpotFutures(),
    2: _lesson02Orders(),
    3: _lesson03Amplitude(),
    4: _lesson04SupportLows(),
    5: _lesson05OrderBook(),
    6: _lesson06FastSlow(),
    7: _lesson07Mistakes(),
    8: _lesson08DescTriangle(),
    9: _lesson09AscTriangle(),
    10: _lesson10Impulse(),
    11: _lesson11Delisting(),
    12: _lesson12Listing(),
    13: _lesson13Channel(),
    14: _lesson14Uptrend(),
    15: _lesson15Downtrend(),
    16: _lesson16Indicators(),
    17: _lesson17News(),
    18: _lesson18Risk(),
    19: _lesson19SymTriangle(),
    20: _lesson20Meme(),
    21: _lesson21HoldTarget(),
    22: _lesson22Ticks(),
    23: _lesson23Plan(),
    24: _lesson24Cycles(),
    25: _lesson25Altseason(),
    26: _lesson26Sessions(),
    27: _lesson27BtcDump(),
    28: _lesson28Recovery(),
    29: _lesson29Marathon1(),
    30: _lesson30Marathon2(),
    31: _lesson31Averaging(),
    32: _lesson32TrendChange(),
    33: _lesson33Journal(),
    34: _lesson34Fomc(),
    35: _lesson35Scam(),
    36: _lesson36Transfer(),
    37: _lesson37Api(),
    38: _lesson38Routine(),
    39: _lesson39Futures(),
    40: _lesson40Mistakes2(),
    41: _lesson41Apps(),
    42: _lesson42Morning(),
    43: _lesson43Fib(),
    44: _lesson44Airdrop(),
    45: _lesson45Candles(),
    46: _lesson46HeadShoulders1(),
    47: _lesson47HeadShoulders2(),
  };

  // ─── L1: Спот vs фьючерс — лонг от поддержки + зона ликвидации ───────────
  static ChartSetup _lesson01SpotFutures() {
    final candles = [
      c(78, 80, 72, 74),
      c(74, 76, 68, 70),
      c(70, 72, 64, 66),
      c(66, 68, 62, 65),
      c(65, 67, 61, 64),
      c(64, 70, 63, 69),
      c(69, 74, 68, 73),
      c(73, 78, 72, 77),
    ];
    return _rich(
      candles,
      before: ChartSequenceBuilder.merge([
        ChartSequenceBuilder.trendUp(8, start: 68, end: 88, noise: 0.55),
        ChartSequenceBuilder.trendDown(8, start: 88, end: 79, noise: 0.5),
      ]),
      after: ChartSequenceBuilder.trendUp(6, start: 77, end: 81, noise: 0.35),
      levels: [
        const ChartLevel(price: 62, label: 'Поддержка (3 лоя)', color: _purple),
        const ChartLevel(price: 78, label: 'Цель / сопротивление', color: _bull),
        const ChartLevel(price: 60, label: 'Стоп (ниже лоя)', color: _bear),
      ],
      zones: [
        ChartZone(top: 62, bottom: 55, color: _bear.withValues(alpha: 0.15), label: 'Ликвидация 10x'),
      ],
      markers: [
        const ChartMarker(candleIndex: 4, label: 'Вход лонг', kind: ChartMarkerKind.entry),
        const ChartMarker(candleIndex: 4, label: 'Стоп', kind: ChartMarkerKind.stop),
        const ChartMarker(candleIndex: 7, label: 'Тейк', kind: ChartMarkerKind.target),
      ],
      annotations: [
        const ChartAnnotation(text: 'Спот: монета остаётся', x: 0.04, y: 0.12, color: _bull),
        const ChartAnnotation(text: 'Фьючерс: стоп до ликвидации', x: 0.42, y: 0.88, color: _bear),
      ],
    );
  }

  // ─── L2: Лимитный вход + R:R ─────────────────────────────────────────────
  static ChartSetup _lesson02Orders() {
    final candles = [
      c(55, 58, 54, 57),
      c(57, 60, 56, 59),
      c(59, 62, 58, 60),
      c(60, 61, 57, 58),
      c(58, 59, 55, 56),
      c(56, 62, 55, 61),
      c(61, 66, 60, 65),
    ];
    return _rich(
      candles,
      before: ChartSequenceBuilder.sideways(8, center: 58, amplitude: 2.2),
      levels: [
        const ChartLevel(price: 55, label: 'Лимит buy', color: _bull, dashed: true),
        const ChartLevel(price: 54, label: 'Стоп −1%', color: _bear),
        const ChartLevel(price: 66, label: 'Тейк +2%', color: _bull),
      ],
      markers: [
        const ChartMarker(candleIndex: 5, label: 'Maker fill', kind: ChartMarkerKind.entry),
      ],
      annotations: [
        const ChartAnnotation(text: 'Риск 1% депозита', x: 0.05, y: 0.08),
        const ChartAnnotation(text: 'R:R ≈ 1:2', x: 0.68, y: 0.15, color: _gold),
      ],
    );
  }

  // ─── L3: Амплитуда / ATR ─────────────────────────────────────────────────
  static ChartSetup _lesson03Amplitude() {
    final candles = [
      c(50, 52, 49, 51),
      c(51, 54, 50, 53),
      c(53, 58, 52, 57),
      c(57, 64, 56, 62),
      c(62, 68, 60, 66),
      c(66, 70, 63, 65),
    ];
    return _rich(
      candles,
      lines: [
        const ChartLine(x1: 0.55, y1: 0.35, x2: 0.55, y2: 0.78, label: 'ATR ≈ 5%', color: _gold),
      ],
      annotations: [
        const ChartAnnotation(text: 'Стоп < ATR = шум', x: 0.05, y: 0.82, color: _bear),
        const ChartAnnotation(text: 'Тейк ~ 2×ATR', x: 0.55, y: 0.08, color: _bull),
        const ChartAnnotation(text: 'BTC: 3–5% = много', x: 0.05, y: 0.12),
      ],
      markers: [
        const ChartMarker(candleIndex: 2, label: 'Импульс', kind: ChartMarkerKind.note),
      ],
    );
  }

  // ─── L4: Поддержка по лоям + ложный пробой ───────────────────────────────
  static ChartSetup _lesson04SupportLows() {
    final candles = [
      c(72, 74, 68, 70),
      c(70, 72, 64, 66),
      c(66, 70, 62, 68),
      c(68, 75, 67, 73),
      c(73, 74, 68, 70),
      c(70, 71, 58, 60),
      c(60, 66, 59, 65),
      c(65, 72, 64, 71),
    ];
    return _rich(
      candles,
      levels: [const ChartLevel(price: 62, label: 'Поддержка (3 лоя)', color: _purple)],
      markers: [
        const ChartMarker(candleIndex: 5, label: 'Ложный пробой', kind: ChartMarkerKind.note),
        const ChartMarker(candleIndex: 6, label: 'Лонг', kind: ChartMarkerKind.entry),
        const ChartMarker(candleIndex: 5, label: 'Стоп', kind: ChartMarkerKind.stop),
      ],
      annotations: [
        const ChartAnnotation(text: 'Фитиль ниже — покупатели', x: 0.52, y: 0.82, color: _bull),
      ],
    );
  }

  // ─── L5: Стакан — стена ask + спуфинг ───────────────────────────────────
  static ChartSetup _lesson05OrderBook() {
    return _rich(
      [c(70, 72, 69, 71), c(71, 73, 70, 72), c(72, 74, 71, 71), c(71, 72, 68, 69), c(69, 71, 68, 70)],
      annotations: [
        const ChartAnnotation(text: 'Стена ask 50 BTC', x: 0.55, y: 0.18, color: _bear),
        const ChartAnnotation(text: 'Сняли перед касанием', x: 0.52, y: 0.35, color: _gold),
        const ChartAnnotation(text: 'Не шортить вслепую', x: 0.05, y: 0.08, color: _bear),
      ],
      lines: [
        const ChartLine(x1: 0.7, y1: 0.22, x2: 0.7, y2: 0.45, label: 'Спуфинг', color: _bear, dashed: true),
      ],
    );
  }

  // ─── L6: Быстрый vs медленный рынок ─────────────────────────────────────
  static ChartSetup _lesson06FastSlow() {
    return _rich(
      [
        c(50, 51, 49, 50),
        c(50, 51, 49, 50.5),
        c(50.5, 58, 50, 57),
        c(57, 65, 55, 63),
        c(63, 72, 61, 70),
        c(70, 71, 62, 64),
      ],
      annotations: [
        const ChartAnnotation(text: 'Медленно (флэт)', x: 0.08, y: 0.55),
        const ChartAnnotation(text: 'Быстро: широкие свечи', x: 0.42, y: 0.12, color: _bull),
        const ChartAnnotation(text: 'Стоп шире', x: 0.72, y: 0.45, color: _gold),
      ],
      zones: [
        ChartZone(top: 52, bottom: 49, color: _purple.withValues(alpha: 0.12), label: 'Range'),
      ],
    );
  }

  // ─── L7: Ошибки — без стопа ──────────────────────────────────────────────
  static ChartSetup _lesson07Mistakes() {
    return _rich(
      [c(60, 65, 58, 64), c(64, 68, 62, 66), c(66, 67, 52, 54), c(54, 56, 45, 47), c(47, 49, 38, 40)],
      levels: [const ChartLevel(price: 58, label: 'Стоп должен был быть', color: _bear, dashed: true)],
      markers: [const ChartMarker(candleIndex: 1, label: 'FOMO вход', kind: ChartMarkerKind.entry)],
      annotations: [
        const ChartAnnotation(text: 'Без стопа −30%', x: 0.45, y: 0.78, color: _bear),
      ],
    );
  }

  // ─── L8: Нисходящий треугольник ─────────────────────────────────────────
  static ChartSetup _lesson08DescTriangle() {
    return _rich(
      [
        c(82, 84, 78, 80),
        c(80, 82, 74, 76),
        c(76, 78, 70, 72),
        c(72, 74, 66, 68),
        c(68, 70, 62, 64),
        c(64, 65, 58, 59),
        c(59, 60, 52, 53),
        c(53, 54, 48, 49),
      ],
      levels: [const ChartLevel(price: 62, label: 'Поддержка', color: _purple)],
      lines: [
        const ChartLine(x1: 0.08, y1: 0.18, x2: 0.92, y2: 0.42, label: 'Lower highs'),
        const ChartLine(x1: 0.08, y1: 0.62, x2: 0.55, y2: 0.62, color: _purple),
      ],
      markers: [
        const ChartMarker(candleIndex: 7, label: 'Шорт', kind: ChartMarkerKind.sell),
        const ChartMarker(candleIndex: 6, label: 'Стоп', kind: ChartMarkerKind.stop),
      ],
    );
  }

  // ─── L9: Восходящий треугольник ─────────────────────────────────────────
  static ChartSetup _lesson09AscTriangle() {
    return _rich(
      [
        c(48, 52, 46, 50),
        c(50, 54, 48, 53),
        c(53, 56, 51, 55),
        c(55, 58, 52, 57),
        c(57, 60, 56, 59),
        c(59, 62, 58, 61),
        c(61, 64, 60, 63),
        c(63, 72, 62, 71),
        c(71, 76, 70, 75),
      ],
      levels: [const ChartLevel(price: 64, label: 'Сопротивление', color: _bear)],
      lines: [
        const ChartLine(x1: 0.08, y1: 0.78, x2: 0.55, y2: 0.48, label: 'Higher lows'),
        const ChartLine(x1: 0.08, y1: 0.38, x2: 0.55, y2: 0.38, color: _bear),
      ],
      markers: [
        const ChartMarker(candleIndex: 7, label: 'Пробой → лонг', kind: ChartMarkerKind.entry),
      ],
    );
  }

  // ─── L10: Импульс из range ────────────────────────────────────────────────
  static ChartSetup _lesson10Impulse() {
    return _rich(
      [c(58, 60, 56, 59), c(59, 61, 57, 58), c(58, 60, 56, 59), c(59, 61, 57, 58), c(58, 68, 57, 67), c(67, 74, 65, 72)],
      zones: [ChartZone(top: 61, bottom: 56, color: _purple.withValues(alpha: 0.15), label: 'Накопление')],
      markers: [
        const ChartMarker(candleIndex: 4, label: 'Пробой + объём', kind: ChartMarkerKind.entry),
        const ChartMarker(candleIndex: 3, label: 'Стоп', kind: ChartMarkerKind.stop),
      ],
      showVolume: true,
      volumeSpikeIndex: 4,
    );
  }

  static ChartSetup _lesson11Delisting() => _rich(
        [c(80, 82, 78, 79), c(79, 80, 70, 72), c(72, 73, 55, 58), c(58, 60, 40, 42), c(42, 44, 25, 28)],
        annotations: [
          const ChartAnnotation(text: 'Новость делистинга', x: 0.35, y: 0.15, color: _bear),
          const ChartAnnotation(text: 'Выходить заранее', x: 0.05, y: 0.08, color: _gold),
        ],
      );

  static ChartSetup _lesson12Listing() => _rich(
        [c(10, 15, 8, 12), c(12, 35, 11, 32), c(32, 45, 28, 38), c(38, 42, 25, 28), c(28, 30, 18, 20)],
        markers: [const ChartMarker(candleIndex: 1, label: 'Листинг', kind: ChartMarkerKind.note)],
        annotations: [
          const ChartAnnotation(text: 'Малый размер!', x: 0.55, y: 0.12, color: _bear),
          const ChartAnnotation(text: 'Стоп обязателен', x: 0.05, y: 0.08),
        ],
      );

  static ChartSetup _lesson13Channel() => _rich(
        [c(62, 68, 60, 66), c(66, 70, 63, 64), c(64, 68, 58, 66), c(66, 70, 63, 65), c(65, 68, 58, 60), c(60, 66, 58, 65)],
        lines: [
          const ChartLine(x1: 0.05, y1: 0.28, x2: 0.95, y2: 0.22, label: 'Сопротивление'),
          const ChartLine(x1: 0.05, y1: 0.72, x2: 0.95, y2: 0.68, label: 'Поддержка'),
        ],
        markers: [
          const ChartMarker(candleIndex: 4, label: 'Buy', kind: ChartMarkerKind.buy),
          const ChartMarker(candleIndex: 1, label: 'Sell', kind: ChartMarkerKind.sell),
        ],
      );

  static ChartSetup _lesson14Uptrend() => _rich(
        [c(40, 45, 38, 44), c(44, 50, 42, 48), c(48, 52, 45, 47), c(47, 55, 46, 54), c(54, 60, 52, 58), c(58, 65, 56, 63)],
        lines: [const ChartLine(x1: 0.05, y1: 0.85, x2: 0.95, y2: 0.15, label: 'Тренд ↑', color: _bull)],
        annotations: [
          const ChartAnnotation(text: 'HH', x: 0.72, y: 0.12, color: _bull),
          const ChartAnnotation(text: 'HL', x: 0.42, y: 0.48, color: _bull),
          const ChartAnnotation(text: 'Лонг от отката', x: 0.05, y: 0.08),
        ],
        markers: [const ChartMarker(candleIndex: 2, label: 'Вход', kind: ChartMarkerKind.entry)],
      );

  static ChartSetup _lesson15Downtrend() => _rich(
        [c(75, 78, 70, 72), c(72, 74, 65, 67), c(67, 70, 60, 62), c(62, 65, 55, 57), c(57, 59, 48, 50), c(50, 52, 42, 44)],
        lines: [const ChartLine(x1: 0.05, y1: 0.15, x2: 0.95, y2: 0.85, label: 'Тренд ↓', color: _bear)],
        annotations: [
          const ChartAnnotation(text: 'LH', x: 0.55, y: 0.35, color: _bear),
          const ChartAnnotation(text: 'LL', x: 0.85, y: 0.78, color: _bear),
        ],
        markers: [const ChartMarker(candleIndex: 2, label: 'Шорт', kind: ChartMarkerKind.sell)],
      );

  static ChartSetup _lesson16Indicators() => _rich(
        [c(50, 54, 49, 53), c(53, 58, 52, 57), c(57, 62, 56, 60), c(60, 65, 59, 63), c(63, 68, 62, 66)],
        lines: [const ChartLine(x1: 0.05, y1: 0.82, x2: 0.95, y2: 0.28, label: 'MA20', color: _gold, dashed: true)],
        annotations: [
          const ChartAnnotation(text: 'Цена > MA = тренд', x: 0.05, y: 0.08),
          const ChartAnnotation(text: 'Объём ↑ на пробое', x: 0.55, y: 0.12),
        ],
        showVolume: true,
        volumeSpikeIndex: 4,
      );

  static ChartSetup _lesson17News() => _rich(
        [c(60, 62, 58, 61), c(61, 63, 59, 62), c(62, 78, 60, 75), c(75, 76, 62, 64), c(64, 66, 58, 60)],
        annotations: [
          const ChartAnnotation(text: 'CPI / FOMC', x: 0.38, y: 0.08, color: _bear),
          const ChartAnnotation(text: 'Не входить за 30 мин', x: 0.05, y: 0.12),
          const ChartAnnotation(text: 'Ждать структуру', x: 0.62, y: 0.45),
        ],
        markers: [const ChartMarker(candleIndex: 2, label: 'Спайк', kind: ChartMarkerKind.note)],
      );

  static ChartSetup _lesson18Risk() => _rich(
        [c(55, 58, 54, 57), c(57, 62, 56, 60), c(60, 64, 58, 62)],
        levels: [
          const ChartLevel(price: 56, label: 'Стоп', color: _bear),
          const ChartLevel(price: 68, label: 'Тейк', color: _bull),
          const ChartLevel(price: 60, label: 'Вход', color: _gold),
        ],
        zones: [
          ChartZone(top: 60, bottom: 56, color: _bear.withValues(alpha: 0.12), label: '1% риск'),
          ChartZone(top: 68, bottom: 60, color: _bull.withValues(alpha: 0.12), label: '2R'),
        ],
        annotations: [const ChartAnnotation(text: 'Риск 0.5–1% депозита', x: 0.05, y: 0.08)],
      );

  static ChartSetup _lesson19SymTriangle() => _rich(
        [c(70, 75, 65, 72), c(72, 74, 62, 65), c(65, 68, 58, 66), c(66, 68, 55, 58), c(58, 62, 54, 60), c(60, 72, 58, 70)],
        lines: [
          const ChartLine(x1: 0.08, y1: 0.2, x2: 0.55, y2: 0.55),
          const ChartLine(x1: 0.08, y1: 0.75, x2: 0.55, y2: 0.35),
        ],
        markers: [const ChartMarker(candleIndex: 5, label: 'Пробой', kind: ChartMarkerKind.entry)],
      );

  static ChartSetup _lesson20Meme() => _rich(
        [c(20, 22, 18, 21), c(21, 45, 20, 42), c(42, 50, 35, 38), c(38, 40, 22, 25)],
        annotations: [
          const ChartAnnotation(text: 'FUN: памп', x: 0.32, y: 0.1, color: _bull),
          const ChartAnnotation(text: 'Дамп быстрый', x: 0.62, y: 0.55, color: _bear),
          const ChartAnnotation(text: 'Микро-размер', x: 0.05, y: 0.08),
        ],
      );

  static ChartSetup _lesson21HoldTarget() => _rich(
        [c(55, 58, 54, 57), c(57, 62, 56, 60), c(60, 64, 58, 62), c(62, 66, 59, 65), c(65, 68, 62, 66)],
        levels: [
          const ChartLevel(price: 68, label: 'Тейк (план)', color: _bull, dashed: true),
          const ChartLevel(price: 54, label: 'Стоп', color: _bear),
        ],
        markers: [const ChartMarker(candleIndex: 1, label: 'Вход', kind: ChartMarkerKind.entry)],
        annotations: [const ChartAnnotation(text: 'Не двигать стоп из жадности', x: 0.05, y: 0.08)],
      );

  static ChartSetup _lesson22Ticks() => _rich(
        [c(68, 69, 67, 68), c(68, 72, 67, 71), c(71, 72, 68, 69), c(69, 70, 66, 67)],
        annotations: [
          const ChartAnnotation(text: '↑ Агрессивные покупки', x: 0.28, y: 0.18, color: _bull),
          const ChartAnnotation(text: 'Лента ускорилась', x: 0.05, y: 0.08),
        ],
        markers: [const ChartMarker(candleIndex: 1, label: 'Market buy', kind: ChartMarkerKind.note)],
      );

  static ChartSetup _lesson23Plan() => _rich(
        [c(58, 60, 55, 56), c(56, 58, 52, 57), c(57, 64, 56, 62), c(62, 68, 60, 66)],
        levels: [
          const ChartLevel(price: 52, label: 'Стоп', color: _bear),
          const ChartLevel(price: 68, label: 'Тейк 2R', color: _bull),
          const ChartLevel(price: 57, label: 'Вход', color: _gold),
        ],
        annotations: [const ChartAnnotation(text: 'План ДО клика', x: 0.05, y: 0.08, color: _gold)],
        markers: [const ChartMarker(candleIndex: 1, label: 'Вход', kind: ChartMarkerKind.entry)],
      );

  static ChartSetup _lesson24Cycles() => _rich(
        [c(30, 35, 28, 34), c(34, 50, 32, 48), c(48, 55, 45, 52), c(52, 54, 38, 40), c(40, 42, 25, 28)],
        annotations: [
          const ChartAnnotation(text: 'Накопление', x: 0.05, y: 0.75),
          const ChartAnnotation(text: 'Рост', x: 0.28, y: 0.2, color: _bull),
          const ChartAnnotation(text: 'Распределение', x: 0.55, y: 0.35),
          const ChartAnnotation(text: 'Падение', x: 0.82, y: 0.78, color: _bear),
        ],
      );

  static ChartSetup _lesson25Altseason() => _rich(
        [c(70, 72, 68, 69), c(69, 71, 67, 68), c(68, 70, 66, 67)],
        lines: [
          const ChartLine(x1: 0.05, y1: 0.25, x2: 0.95, y2: 0.22, label: 'BTC', color: _gold),
          const ChartLine(x1: 0.05, y1: 0.75, x2: 0.95, y2: 0.35, label: 'Альты', color: _bull),
        ],
        annotations: [const ChartAnnotation(text: 'BTC.D ↓ = альтсезон', x: 0.05, y: 0.08)],
      );

  static ChartSetup _lesson26Sessions() => _rich(
        [c(55, 56, 54, 55), c(55, 58, 54, 57), c(57, 65, 56, 63), c(63, 68, 61, 66)],
        annotations: [
          const ChartAnnotation(text: 'Азия: флэт', x: 0.12, y: 0.55),
          const ChartAnnotation(text: 'Лондон: пробой', x: 0.42, y: 0.2, color: _bull),
          const ChartAnnotation(text: 'NY: волатильность', x: 0.72, y: 0.12),
        ],
      );

  static ChartSetup _lesson27BtcDump() => _rich(
        [c(75, 76, 70, 71), c(71, 72, 62, 64), c(64, 65, 55, 57)],
        lines: [
          const ChartLine(x1: 0.05, y1: 0.2, x2: 0.95, y2: 0.65, label: 'BTC ↓', color: _bear),
          const ChartLine(x1: 0.05, y1: 0.35, x2: 0.95, y2: 0.88, label: 'Альт ↓↓', color: _bear),
        ],
        annotations: [const ChartAnnotation(text: 'Альты падают сильнее', x: 0.05, y: 0.08)],
      );

  static ChartSetup _lesson28Recovery() => _rich(
        [c(80, 82, 75, 78), c(78, 80, 55, 58), c(58, 62, 52, 60), c(60, 65, 58, 63)],
        annotations: [
          const ChartAnnotation(text: 'Стоп торговли 48ч', x: 0.05, y: 0.08),
          const ChartAnnotation(text: 'Размер ÷2', x: 0.55, y: 0.45, color: _gold),
        ],
        markers: [const ChartMarker(candleIndex: 1, label: 'Большой минус', kind: ChartMarkerKind.note)],
      );

  static ChartSetup _lesson29Marathon1() => _rich(
        [c(40, 45, 38, 44), c(44, 50, 42, 48), c(48, 52, 45, 47), c(47, 55, 46, 54), c(54, 60, 52, 58), c(58, 65, 56, 63)],
        lines: [const ChartLine(x1: 0.05, y1: 0.85, x2: 0.95, y2: 0.15, label: 'Тренд ↑', color: _bull)],
        levels: [
          const ChartLevel(price: 46, label: 'Поддержка', color: _purple),
          const ChartLevel(price: 65, label: 'Цель', color: _bull),
        ],
        markers: [
          const ChartMarker(candleIndex: 2, label: 'План (без входа)', kind: ChartMarkerKind.note),
        ],
        annotations: [const ChartAnnotation(text: 'Марафон: разметка ETH 15m', x: 0.05, y: 0.08)],
      );

  static ChartSetup _lesson30Marathon2() => _rich(
        [c(58, 60, 56, 59), c(59, 64, 58, 62), c(62, 66, 60, 64), c(64, 66, 61, 63)],
        levels: [
          const ChartLevel(price: 56, label: 'Стоп', color: _bear),
          const ChartLevel(price: 66, label: 'Тейк', color: _bull),
        ],
        markers: [
          const ChartMarker(candleIndex: 0, label: 'Вход', kind: ChartMarkerKind.entry),
          const ChartMarker(candleIndex: 3, label: 'Выход', kind: ChartMarkerKind.target),
        ],
        annotations: [const ChartAnnotation(text: 'Журнал: процесс > PnL', x: 0.05, y: 0.08)],
      );

  static ChartSetup _lesson31Averaging() => _rich(
        [c(70, 72, 65, 66), c(66, 67, 58, 60), c(60, 61, 50, 52), c(52, 54, 42, 44)],
        markers: [
          const ChartMarker(candleIndex: 0, label: 'Усреднение', kind: ChartMarkerKind.entry),
          const ChartMarker(candleIndex: 2, label: 'Ещё лот', kind: ChartMarkerKind.entry),
        ],
        annotations: [
          const ChartAnnotation(text: 'Без лимита = слив', x: 0.05, y: 0.08, color: _bear),
          const ChartAnnotation(text: 'Макс. потеря 2%', x: 0.55, y: 0.55),
        ],
      );

  static ChartSetup _lesson32TrendChange() => _rich(
        [c(45, 50, 42, 48), c(48, 55, 46, 53), c(53, 56, 48, 50), c(50, 52, 42, 44), c(44, 46, 38, 40)],
        lines: [const ChartLine(x1: 0.35, y1: 0.48, x2: 0.95, y2: 0.72, label: 'Пробой HL', color: _bear)],
        markers: [const ChartMarker(candleIndex: 3, label: 'LH → шорт', kind: ChartMarkerKind.sell)],
        annotations: [const ChartAnnotation(text: 'Смена тренда ↑→↓', x: 0.05, y: 0.08)],
      );

  static ChartSetup _lesson33Journal() => _rich(
        [c(55, 60, 54, 58), c(58, 62, 56, 59), c(59, 58, 52, 54)],
        annotations: [
          const ChartAnnotation(text: 'Winrate по сетапам', x: 0.05, y: 0.08),
          const ChartAnnotation(text: 'Не по монетам', x: 0.05, y: 0.18),
        ],
      );

  static ChartSetup _lesson34Fomc() => _rich(
        [c(60, 62, 58, 61), c(61, 63, 59, 62), c(62, 78, 60, 75), c(75, 76, 62, 64), c(64, 66, 58, 60)],
        markers: [const ChartMarker(candleIndex: 2, label: 'Спайк', kind: ChartMarkerKind.note)],
        annotations: [
          const ChartAnnotation(text: 'ФРС: flat 30 мин', x: 0.05, y: 0.08, color: _bear),
          const ChartAnnotation(text: 'Вход через 15–30 мин', x: 0.62, y: 0.45, color: _bull),
        ],
      );

  static ChartSetup _lesson35Scam() => _rich(
        [c(50, 80, 48, 75), c(75, 78, 40, 42)],
        annotations: [
          const ChartAnnotation(text: '«Гарант 100x»', x: 0.25, y: 0.12, color: _bear),
          const ChartAnnotation(text: 'Не сигналы — сетапы', x: 0.05, y: 0.08, color: _gold),
        ],
      );

  static ChartSetup _lesson36Transfer() => _rich(
        [c(50, 52, 49, 51), c(51, 53, 50, 52)],
        annotations: [
          const ChartAnnotation(text: 'ERC20 ≠ TRC20', x: 0.05, y: 0.15, color: _bear),
          const ChartAnnotation(text: 'Тестовая сумма', x: 0.05, y: 0.08, color: _gold),
        ],
      );

  static ChartSetup _lesson37Api() => _rich(
        [c(70, 72, 69, 71), c(71, 73, 70, 72), c(72, 74, 71, 71), c(71, 72, 68, 69), c(69, 71, 68, 70)],
        before: ChartSequenceBuilder.sideways(10, center: 71, amplitude: 1.4),
        lines: [
          const ChartLine(x1: 0.7, y1: 0.22, x2: 0.7, y2: 0.45, label: 'Спуфинг', color: _bear, dashed: true),
        ],
        annotations: [
          const ChartAnnotation(text: 'API: read-only', x: 0.05, y: 0.08, color: _bull),
          const ChartAnnotation(text: 'Без withdraw', x: 0.05, y: 0.18, color: _bear),
        ],
      );

  static ChartSetup _lesson38Routine() => _rich(
        [c(55, 58, 54, 57), c(57, 62, 56, 60)],
        annotations: [
          const ChartAnnotation(text: 'Тишина + 2 монитора', x: 0.05, y: 0.08),
          const ChartAnnotation(text: 'Расписание сессий', x: 0.05, y: 0.18),
        ],
      );

  static ChartSetup _lesson39Futures() => _rich(
        [c(70, 72, 68, 71), c(71, 73, 65, 66), c(66, 67, 58, 59)],
        levels: [
          const ChartLevel(price: 58, label: 'Ликвидация 10x', color: _bear),
          const ChartLevel(price: 64, label: 'Стоп', color: _gold),
        ],
        zones: [ChartZone(top: 64, bottom: 58, color: _bear.withValues(alpha: 0.2), label: 'Маржа')],
        markers: [const ChartMarker(candleIndex: 0, label: 'Лонг 5x', kind: ChartMarkerKind.entry)],
        annotations: [
          const ChartAnnotation(text: 'Изолированная маржа', x: 0.05, y: 0.08),
          const ChartAnnotation(text: 'Funding каждые 8ч', x: 0.55, y: 0.12),
        ],
      );

  static ChartSetup _lesson40Mistakes2() => _rich(
        [c(60, 65, 58, 52), c(52, 58, 50, 55), c(55, 62, 53, 48)],
        annotations: [
          const ChartAnnotation(text: 'Реванш-трейд', x: 0.32, y: 0.35, color: _bear),
          const ChartAnnotation(text: 'Перенос стопа', x: 0.62, y: 0.55, color: _bear),
        ],
      );

  static ChartSetup _lesson41Apps() => _rich(
        [c(55, 60, 54, 58), c(58, 64, 57, 62)],
        annotations: [
          const ChartAnnotation(text: 'TradingView', x: 0.05, y: 0.12),
          const ChartAnnotation(text: 'CoinGlass', x: 0.05, y: 0.22),
          const ChartAnnotation(text: 'Trade Master', x: 0.05, y: 0.32, color: _gold),
        ],
      );

  static ChartSetup _lesson42Morning() => _rich(
        [c(54, 56, 53, 55), c(55, 62, 54, 60)],
        levels: [
          const ChartLevel(price: 62, label: 'Уровень дня', color: _purple),
          const ChartLevel(price: 53, label: 'Low вчера', color: _bull),
        ],
        annotations: [const ChartAnnotation(text: 'Утро: уровни + календарь', x: 0.05, y: 0.08)],
      );

  static ChartSetup _lesson43Fib() => _rich(
        [c(40, 45, 38, 44), c(44, 55, 42, 53), c(53, 54, 46, 48), c(48, 52, 45, 50)],
        levels: [
          const ChartLevel(price: 48.5, label: '0.5 Fib', color: _gold, dashed: true),
          const ChartLevel(price: 46, label: '0.618', color: _purple, dashed: true),
        ],
        lines: [const ChartLine(x1: 0.05, y1: 0.85, x2: 0.95, y2: 0.15, label: 'Тренд ↑', color: _bull)],
        markers: [const ChartMarker(candleIndex: 2, label: 'Лонг у Fib', kind: ChartMarkerKind.entry)],
      );

  static ChartSetup _lesson44Airdrop() => _rich(
        [c(10, 25, 8, 22), c(22, 35, 18, 30), c(30, 32, 15, 18)],
        annotations: [
          const ChartAnnotation(text: 'Pre-market: экстрим', x: 0.05, y: 0.08, color: _bear),
          const ChartAnnotation(text: 'Микро лот', x: 0.55, y: 0.45),
        ],
      );

  static ChartSetup _lesson45Candles() => _rich(
        [c(62, 64, 55, 63), c(63, 64, 58, 59), c(59, 68, 58, 66)],
        annotations: [
          const ChartAnnotation(text: 'Пин-бар: длинный низ', x: 0.05, y: 0.55, color: _bull),
          const ChartAnnotation(text: 'Поглощение', x: 0.72, y: 0.25, color: _bull),
        ],
        levels: [const ChartLevel(price: 55, label: 'Поддержка', color: _purple)],
      );

  static ChartSetup _lesson46HeadShoulders1() => _rich(
        [
          c(42, 46, 40, 44),
          c(44, 48, 42, 46),
          c(46, 52, 44, 50),
          c(50, 58, 48, 56),
          c(56, 62, 54, 60),
          c(60, 72, 58, 70),
          c(70, 74, 66, 68),
          c(68, 72, 64, 66),
          c(66, 68, 62, 64),
        ],
        lines: [
          const ChartLine(x1: 0.15, y1: 0.55, x2: 0.85, y2: 0.55, label: 'Линия шеи', color: _gold),
        ],
        annotations: [
          const ChartAnnotation(text: 'Левое плечо', x: 0.12, y: 0.35),
          const ChartAnnotation(text: 'Голова', x: 0.42, y: 0.12, color: _bear),
          const ChartAnnotation(text: 'Правое плечо', x: 0.72, y: 0.38),
        ],
      );

  static ChartSetup _lesson47HeadShoulders2() => _rich(
        [
          c(42, 46, 40, 44),
          c(44, 48, 42, 46),
          c(46, 52, 44, 50),
          c(50, 58, 48, 56),
          c(56, 62, 54, 60),
          c(60, 72, 58, 70),
          c(70, 74, 66, 68),
          c(68, 72, 64, 66),
          c(66, 65, 52, 54),
          c(54, 56, 42, 44),
        ],
        lines: [const ChartLine(x1: 0.1, y1: 0.55, x2: 0.75, y2: 0.55, label: 'Пробой шеи', color: _bear)],
        markers: [
          const ChartMarker(candleIndex: 8, label: 'Шорт', kind: ChartMarkerKind.sell),
          const ChartMarker(candleIndex: 9, label: 'Цель', kind: ChartMarkerKind.target),
        ],
        annotations: [const ChartAnnotation(text: 'Target = голова − шея', x: 0.05, y: 0.08)],
      );

  static ChartSetup _fallback(String chartType) {
    switch (chartType) {
      case 'support_resistance':
        return _lesson04SupportLows();
      case 'breakout':
        return _lesson10Impulse();
      case 'uptrend':
        return _lesson14Uptrend();
      case 'downtrend':
        return _lesson15Downtrend();
      case 'risk_reward':
        return _lesson18Risk();
      case 'pullback':
        return _lesson21HoldTarget();
      case 'reversal':
        return _lesson32TrendChange();
      case 'range_trading':
        return _lesson13Channel();
      case 'momentum':
        return _lesson10Impulse();
      case 'order_flow':
        return _lesson05OrderBook();
      case 'structure':
        return _lesson14Uptrend();
      default:
        return _lesson18Risk();
    }
  }
}
