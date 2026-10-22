import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/desk_key_config.dart';
import '../services/locale_service.dart';
import '../theme.dart';

/// Legacy route target — billing removed. Prefer router redirect away from /premium.
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.premiumMember)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.school_outlined, size: 48, color: AppTheme.gold),
            const SizedBox(height: 16),
            Text(
              l10n.courseFreeSupportBody,
              textAlign: TextAlign.center,
              style: const TextStyle(height: 1.45),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/learning'),
              child: Text(l10n.toLessonsBtn),
            ),
            if (DeskKeyConfig.enabled) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/soft-ref'),
                child: Text(l10n.softRefCtaPrimary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
