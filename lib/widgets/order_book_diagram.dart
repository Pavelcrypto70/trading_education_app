import 'package:flutter/material.dart';

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
    final book = _BookData.forScenario(widget.scenario);
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = Curves.easeOutCubic.transform(_ctrl.value);
        return Container(
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0B0E11),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _Header(pair: widget.pair, scenario: widget.scenario),
              _ColumnLabels(),
              Expanded(
                child: Opacity(
                  opacity: t,
                  child: _BookBody(book: book, progress: t),
                ),
              ),
              if (book.callout != null) _Callout(text: book.callout!),
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
    final label = switch (scenario) {
      OrderBookScenario.classic => 'Order book · Binance style',
      OrderBookScenario.spread => 'Look at the spread',
      OrderBookScenario.askWall => 'Ask wall (sellers)',
      OrderBookScenario.bidWall => 'Bid wall (buyers)',
      OrderBookScenario.spoof => 'Possible spoof wall',
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x14FFFFFF))),
      ),
      child: Row(
        children: [
          Text(
            pair,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
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
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
      child: Row(
        children: [
          Expanded(child: Text('Price (USDT)', style: _labelStyle)),
          Expanded(
            child: Text('Amount (BTC)', textAlign: TextAlign.right, style: _labelStyle),
          ),
          Expanded(
            child: Text('Total', textAlign: TextAlign.right, style: _labelStyle),
          ),
        ],
      ),
    );
  }
}

const _labelStyle = TextStyle(color: Color(0x66FFFFFF), fontSize: 10, fontWeight: FontWeight.w500);

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
      color: highlight ? const Color(0x22D4AF37) : const Color(0x10FFFFFF),
      child: Row(
        children: [
          Text(
            book.lastPrice.toStringAsFixed(1),
            style: TextStyle(
              color: highlight ? AppTheme.gold : const Color(0xFF0ECB81),
              fontSize: 15,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Spread ${book.spread.toStringAsFixed(1)} USDT  (${book.spreadPct.toStringAsFixed(3)}%)',
            style: TextStyle(
              color: highlight ? AppTheme.gold : Colors.white54,
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
  final bool isAsk;
  final double progress;

  const _LevelRow({
    required this.level,
    required this.maxSize,
    required this.isAsk,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final color = isAsk ? const Color(0xFFF6465D) : const Color(0xFF0ECB81);
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
                      level.price.toStringAsFixed(1),
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
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
                          level.wallLabel ?? 'WALL',
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
                  level.size.toStringAsFixed(3),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  level.total.toStringAsFixed(3),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontFamily: 'monospace',
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
        border: Border(top: BorderSide(color: Color(0x14FFFFFF))),
        color: Color(0xFF12161C),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.35),
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

class _BookData {
  final List<_Level> asks; // top → best ask last (near middle)
  final List<_Level> bids; // best bid first → deeper
  final double lastPrice;
  final double spread;
  final double spreadPct;
  final double maxSize;
  final bool highlightSpread;
  final String? callout;

  const _BookData({
    required this.asks,
    required this.bids,
    required this.lastPrice,
    required this.spread,
    required this.spreadPct,
    required this.maxSize,
    this.highlightSpread = false,
    this.callout,
  });

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
      asks: asksBinance,
      bids: bids,
      lastPrice: bestBid,
      spread: spread,
      spreadPct: spread / bestBid * 100,
      maxSize: 2.5,
      callout: 'Binance layout: asks (red) on top, bids (green) below. Trades happen in the middle.',
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
      asks: asks,
      bids: bids,
      lastPrice: bestBid,
      spread: spread,
      spreadPct: spread / bestBid * 100,
      maxSize: 420,
      highlightSpread: true,
      callout:
          'Wide spread (~${spread.toStringAsFixed(1)} USDT). A market order will burn several levels — expensive on thin alts.',
    );
  }

  static _BookData _askWall() {
    final asksRaw = <(double, double, bool, String?)>[
      (67220.0, 0.50, false, null),
      (67215.0, 0.80, false, null),
      (67210.0, 1.10, false, null),
      (67205.0, 48.0, true, 'WALL'), // huge ask wall
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
      asks: _asksLikeBinance(asksRaw),
      bids: _withTotals(bidsRaw),
      lastPrice: bestBid,
      spread: spread,
      spreadPct: spread / bestBid * 100,
      maxSize: 48,
      callout: 'Ask wall ~48 BTC at 67205 — dense sellers. Do not short “from the wall” without the tape.',
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
      (67198.0, 52.0, true, 'WALL'),
      (67195.0, 1.10, false, null),
      (67192.0, 0.85, false, null),
      (67190.0, 1.60, false, null),
    ];
    final bestAsk = 67203.0;
    final bestBid = 67201.5;
    final spread = bestAsk - bestBid;
    return _BookData(
      asks: _asksLikeBinance(asksRaw),
      bids: _withTotals(bidsRaw),
      lastPrice: bestBid,
      spread: spread,
      spreadPct: spread / bestBid * 100,
      maxSize: 52,
      callout: 'Bid wall ~52 BTC — buyers in queue. May hold price… or cancel when price approaches.',
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
      asks: _asksLikeBinance(asksRaw),
      bids: _withTotals(bidsRaw),
      lastPrice: bestBid,
      spread: spread,
      spreadPct: spread / bestBid * 100,
      maxSize: 85,
      callout:
          'Huge wall far from mid + empty tape = spoofing risk. Wait for reaction — do not enter “because of the wall”.',
    );
  }
}
