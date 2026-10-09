import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../services/locale_service.dart';
import '../theme.dart';
import '../utils/external_link.dart';
import 'accent_card.dart';

/// Prominent community CTA — shown on home and learning screens.
class CommunityBanner extends StatelessWidget {
  final bool compact;

  const CommunityBanner({super.key, this.compact = false});

  Future<void> _open(BuildContext context) async {
    final ok = await openExternalLink(AppConfig.communityTelegramUrl);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.communityOpenError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const blue = AppTheme.accentCommunity;

    return AccentCard(
      accent: blue,
      tags: compact ? const ['Telegram', 'Live'] : const ['Telegram', 'Live', 'Q&A'],
      padding: EdgeInsets.all(compact ? 14 : 18),
      onTap: () => _open(context),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: blue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.telegram, color: blue, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.communityTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: compact ? 14 : 16,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.communitySubtitle,
                  style: const TextStyle(color: AppTheme.textSoft, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: AppTheme.faint, size: 16),
        ],
      ),
    );
  }
}
