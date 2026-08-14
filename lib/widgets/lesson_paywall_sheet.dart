import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/build_flags.dart';
import '../services/analytics_service.dart';
import '../services/entitlement_service.dart';
import '../services/locale_service.dart';
import '../theme.dart';

Future<bool> showLessonPaywallIfNeeded(BuildContext context, int lessonId) async {
  if (await EntitlementService.isLessonUnlocked(lessonId)) return true;

  AnalyticsService.paywallView(lessonId);

  if (!context.mounted) return false;
  final l10n = context.l10n;
  final billing = BuildFlags.enableBilling;
  final goNext = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: AppTheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Icon(
            billing ? Icons.lock_outline : Icons.telegram,
            color: billing ? AppTheme.gold : const Color(0xFF229ED9),
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            billing ? l10n.paywallLessonTitle : l10n.communityFullAccessTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Text(
            billing
                ? l10n.paywallLessonBody(EntitlementService.trialLessonCount)
                : l10n.paywallLessonBodyCommunity(EntitlementService.trialLessonCount),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, height: 1.5),
          ),
          if (billing) ...[
            const SizedBox(height: 8),
            Text(
              l10n.paywallTrialLessons,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.gold, fontSize: 12, height: 1.45),
            ),
          ],
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(billing ? l10n.unlockFullCourse : l10n.openCommunityCta),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    ),
  );

  if (goNext == true && context.mounted) {
    context.push('/premium');
  }
  return false;
}
