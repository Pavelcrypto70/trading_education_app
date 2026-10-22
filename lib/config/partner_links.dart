import 'package:flutter/foundation.dart';

/// Partner / affiliate offers unlocked after certificate.
///
/// Set URLs via dart-define (see dart_defines.example.json) or edit defaults.
/// Empty url = hidden in UI.
/// Play/Galaxy builds never show broker/exchange partner cards (Payments / financial policy).
class PartnerOffer {
  final String id;
  final PartnerCategory category;
  /// Localization key handled in AppLocalizations.partnerName / partnerBlurb.
  final String nameEn;
  final String blurbEn;
  final String url;

  const PartnerOffer({
    required this.id,
    required this.category,
    required this.nameEn,
    required this.blurbEn,
    required this.url,
  });

  bool get isConfigured => url.trim().isNotEmpty;
}

enum PartnerCategory { exchange, terminal }

/// Central list of exchanges & terminals we recommend after graduation.
class PartnerLinks {
  PartnerLinks._();

  static const offers = <PartnerOffer>[
    PartnerOffer(
      id: 'binance',
      category: PartnerCategory.exchange,
      nameEn: 'Binance',
      blurbEn: 'Main CEX for spot & futures practice after the course.',
      url: String.fromEnvironment('PARTNER_BINANCE_URL'),
    ),
    PartnerOffer(
      id: 'bybit',
      category: PartnerCategory.exchange,
      nameEn: 'Bybit',
      blurbEn: 'Alternative exchange for futures and demo transition.',
      url: String.fromEnvironment('PARTNER_BYBIT_URL'),
    ),
    PartnerOffer(
      id: 'bitso',
      category: PartnerCategory.exchange,
      nameEn: 'Bitso',
      blurbEn: 'LATAM-friendly on-ramp (MX / AR / CO).',
      url: String.fromEnvironment('PARTNER_BITSO_URL'),
    ),
    PartnerOffer(
      id: 'mercado_bitcoin',
      category: PartnerCategory.exchange,
      nameEn: 'Mercado Bitcoin',
      blurbEn: 'Brazil-focused exchange for local onboarding.',
      url: String.fromEnvironment('PARTNER_MERCADO_BITCOIN_URL'),
    ),
    PartnerOffer(
      id: 'tiger',
      category: PartnerCategory.terminal,
      nameEn: 'Tiger.Trade',
      blurbEn: 'Pro terminal via exchange API — execution, not a plan replacement.',
      url: String.fromEnvironment('PARTNER_TIGER_URL'),
    ),
    PartnerOffer(
      id: 'vataga',
      category: PartnerCategory.terminal,
      nameEn: 'Vataga',
      blurbEn: 'Order-flow oriented terminal for advanced practice.',
      url: String.fromEnvironment('PARTNER_VATAGA_URL'),
    ),
  ];

  /// Web-only: store APKs must not deep-link to exchanges/brokers after certificate.
  static List<PartnerOffer> get configured {
    if (!kIsWeb) return const [];
    return offers.where((o) => o.isConfigured).toList(growable: false);
  }

  static List<PartnerOffer> get exchanges => configured
      .where((o) => o.category == PartnerCategory.exchange)
      .toList(growable: false);

  static List<PartnerOffer> get terminals => configured
      .where((o) => o.category == PartnerCategory.terminal)
      .toList(growable: false);
}
