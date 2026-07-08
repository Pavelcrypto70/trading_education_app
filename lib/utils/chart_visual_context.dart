import '../l10n/app_localizations.dart';

/// Decides how a lesson chart should be framed so visuals match the lesson topic.
class ChartVisualContext {
  final bool showCryptoHeader;
  final String? conceptTitle;
  final bool showTradingViewNote;

  const ChartVisualContext({
    this.showCryptoHeader = true,
    this.conceptTitle,
    this.showTradingViewNote = true,
  });

  static ChartVisualContext forChartType(String chartType, AppLocalizations l10n, {int? lessonId}) {
    if (lessonId != null) {
      return const ChartVisualContext(showCryptoHeader: true, showTradingViewNote: true);
    }
    switch (chartType) {
      case 'market_balance':
        return ChartVisualContext(
          showCryptoHeader: false,
          conceptTitle: l10n.chartConceptMarketBalance,
          showTradingViewNote: false,
        );
      case 'order_flow':
        return ChartVisualContext(
          showCryptoHeader: false,
          conceptTitle: l10n.chartConceptOrderBook,
          showTradingViewNote: false,
        );
      case 'session_timeline':
        return ChartVisualContext(
          showCryptoHeader: false,
          conceptTitle: l10n.chartConceptSessions,
          showTradingViewNote: false,
        );
      case 'correlation':
        return ChartVisualContext(
          showCryptoHeader: false,
          conceptTitle: l10n.chartConceptCorrelation,
          showTradingViewNote: false,
        );
      case 'risk_reward':
        return ChartVisualContext(
          showCryptoHeader: true,
          showTradingViewNote: true,
        );
      default:
        return const ChartVisualContext(showCryptoHeader: true, showTradingViewNote: true);
    }
  }

  /// Whether the practical example step should repeat a price chart.
  static bool exampleNeedsChart(String chartType) {
    switch (chartType) {
      case 'support_resistance':
      case 'breakout':
      case 'false_breakout':
      case 'pullback':
      case 'uptrend':
      case 'downtrend':
      case 'structure':
      case 'range_trading':
      case 'reversal':
      case 'risk_reward':
        return true;
      default:
        return false;
    }
  }
}
