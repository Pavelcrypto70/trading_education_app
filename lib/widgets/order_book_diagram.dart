import 'package:flutter/material.dart';

import '../services/locale_service.dart';
import '../theme.dart';

/// Binance-style order book demo for lessons (bids / asks / spread / walls).
enum OrderBookScenario {
  /// Classic liquid book — green bids, red asks, tight spread.
  classic,

  /// Highlight best bid / ask and the spread row.
  spread,

  /// Large ask wall (density) near the top of the book.
  askWall,

  /// Large bid wall near the bottom (buyers stacked).
  bidWall,

  /// Wall that looks real but is labeled as possible spoof.
  spoof,
}

class OrderBookDiagram extends StatefulWidget {
  final OrderBookScenario scenario;
  final double height;
  final String pair;

  const OrderBookDiagram({
    super.key,
    this.scenario = OrderBookScenario.classic,
    this.height = 320,
    this.pair = 'BTC/USDT',
  });

  static OrderBookScenario fromChartType(String chartType) {
    switch (chartType) {
      case 'order_book_spread':
      case 'spread':
        return OrderBookScenario.spread;
      case 'order_book_wall':
      case 'ask_wall':
        return OrderBookScenario.askWall;
      case 'order_book_bid_wall':
      case 'bid_wall':
        return OrderBookScenario.bidWall;
      case 'order_book_spoof':
      case 'spoof':
        return OrderBookScenario.spoof;
      case 'order_book':
      case 'order_flow':
      default:
        return OrderBookScenario.classic;
    }
  }

  @override
  State<OrderBookDiagram> createState() => _OrderBookDiagramState();
}

class _OrderBookDiagramState extends State<OrderBookDiagram>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final book = _BookData.forScenario(widget.scenario).forPair(widget.pair);
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = Curves.easeOutCubic.transform(_ctrl.value);
        return Container(
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.bg2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.lineSoft),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _Header(pair: widget.pair, scenario: widget.scenario),
              _ColumnLabels(base: book.base),
              Expanded(
                child: Opacity(
                  opacity: t,
                  child: _BookBody(book: book, progress: t),
                ),
              ),
              _Callout(text: book.callout),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final String pair;
  final OrderBookScenario scenario;

  const _Header({required this.pair, required this.scenario});

  @override
  Widget build(BuildContext context) {
    final l = LocaleService.instance.strings;
    final label = switch (scenario) {
      OrderBookScenario.classic => l.obHeaderClassic,
      OrderBookScenario.spread => l.obHeaderSpread,
      OrderBookScenario.askWall => l.obHeaderAskWall,
      OrderBookScenario.bidWall => l.obHeaderBidWall,
      OrderBookScenario.spoof => l.obHeaderSpoof,
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.grid)),
      ),
      child: Row(
        children: [
          Text(
            pair,
            style: const TextStyle(
              color: AppTheme.text,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFeatures: _tabular,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppTheme.gold.withValues(alpha: 0.9),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColumnLabels extends StatelessWidget {
  final String base;

  const _ColumnLabels({required this.base});

  @override
  Widget build(BuildContext context) {
    final l = LocaleService.instance.strings;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
      child: Row(
        children: [
          Expanded(child: Text(l.obColPrice, style: _labelStyle)),
          Expanded(
            child: Text(l.obColAmount(base), textAlign: TextAlign.right, style: _labelStyle),
          ),
          Expanded(
            child: Text(l.obColTotal, textAlign: TextAlign.right, style: _labelStyle),
          ),
        ],
      ),
    );
  }
}

const _tabular = [FontFeature.tabularFigures()];

const _labelStyle = TextStyle(color: AppTheme.faint, fontSize: 10, fontWeight: FontWeight.w500);

class _BookBody extends StatelessWidget {
  final _BookData book;
  final double progress;

  const _BookBody({required this.book, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              for (var i = 0; i < book.asks.length; i++)
                Expanded(
                  child: _LevelRow(
                    level: book.asks[i],
                    maxSize: book.maxSize,
                    decimals: book.decimals,
                    isAsk: true,
                    progress: progress,
                  ),
                ),
            ],
          ),
        ),
        _SpreadRow(book: book),
        Expanded(
          child: Column(
            children: [
              for (var i = 0; i < book.bids.length; i++)
                Expanded(
                  child: _LevelRow(
                    level: book.bids[i],
                    maxSize: book.maxSize,
                    decimals: book.decimals,
                    isAsk: false,
                    progress: progress,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpreadRow extends StatelessWidget {
  final _BookData book;

  const _SpreadRow({required this.book});

  @override
  Widget build(BuildContext context) {
    final highlight = book.highlightSpread;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: highlight ? AppTheme.warn.withValues(alpha: 0.13) : AppTheme.grid,
      child: Row(
        children: [
          Text(
            book.lastPrice.toStringAsFixed(book.decimals),
            style: TextStyle(
              color: highlight ? AppTheme.gold : AppTheme.bull,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              fontFeatures: _tabular,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${LocaleService.instance.strings.obSpread} ${book.spread.toStringAsFixed(book.decimals)} USDT  (${book.spreadPct.toStringAsFixed(3)}%)',
            style: TextStyle(
              color: highlight ? AppTheme.gold : AppTheme.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelRow extends StatelessWidget {
  final _Level level;
  final double maxSize;
  final int decimals;
  final bool isAsk;
  final double progress;

  const _LevelRow({
    required this.level,
    required this.maxSize,
    required this.decimals,
    required this.isAsk,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final color = isAsk ? AppTheme.bear : AppTheme.bull;
    final depth = (level.size / maxSize).clamp(0.0, 1.0) * progress;
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FractionallySizedBox(
            widthFactor: depth,
            child: Container(color: color.withValues(alpha: level.isWall ? 0.28 : 0.12)),
          ),
        ),
        if (level.isWall)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.gold.withValues(alpha: 0.55), width: 1),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      level.price.toStringAsFixed(decimals),
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFeatures: _tabular,
                      ),
                    ),
                    if (level.isWall) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppTheme.gold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          level.wallLabel ?? LocaleService.instance.strings.obWall,
                          style: const TextStyle(
                            color: AppTheme.gold,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  _formatSize(level.size),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppTheme.textSoft,
                    fontSize: 12,
                    fontFeatures: _tabular,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  _formatSize(level.total),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontSize: 12,
                    fontFeatures: _tabular,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Callout extends StatelessWidget {
  final String text;

  const _Callout({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.grid)),
        color: AppTheme.surface,
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppTheme.textSoft, fontSize: 12, height: 1.35),
      ),
    );
  }
}

class _Level {
  final double price;
  final double size;
  final double total;
  final bool isWall;
  final String? wallLabel;

  const _Level({
    required this.price,
    required this.size,
    required this.total,
    this.isWall = false,
    this.wallLabel,
  });
}

String _formatSize(double v) {
  if (v >= 1e6) return '${(v / 1e6).toStringAsFixed(2)}M';
  if (v >= 1e4) return '${(v / 1e3).toStringAsFixed(1)}K';
  if (v >= 100) return v.toStringAsFixed(0);
  if (v >= 10) return v.toStringAsFixed(2);
  return v.toStringAsFixed(3);
}

String _approxSize(double v) {
  if (v >= 1e6) return '${(v / 1e6).toStringAsFixed(1)}M';
  if (v >= 1e4) return '${(v / 1e3).toStringAsFixed(0)}K';
  return v.toStringAsFixed(v >= 10 ? 0 : 1);
}

class _Coin {
  final double price;
  final double tick;
  final int decimals;

  const _Coin(this.price, this.tick, this.decimals);
}

/// Reference prices and ticks so a BTC-shaped demo book reads like the lesson's coin.
const _coins = <String, _Coin>{
  'BTC': _Coin(67202.4, 0.1, 1),
  'ETH': _Coin(3452.18, 0.01, 2),
  'SOL': _Coin(168.42, 0.01, 2),
  'BNB': _Coin(591.3, 0.1, 1),
  'XRP': _Coin(0.6213, 0.0001, 4),
  'ADA': _Coin(0.4521, 0.0001, 4),
  'DOGE': _Coin(0.16214, 0.00001, 5),
  'AVAX': _Coin(36.48, 0.01, 2),
};

const _btcTick = 0.1;

class _BookData {
  final OrderBookScenario scenario;
  final List<_Level> asks; // top → best ask last (near middle)
  final List<_Level> bids; // best bid first → deeper
  final double lastPrice;
  final double spread;
  final double spreadPct;
  final double maxSize;
  final bool highlightSpread;
  final String base;
  final int decimals;

  const _BookData({
    required this.scenario,
    required this.asks,
    required this.bids,
    required this.lastPrice,
    required this.spread,
    required this.spreadPct,
    required this.maxSize,
    this.highlightSpread = false,
    this.base = 'BTC',
    this.decimals = 1,
  });

  String get callout {
    final l = LocaleService.instance.strings;
    final wall = [...asks, ...bids].where((e) => e.isWall).firstOrNull;
    return switch (scenario) {
      OrderBookScenario.classic => l.obCalloutClassic,
      OrderBookScenario.spread => l.obCalloutSpread(spread.toStringAsFixed(decimals)),
      OrderBookScenario.askWall when wall != null =>
        l.obCalloutAskWall(_approxSize(wall.size), base, wall.price.toStringAsFixed(decimals)),
      OrderBookScenario.bidWall when wall != null => l.obCalloutBidWall(_approxSize(wall.size), base),
      OrderBookScenario.askWall || OrderBookScenario.bidWall => l.obCalloutClassic,
      OrderBookScenario.spoof => l.obCalloutSpoof,
    };
  }

  /// Spread scenario scales by percent (the hole must stay wide); others keep tick distances.
  _BookData forPair(String pair) {
    final target = pair.split('/').first.toUpperCase();
    final coin = _coins[target];
    if (coin == null || target == base) return this;
    final byPercent = scenario == OrderBookScenario.spread;
    final ratio = coin.price / lastPrice;
    double mapPrice(double p) => byPercent ? p * ratio : coin.price + (p - lastPrice) / _btcTick * coin.tick;
    final sizeK = 1 / ratio;
    List<_Level> mapLevels(List<_Level> src) => [
          for (final e in src)
            _Level(
              price: mapPrice(e.price),
              size: e.size * sizeK,
              total: e.total * sizeK,
              isWall: e.isWall,
              wallLabel: e.wallLabel,
            ),
        ];
    final newSpread = byPercent ? spread * ratio : spread / _btcTick * coin.tick;
    return _BookData(
      scenario: scenario,
      asks: mapLevels(asks),
      bids: mapLevels(bids),
      lastPrice: coin.price,
      spread: newSpread,
      spreadPct: newSpread / coin.price * 100,
      maxSize: maxSize * sizeK,
      highlightSpread: highlightSpread,
      base: target,
      decimals: coin.decimals,
    );
  }

  static _BookData forScenario(OrderBookScenario scenario) {
    switch (scenario) {
      case OrderBookScenario.spread:
        return _spread();
      case OrderBookScenario.askWall:
        return _askWall();
      case OrderBookScenario.bidWall:
        return _bidWall();
      case OrderBookScenario.spoof:
        return _spoof();
      case OrderBookScenario.classic:
        return _classic();
    }
  }

  static List<_Level> _withTotals(List<(double, double, bool, String?)> rows) {
    var run = 0.0;
    final out = <_Level>[];
    for (final r in rows) {
      run += r.$2;
      out.add(_Level(price: r.$1, size: r.$2, total: run, isWall: r.$3, wallLabel: r.$4));
    }
    return out;
  }

  static _BookData _classic() {
    // Asks shown top→down toward mid: highest first
    final asksRaw = <(double, double, bool, String?)>[
      (67208.5, 0.412, false, null),
      (67207.2, 0.858, false, null),
      (67206.0, 1.204, false, null),
      (67204.8, 0.631, false, null),
      (67203.5, 2.105, false, null), // best ask
    ];
    final bidsRaw = <(double, double, bool, String?)>[
      (67202.4, 1.842, false, null), // best bid
      (67201.1, 0.976, false, null),
      (67199.8, 1.450, false, null),
      (67198.5, 0.720, false, null),
      (67197.0, 2.310, false, null),
    ];
    final asksBinance = _asksLikeBinance(asksRaw);
    final bids = _withTotals(bidsRaw);
    final bestAsk = 67203.5;
    final bestBid = 67202.4;
    final spread = bestAsk - bestBid;
    return _BookData(
      scenario: OrderBookScenario.classic,
      asks: asksBinance,
      bids: bids,
      lastPrice: bestBid,
      spread: spread,
      spreadPct: spread / bestBid * 100,
      maxSize: 2.5,
    );
  }

  /// Asks displayed highest price at top; Total accumulates from best ask upward.
  static List<_Level> _asksLikeBinance(List<(double, double, bool, String?)> highToBest) {
    // highToBest is highest → best ask (last)
    final bestFirst = highToBest.reversed.toList();
    var run = 0.0;
    final fromBest = <_Level>[];
    for (final r in bestFirst) {
      run += r.$2;
      fromBest.add(_Level(price: r.$1, size: r.$2, total: run, isWall: r.$3, wallLabel: r.$4));
    }
    return fromBest.reversed.toList();
  }

  static _BookData _spread() {
    // Illiquid alt: wide hole between best bid and best ask.
    final asks = _asksLikeBinance([
      (185.40, 420.0, false, null),
      (184.90, 310.0, false, null),
      (184.20, 250.0, false, null),
      (183.50, 180.0, false, null),
      (182.80, 95.0, false, null),
    ]);
    final bids = _withTotals([
      (178.10, 110.0, false, null),
      (177.40, 160.0, false, null),
      (176.80, 220.0, false, null),
      (176.00, 280.0, false, null),
      (175.20, 350.0, false, null),
    ]);
    final bestAsk = 182.80;
    final bestBid = 178.10;
    final spread = bestAsk - bestBid;
    return _BookData(
      scenario: OrderBookScenario.spread,
      asks: asks,
      bids: bids,
      lastPrice: bestBid,
      spread: spread,
      spreadPct: spread / bestBid * 100,
      maxSize: 420,
      highlightSpread: true,
      base: 'ALT',
      decimals: 2,
    );
  }

  static _BookData _askWall() {
    final asksRaw = <(double, double, bool, String?)>[
      (67220.0, 0.50, false, null),
      (67215.0, 0.80, false, null),
      (67210.0, 1.10, false, null),
      (67205.0, 48.0, true, null), // huge ask wall
      (67203.5, 1.60, false, null),
    ];
    final bidsRaw = <(double, double, bool, String?)>[
      (67202.4, 1.90, false, null),
      (67200.0, 1.20, false, null),
      (67198.0, 0.95, false, null),
      (67195.0, 1.40, false, null),
      (67192.0, 2.00, false, null),
    ];
    final bestAsk = 67203.5;
    final bestBid = 67202.4;
    final spread = bestAsk - bestBid;
    return _BookData(
      scenario: OrderBookScenario.askWall,
      asks: _asksLikeBinance(asksRaw),
      bids: _withTotals(bidsRaw),
      lastPrice: bestBid,
      spread: spread,
      spreadPct: spread / bestBid * 100,
      maxSize: 48,
    );
  }

  static _BookData _bidWall() {
    final asksRaw = <(double, double, bool, String?)>[
      (67212.0, 0.70, false, null),
      (67209.0, 1.00, false, null),
      (67206.0, 1.30, false, null),
      (67204.0, 0.90, false, null),
      (67203.0, 1.50, false, null),
    ];
    final bidsRaw = <(double, double, bool, String?)>[
      (67201.5, 1.80, false, null),
      (67198.0, 52.0, true, null),
      (67195.0, 1.10, false, null),
      (67192.0, 0.85, false, null),
      (67190.0, 1.60, false, null),
    ];
    final bestAsk = 67203.0;
    final bestBid = 67201.5;
    final spread = bestAsk - bestBid;
    return _BookData(
      scenario: OrderBookScenario.bidWall,
      asks: _asksLikeBinance(asksRaw),
      bids: _withTotals(bidsRaw),
      lastPrice: bestBid,
      spread: spread,
      spreadPct: spread / bestBid * 100,
      maxSize: 52,
    );
  }

  static _BookData _spoof() {
    final asksRaw = <(double, double, bool, String?)>[
      (67225.0, 0.40, false, null),
      (67218.0, 0.60, false, null),
      (67212.0, 85.0, true, 'SPOOF?'),
      (67206.0, 1.20, false, null),
      (67203.5, 1.80, false, null),
    ];
    final bidsRaw = <(double, double, bool, String?)>[
      (67202.0, 1.50, false, null),
      (67199.0, 1.00, false, null),
      (67196.0, 0.80, false, null),
      (67193.0, 1.20, false, null),
      (67190.0, 1.70, false, null),
    ];
    final bestAsk = 67203.5;
    final bestBid = 67202.0;
    final spread = bestAsk - bestBid;
    return _BookData(
      scenario: OrderBookScenario.spoof,
      asks: _asksLikeBinance(asksRaw),
      bids: _withTotals(bidsRaw),
      lastPrice: bestBid,
      spread: spread,
      spreadPct: spread / bestBid * 100,
      maxSize: 85,
    );
  }
}
