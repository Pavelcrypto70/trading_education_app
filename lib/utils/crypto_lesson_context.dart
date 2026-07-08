import '../models/lesson.dart';

/// Maps each lesson to a crypto pair and chart context for visual examples.
class CryptoLessonContext {
  final String pair;
  final String exchange;
  final String timeframe;
  final String primaryChartType;

  const CryptoLessonContext({
    required this.pair,
    required this.exchange,
    required this.timeframe,
    required this.primaryChartType,
  });

  static const _pairs = [
    'BTC/USDT',
    'ETH/USDT',
    'SOL/USDT',
    'BNB/USDT',
    'XRP/USDT',
    'ADA/USDT',
    'DOGE/USDT',
    'AVAX/USDT',
  ];

  static const _timeframes = ['15m', '1H', '4H', '1D'];

  static CryptoLessonContext forLesson(Lesson lesson) {
    final pair = _pairs[(lesson.id - 1) % _pairs.length];
    final tf = _timeframes[(lesson.id - 1) % _timeframes.length];
    final chartType = _chartFromSections(lesson) ?? 'candlestick';
    return CryptoLessonContext(
      pair: pair,
      exchange: 'Binance',
      timeframe: tf,
      primaryChartType: chartType,
    );
  }

  static String? _chartFromSections(Lesson lesson) {
    for (final s in lesson.sections) {
      if (s.type == 'chart' && s.chartType != null) {
        return s.chartType;
      }
    }
    return null;
  }
}
