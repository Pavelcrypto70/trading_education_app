import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/desk_key_config.dart';
import '../services/analytics_service.dart';
import '../services/desk_key_service.dart';
import '../services/locale_service.dart';
import '../theme.dart';

/// Web-only: after stage 1, recommend Tiger Desk Club path without locking lessons.
class SoftRefScreen extends StatefulWidget {
  const SoftRefScreen({super.key});

  static const dismissedKey = 'softRefDismissedAt';

  static Future<bool> wasDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(dismissedKey) != null;
  }

  static Future<void> markDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(dismissedKey, DateTime.now().toIso8601String());
  }

  /// Show once after stage 1 on web if ref not active and not dismissed.
  static Future<bool> shouldOffer() async {
    if (!DeskKeyConfig.enabled) return false;
    if (await DeskKeyService.isActive()) return false;
    if (await wasDismissed()) return false;
    return true;
  }

  @override
  State<SoftRefScreen> createState() => _SoftRefScreenState();
}

class _SoftRefScreenState extends State<SoftRefScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.refRecommendShown(surface: 'soft_ref');
  }

  Future<void> _continueWithout() async {
    AnalyticsService.continueWithoutRef(surface: 'soft_ref');
    await SoftRefScreen.markDismissed();
    if (mounted) context.go('/learning');
  }

  Future<void> _takeRecommended() async {
    AnalyticsService.refCtaClick(surface: 'soft_ref');
    if (mounted) context.push('/key');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.softRefTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.heroGradient(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.softRefHero,
                  style: AppTheme.display(24, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.softRefHeroBody,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(l10n.softRefBenefitsTitle, style: AppTheme.display(18)),
          const SizedBox(height: 10),
          for (final line in [
            l10n.softRefBenefit1,
            l10n.softRefBenefit2,
            l10n.softRefBenefit3,
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 18, color: AppTheme.mint),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(line, style: const TextStyle(color: AppTheme.textSoft, height: 1.4)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Text(
            l10n.softRefWithoutNote,
            style: const TextStyle(color: AppTheme.muted, height: 1.4, fontSize: 13),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _takeRecommended,
              child: Text(l10n.softRefCtaPrimary),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: _continueWithout,
              child: Text(l10n.softRefCtaSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
