import 'package:flutter/material.dart';

import '../services/locale_service.dart';
import '../theme.dart';
import '../utils/lesson_text_parser.dart';

class LessonRichText extends StatelessWidget {
  final String text;

  const LessonRichText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final blocks = LessonTextParser.parse(text);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < blocks.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _BlockView(block: blocks[i]),
        ],
      ],
    );
  }
}

class _BlockView extends StatelessWidget {
  final LessonTextBlock block;

  const _BlockView({required this.block});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    switch (block.kind) {
      case LessonTextBlockKind.quote:
        return _QuoteCard(text: block.body ?? '');
      case LessonTextBlockKind.analogy:
        return _CalloutCard(
          icon: Icons.lightbulb_outline,
          color: AppTheme.gold,
          label: l10n.textBlockAnalogy,
          text: block.body ?? '',
        );
      case LessonTextBlockKind.warning:
        return _CalloutCard(
          icon: Icons.warning_amber_rounded,
          color: Colors.orangeAccent,
          label: l10n.textBlockWarning,
          text: block.body ?? '',
        );
      case LessonTextBlockKind.compare:
        return _CompareCard(text: block.body ?? '');
      case LessonTextBlockKind.myth:
        return _MythCard(title: block.title ?? l10n.textBlockMyth, text: block.body ?? '');
      case LessonTextBlockKind.steps:
        return _StepsCard(items: block.items);
      case LessonTextBlockKind.paragraph:
        return Text(
          block.body ?? '',
          style: const TextStyle(height: 1.65, color: Colors.white70, fontSize: 15),
        );
    }
  }
}

class _QuoteCard extends StatelessWidget {
  final String text;
  const _QuoteCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: AppTheme.gold, width: 3)),
        color: AppTheme.gold.withValues(alpha: 0.08),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.45,
          color: Colors.white,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _CalloutCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String text;

  const _CalloutCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(height: 1.6, color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }
}

class _MythCard extends StatelessWidget {
  final String title;
  final String text;

  const _MythCard({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: AppTheme.cardDecoration(color: Colors.redAccent.withValues(alpha: 0.06)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.redAccent, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.redAccent)),
                const SizedBox(height: 4),
                Text(text, style: const TextStyle(height: 1.5, color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareCard extends StatelessWidget {
  final String text;

  const _CompareCard({required this.text});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final parts = text.split(RegExp(r'\.\s+'));
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration(color: Colors.blue.withValues(alpha: 0.06)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.compare_arrows, color: Colors.lightBlueAccent, size: 18),
              const SizedBox(width: 8),
              Text(l10n.textBlockCompare, style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.lightBlueAccent, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          ...parts.where((p) => p.trim().isNotEmpty).map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.w700)),
                      Expanded(child: Text(p.trim(), style: const TextStyle(height: 1.5, color: Colors.white70, fontSize: 13))),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _StepsCard extends StatelessWidget {
  final List<String> items;

  const _StepsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.textBlockSteps, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppTheme.accent)),
          const SizedBox(height: 10),
          ...items.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Text('${e.key + 1}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.accent)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(e.value, style: const TextStyle(height: 1.45, color: Colors.white70, fontSize: 13))),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
