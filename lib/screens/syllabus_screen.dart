import 'package:flutter/material.dart';

import '../data/syllabus_repository.dart';
import '../services/locale_service.dart';
import '../theme.dart';
import '../utils/num_format.dart';

class SyllabusScreen extends StatelessWidget {
  const SyllabusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = LocaleService.instance.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.syllabusTitle)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: SyllabusRepository.load(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snap.data!;
          final modules = data['modules'] as List;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                SyllabusRepository.text(data['course'] as Map<String, dynamic>?, lang),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.syllabusHoursLessons(data['totalHours'] as num, data['totalLessons'] as int),
                style: const TextStyle(color: AppTheme.muted),
              ),
              const SizedBox(height: 8),
              Text(
                SyllabusRepository.text(data['finalAssessment'] as Map<String, dynamic>?, lang),
                style: const TextStyle(height: 1.5, color: AppTheme.textSoft),
              ),
              const SizedBox(height: 20),
              ...modules.map((m) {
                final mod = Map<String, dynamic>.from(m as Map);
                final outcomes = (mod['outcomes'] as Map)[lang] as List? ?? [];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppTheme.cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${mod['order']}. ${SyllabusRepository.text(mod['title'] as Map<String, dynamic>?, lang)}',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                        Text(
                          l10n.syllabusModuleMeta(
                            fmtNum((mod['hours'] as num).toDouble(), 1),
                            (mod['lessonIds'] as List).first,
                            (mod['lessonIds'] as List).last,
                          ),
                          style: const TextStyle(color: AppTheme.gold, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        ...outcomes.map(
                          (o) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text('• $o', style: const TextStyle(color: AppTheme.textSoft, height: 1.4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
