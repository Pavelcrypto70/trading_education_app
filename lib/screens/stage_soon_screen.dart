import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/club_service.dart';
import '../services/locale_service.dart';
import '../theme.dart';
import '../widgets/club_apply.dart';

/// Stages 5–6 run with a mentor in the pro chat; the app only explains the
/// entry conditions instead of showing a demo with someone else's data.
class StageSoonScreen extends StatefulWidget {
  const StageSoonScreen({super.key, required this.stage});

  final int stage;

  @override
  State<StageSoonScreen> createState() => _StageSoonScreenState();
}

class _StageSoonScreenState extends State<StageSoonScreen> {
  ClubStatus? _status;

  @override
  void initState() {
    super.initState();
    ClubService.status().then((s) {
      if (mounted) setState(() => _status = s);
    });
  }

  bool get _five => widget.stage == 5;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = _status;
    final title = _five ? l10n.stage5Title : l10n.stageGraduateClubTitle;
    final points = _five
        ? [
            l10n.stage5Point1,
            l10n.stage5Point2,
            l10n.stage5Point3,
            l10n.stage5Point4,
          ]
        : [
            l10n.stage6Point1,
            l10n.stage6Point2,
            l10n.stage6Point3,
          ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.stageNumberTitle(widget.stage))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.heroGradient(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.display(26, color: Colors.white)),
                const SizedBox(height: 6),
                Text(
                  _five ? l10n.stage5HeroBody : l10n.stage6HeroBody,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.92), height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(l10n.whatsInside, style: AppTheme.display(20)),
          const SizedBox(height: 10),
          for (final p in points)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 8, color: AppTheme.accent),
                  const SizedBox(width: 10),
                  Expanded(child: Text(p, style: const TextStyle(color: AppTheme.textSoft, height: 1.4))),
                ],
              ),
            ),
          const SizedBox(height: 14),
          Text(l10n.howToJoin, style: AppTheme.display(20)),
          const SizedBox(height: 10),
          if (s == null)
            const Center(child: CircularProgressIndicator())
          else
            for (final c in s.proChecks) CheckRow(check: c),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.go('/club?tab=chats'),
            child: Text(l10n.proChatAndTerms),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.go('/learning'),
            child: Text(l10n.backToLessons),
          ),
        ],
      ),
    );
  }
}
