import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/lessons_repository.dart';
import '../data/syllabus_repository.dart';
import '../services/locale_service.dart';
import '../services/progress_service.dart';
import '../theme.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  String _verificationHash(Set<int> completed, int total, String version) {
    final ids = completed.toList()..sort();
    final payload = 'TM|$version|$total|${ids.join(',')}';
    final digest = sha256.convert(utf8.encode(payload));
    return digest.toString().substring(0, 16).toUpperCase();
  }

  Future<String> _buildReport(Set<int> completed, int total, String hash, String version) async {
    final syllabus = await SyllabusRepository.load();
    final lang = LocaleService.instance.languageCode;
    final course = SyllabusRepository.text(syllabus['course'] as Map<String, dynamic>?, lang);
    final ids = completed.toList()..sort();
    return 'Trade Master — $course\n'
        'Syllabus v$version\n'
        'Completed: ${completed.length}/$total lessons\n'
        'Verification: TM-$hash\n'
        'Date: ${DateTime.now().toIso8601String().substring(0, 10)}\n\n'
        'Completed lesson IDs: $ids';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.certificateTitle)),
      body: FutureBuilder<({Set<int> completed, int total, String version})>(
        future: () async {
          final completed = await ProgressService.getCompletedLessons();
          final lessons = await LessonsRepository().loadLessons();
          final syllabus = await SyllabusRepository.load();
          return (
            completed: completed,
            total: lessons.length,
            version: syllabus['version']?.toString() ?? '1',
          );
        }(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final completed = snap.data!.completed;
          final total = snap.data!.total;
          final version = snap.data!.version;
          final pct = total == 0 ? 0 : (completed.length / total * 100).round();
          final ready = pct >= 70;
          final hash = _verificationHash(completed, total, version);

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: AppTheme.heroGradient(),
                  child: Column(
                    children: [
                      Icon(
                        ready ? Icons.verified : Icons.school_outlined,
                        size: 56,
                        color: AppTheme.gold,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$pct%',
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppTheme.gold),
                      ),
                      Text(
                        l10n.completedCount(completed.length, total),
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${l10n.certificateHash}: TM-$hash',
                        style: const TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'monospace'),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: 'TM-$hash'));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.copyHash)),
                        );
                      }
                    },
                    icon: const Icon(Icons.fingerprint),
                    label: Text(l10n.copyHash),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final text = await _buildReport(completed, total, hash, version);
                      await Clipboard.setData(ClipboardData(text: text));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.exportCertificate)),
                        );
                      }
                    },
                    icon: const Icon(Icons.copy),
                    label: Text(l10n.exportCertificate),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
