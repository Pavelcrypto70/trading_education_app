import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/case_studies_repository.dart';
import '../services/locale_service.dart';
import '../theme.dart';

class LessonCaseStudiesCard extends StatelessWidget {
  final int lessonId;

  const LessonCaseStudiesCard({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FutureBuilder<List<CaseStudy>>(
      future: CaseStudiesRepository.forLesson(lessonId),
      builder: (context, snap) {
        final cases = snap.data ?? [];
        if (cases.isEmpty) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: AppTheme.cardDecoration(
            color: Colors.orange.withValues(alpha: 0.07),
            border: Border.all(color: Colors.orange.withValues(alpha: 0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.history_edu, color: Colors.orangeAccent, size: 20),
                  const SizedBox(width: 8),
                  Text(l10n.caseStudies, style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.orangeAccent)),
                ],
              ),
              const SizedBox(height: 12),
              ...cases.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        if (c.date.isNotEmpty)
                          Text(c.date, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                        const SizedBox(height: 6),
                        Text(c.summary, style: const TextStyle(color: Colors.white70, height: 1.5, fontSize: 13)),
                        if (c.sourceUrl != null) ...[
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () async {
                              final uri = Uri.parse(c.sourceUrl!);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                            icon: const Icon(Icons.open_in_new, size: 14),
                            label: Text(c.sourceTitle ?? 'Source', style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ],
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
