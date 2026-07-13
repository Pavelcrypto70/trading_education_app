import 'package:flutter/material.dart';

import '../services/locale_service.dart';
import '../theme.dart';
import '../utils/external_link.dart';

class LessonVideoCard extends StatelessWidget {
  final String title;
  final String url;
  final String thumbnailUrl;

  const LessonVideoCard({
    super.key,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  Future<void> _open(BuildContext context) async {
    final ok = await openExternalLink(url);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${context.l10n.videoOpenError}\n$url'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'YouTube',
            onPressed: () => openExternalLink(url),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _open(context),
        child: Container(
          decoration: AppTheme.cardDecoration(
            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.35)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    thumbnailUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 160,
                      color: Colors.black26,
                      child: const Icon(Icons.play_circle_outline, size: 48, color: Colors.white38),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.ondemand_video, color: Colors.redAccent, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.watchVideo, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                        ),
                        const Icon(Icons.open_in_new, size: 16, color: Colors.white38),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.videoOpensYouTube,
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
