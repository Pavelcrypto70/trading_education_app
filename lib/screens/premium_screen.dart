import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/app_config.dart';
import '../config/backend_config.dart';
import '../config/build_flags.dart';
import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../services/analytics_service.dart';
import '../services/entitlement_service.dart';
import '../services/locale_service.dart';
import '../services/purchase_service.dart';
import '../services/premium_service.dart';
import '../theme.dart';
import '../utils/external_link.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _hasAccess = false;
  bool _loading = true;
  bool _purchasing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await EntitlementService.refresh();
    final access = await EntitlementService.hasFullAccess();
    if (!mounted) return;
    setState(() {
      _hasAccess = access;
      _loading = false;
    });
  }

  String _priceLabel(String lang) {
    switch (lang) {
      case 'ru':
        return '${AppConfig.lifetimePriceRub} ₽';
      case 'pt':
        return 'R\$ ${AppConfig.lifetimePriceBrl.toStringAsFixed(2).replaceAll('.', ',')}';
      case 'es':
        return 'MX\$ ${AppConfig.lifetimePriceMxn.toStringAsFixed(0)}';
      default:
        return '\$${AppConfig.lifetimePriceUsd.toStringAsFixed(2)}';
    }
  }

  String _marketLabel(String lang) {
    switch (lang) {
      case 'ru':
        return '${AppConfig.marketPriceRub} ₽';
      case 'pt':
        return 'R\$ ${AppConfig.marketPriceBrl.toStringAsFixed(2).replaceAll('.', ',')}';
      case 'es':
        return 'MX\$ ${AppConfig.marketPriceMxn.toStringAsFixed(0)}';
      default:
        return '\$${AppConfig.marketPriceUsd.toStringAsFixed(2)}';
    }
  }

  Future<void> _openCommunity() async {
    final ok = await openExternalLink(AppConfig.communityTelegramUrl);
    if (!ok && mounted) {
      _snack(context.l10n.communityOpenError);
    }
  }

  Future<void> _purchase() async {
    final l10n = context.l10n;

    if (!BackendConfig.isConfigured) {
      _snack(l10n.backendNotConfigured);
      return;
    }
    if (!AuthService.isSignedIn) {
      final signedIn = await context.push<bool>('/auth');
      if (signedIn != true) {
        _snack(l10n.signInRequiredForPurchase);
        return;
      }
    }

    setState(() => _purchasing = true);
    AnalyticsService.purchaseStart();
    final result = await PurchaseService.purchaseLifetime();
    if (!mounted) return;
    setState(() => _purchasing = false);

    switch (result) {
      case PurchaseResult.success:
        AnalyticsService.purchaseSuccess(kIsWeb ? 'web' : 'mobile');
        await PremiumService.refreshFromServer();
        await _load();
        if (kIsWeb) {
          _snack(l10n.webCheckoutOpened);
        } else {
          _snack(l10n.premiumActivated);
        }
      case PurchaseResult.cancelled:
        _snack(l10n.purchaseCancelled);
      case PurchaseResult.notAvailable:
        _snack(l10n.purchaseNotAvailable);
      case PurchaseResult.notSignedIn:
        _snack(l10n.signInRequiredForPurchase);
      case PurchaseResult.backendNotConfigured:
        _snack(l10n.backendNotConfigured);
      case PurchaseResult.error:
        _snack(l10n.authError);
    }
  }

  Future<void> _restore() async {
    final l10n = context.l10n;
    if (!AuthService.isSignedIn) {
      _snack(l10n.signInRequiredForPurchase);
      return;
    }
    setState(() => _purchasing = true);
    final result = await PurchaseService.restorePurchases();
    if (!mounted) return;
    setState(() => _purchasing = false);
    if (result == PurchaseResult.success) {
      await _load();
      _snack(l10n.purchasesRestored);
    } else {
      _snack(l10n.authError);
    }
  }

  void _snack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = LocaleService.instance.languageCode;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!BuildFlags.enableBilling) {
      return _buildCommunityGate(l10n);
    }

    final features = [
      l10n.premiumFeatureAllLessons,
      l10n.premiumFeatureVideo,
      l10n.premiumFeatureHomework,
      l10n.premiumFeatureJournal,
      l10n.premiumFeatureCertificate,
      l10n.premiumFeaturePractice,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.premium)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_hasAccess)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.gold.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppTheme.gold),
                    const SizedBox(width: 10),
                    Expanded(child: Text(l10n.youHavePremium, style: const TextStyle(fontWeight: FontWeight.w600))),
                  ],
                ),
              ),
            Text(
              l10n.lifetimePurchase,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.premiumSubtitle,
              style: const TextStyle(color: AppTheme.muted),
            ),
            const SizedBox(height: 22),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: AppTheme.heroGradient(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _priceLabel(lang),
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppTheme.gold),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          _marketLabel(lang),
                          style: const TextStyle(
                            color: AppTheme.faint,
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.bull.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      l10n.priceBelowMarket,
                      style: const TextStyle(color: AppTheme.bull, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    l10n.paywallLessonBody(EntitlementService.trialLessonCount),
                    style: const TextStyle(color: AppTheme.textSoft, fontSize: 13, height: 1.45),
                  ),
                  const SizedBox(height: 18),
                  ...features.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.check, color: AppTheme.bull, size: 20),
                          const SizedBox(width: 10),
                          Expanded(child: Text(f, style: const TextStyle(fontSize: 14))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (!_hasAccess) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _purchasing ? null : _purchase,
                  child: _purchasing
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(kIsWeb ? l10n.purchaseFullCourse : l10n.purchaseFullCourse),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: _purchasing ? null : _restore,
                  child: Text(l10n.restorePurchases),
                ),
              ),
            ] else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.continueLearning),
                ),
              ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => context.pop(),
                child: Text(l10n.cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityGate(AppLocalizations l10n) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.communityTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.communityFullAccessTitle,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.communityFullAccessBody,
              style: const TextStyle(color: AppTheme.textSoft, height: 1.5),
            ),
            const SizedBox(height: 22),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: AppTheme.heroGradient(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.paywallLessonBodyCommunity(EntitlementService.trialLessonCount),
                    style: const TextStyle(color: AppTheme.textSoft, fontSize: 14, height: 1.45),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppConfig.communityTelegramHandle,
                    style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openCommunity,
                icon: const Icon(Icons.telegram),
                label: Text(l10n.openCommunityCta),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => context.pop(),
                child: Text(l10n.cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
