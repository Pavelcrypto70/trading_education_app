import 'package:flutter/material.dart';

import '../theme.dart';

/// Soft accent card (70% brand / 30% infographic ref — no neon glow).
class AccentCard extends StatelessWidget {
  final Color accent;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final List<String> tags;

  const AccentCard({
    super.key,
    required this.accent,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.tags = const [],
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      padding: padding,
      decoration: AppTheme.accentCardDecoration(accent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tags.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags
                  .map(
                    (t) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: accent.withValues(alpha: 0.35)),
                      ),
                      child: Text(
                        t.toUpperCase(),
                        style: TextStyle(
                          color: accent,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
          ],
          child,
        ],
      ),
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: content,
      ),
    );
  }
}
