import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/locale_service.dart';
import '../theme.dart';
import '../utils/external_link.dart';
import '../utils/youtube_url.dart';
import 'youtube_embed.dart';

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

  void _openNow(BuildContext context) {
    final ok = openExternalLinkNow(url);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${context.l10n.videoOpenError}\n$url'),
          duration: const Duration(seconds: 8),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final videoId = youtubeVideoIdFromUrl(url);
    final showEmbed = kIsWeb && videoId != null;

    return Container(
      decoration: AppTheme.cardDecoration(
        border: Border.all(color: AppTheme.bear.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showEmbed)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final height = width * 9 / 16;
                  return SizedBox(
                    width: width,
                    height: height,
                    child: YoutubeEmbed(videoId: videoId),
                  );
                },
              ),
            )
          else
            _ThumbnailPreview(
              thumbnailUrl: thumbnailUrl,
              onTap: () => _openNow(context),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.ondemand_video, color: AppTheme.bear, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.watchVideo, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                          Text(title, style: const TextStyle(color: AppTheme.textSoft, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (showEmbed)
                  Text(
                    l10n.videoPlaysInline,
                    style: const TextStyle(color: AppTheme.faint, fontSize: 11),
                  )
                else
                  Text(
                    l10n.videoOpensYouTube,
                    style: const TextStyle(color: AppTheme.faint, fontSize: 11),
                  ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _openNow(context),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: Text(l10n.openInYouTube),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.bear,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(height: 6),
                SelectableText(
                  url,
                  style: const TextStyle(
                    color: AppTheme.bear,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThumbnailPreview extends StatelessWidget {
  final String thumbnailUrl;
  final VoidCallback onTap;

  const _ThumbnailPreview({
    required this.thumbnailUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Stack(
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
                child: const Icon(Icons.play_circle_outline, size: 48, color: AppTheme.faint),
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
      ),
    );
  }
}
