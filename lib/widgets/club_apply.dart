import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/club_service.dart';
import '../services/locale_service.dart';
import '../theme.dart';

/// One cutoff condition; an open one leads to where it can be closed.
class CheckRow extends StatelessWidget {
  const CheckRow({super.key, required this.check});

  final CutoffCheck check;

  @override
  Widget build(BuildContext context) {
    final c = check;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: c.done ? null : () => context.push(c.route),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(
              c.done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              size: 20,
              color: c.done ? AppTheme.ok : AppTheme.faint,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                c.label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: c.done ? AppTheme.text : AppTheme.textSoft,
                ),
              ),
            ),
            Text(c.detail, style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
            if (!c.done) const Icon(Icons.chevron_right_rounded, size: 18, color: AppTheme.faint),
          ],
        ),
      ),
    );
  }
}

/// Copies the application text and explains the next step before opening the club.
Future<void> applyToClubChat(BuildContext context, ClubStatus s, ClubChat chat) async {
  final l10n = context.l10n;
  final text = ClubService.application(s, chat);
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) return;
  final open = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.applyCopiedTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: AppTheme.cardDecoration(color: AppTheme.surface2),
            child: SelectableText(text, style: const TextStyle(fontSize: 13, height: 1.4)),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.applyCopiedBody,
            style: const TextStyle(color: AppTheme.textSoft, height: 1.45),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.laterBtn)),
        ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.openClubBtn)),
      ],
    ),
  );
  if (open == true) {
    await launchUrl(Uri.parse(ClubService.clubUrl), mode: LaunchMode.externalApplication);
  }
}
