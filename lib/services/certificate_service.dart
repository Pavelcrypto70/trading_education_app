import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/module_quiz_repository.dart';
import 'auth_service.dart';
import 'gamification_service.dart';
import 'journal_service.dart';
import 'progress_service.dart';
import 'sync_service.dart';

/// Requirements and issued-certificate persistence.
class CertificateService {
  CertificateService._();

  static const minLessonPercent = 100;
  static const minJournalEntries = 3;
  static const minHomeworkLessons = 3;
  static const xpOnIssue = 200;
  static const _issuedKey = 'certificateIssued';

  static String verificationHash({
    required Set<int> completed,
    required int total,
    required String version,
    required String holderName,
    required String issuedAt,
  }) {
    final ids = completed.toList()..sort();
    final payload =
        'TM|$version|$total|${ids.join(',')}|${holderName.trim().toLowerCase()}|$issuedAt';
    final digest = sha256.convert(utf8.encode(payload));
    return digest.toString().substring(0, 16).toUpperCase();
  }

  static Future<CertificateStatus> evaluate(int totalLessons) async {
    final completed = await ProgressService.getCompletedLessons();
    final journal = await JournalService.getCount();
    final modules = await ProgressService.getModuleResults();
    final homeworkLessons = await ProgressService.getHomeworkLessonsSubmitted();

    var totalModules = 0;
    try {
      totalModules = (await ModuleQuizRepository.loadModules()).length;
    } catch (_) {}

    final lessonPct =
        totalLessons == 0 ? 0 : (completed.length / totalLessons * 100).round();
    final modulesPassed = modules.length;

    return CertificateStatus(
      completedLessons: completed.length,
      totalLessons: totalLessons,
      lessonPercent: lessonPct,
      journalEntries: journal,
      modulesPassed: modulesPassed,
      totalModules: totalModules,
      homeworkLessons: homeworkLessons,
      lessonsOk: totalLessons > 0 && completed.length >= totalLessons,
      journalOk: journal >= minJournalEntries,
      modulesOk: totalModules == 0 || modulesPassed >= totalModules,
      homeworkOk: homeworkLessons >= minHomeworkLessons,
    );
  }

  static Future<IssuedCertificate?> loadIssued() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_issuedKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return IssuedCertificate.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<String> suggestedHolderName() async {
    final name = (await AuthService.getDisplayName())?.trim();
    if (name != null && name.isNotEmpty) return name;
    final email = (await AuthService.getEmail())?.trim();
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
    return '';
  }

  /// Issues once requirements are met. Returns null if not ready.
  static Future<IssuedCertificate?> issue({
    required String holderName,
    required Set<int> completed,
    required int totalLessons,
    required String version,
  }) async {
    final status = await evaluate(totalLessons);
    if (!status.isReady) return null;
    final name = holderName.trim();
    if (name.length < 2) return null;

    final existing = await loadIssued();
    final issuedAt = DateTime.now().toIso8601String().substring(0, 10);
    final hash = verificationHash(
      completed: completed,
      total: totalLessons,
      version: version,
      holderName: name,
      issuedAt: issuedAt,
    );
    final cert = IssuedCertificate(
      holderName: name,
      issuedAt: issuedAt,
      hash: hash,
      version: version,
      completedLessons: completed.length,
      totalLessons: totalLessons,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_issuedKey, jsonEncode(cert.toJson()));
    if (existing == null) {
      await GamificationService.award(PointsReason.exam, uniqueKey: 'exam-diploma');
    }
    SyncService.schedulePush();
    return cert;
  }

  static String shareText({
    required IssuedCertificate cert,
    required String courseName,
  }) {
    return 'Trade Master — $courseName\n'
        'Syllabus v${cert.version}\n'
        'Issued to: ${cert.holderName}\n'
        'Date: ${cert.issuedAt}\n'
        'Completed: ${cert.completedLessons}/${cert.totalLessons} lessons\n'
        'Verification: TM-${cert.hash}\n'
        'Education only. Not financial advice.';
  }
}

class CertificateStatus {
  final int completedLessons;
  final int totalLessons;
  final int lessonPercent;
  final int journalEntries;
  final int modulesPassed;
  final int totalModules;
  final int homeworkLessons;
  final bool lessonsOk;
  final bool journalOk;
  final bool modulesOk;
  final bool homeworkOk;

  const CertificateStatus({
    required this.completedLessons,
    required this.totalLessons,
    required this.lessonPercent,
    required this.journalEntries,
    required this.modulesPassed,
    required this.totalModules,
    required this.homeworkLessons,
    required this.lessonsOk,
    required this.journalOk,
    required this.modulesOk,
    required this.homeworkOk,
  });

  bool get isReady => lessonsOk && journalOk && modulesOk && homeworkOk;
}

class IssuedCertificate {
  final String holderName;
  final String issuedAt;
  final String hash;
  final String version;
  final int completedLessons;
  final int totalLessons;

  const IssuedCertificate({
    required this.holderName,
    required this.issuedAt,
    required this.hash,
    required this.version,
    required this.completedLessons,
    required this.totalLessons,
  });

  Map<String, dynamic> toJson() => {
        'holderName': holderName,
        'issuedAt': issuedAt,
        'hash': hash,
        'version': version,
        'completedLessons': completedLessons,
        'totalLessons': totalLessons,
      };

  factory IssuedCertificate.fromJson(Map<String, dynamic> json) {
    return IssuedCertificate(
      holderName: json['holderName'] as String? ?? '',
      issuedAt: json['issuedAt'] as String? ?? '',
      hash: json['hash'] as String? ?? '',
      version: json['version'] as String? ?? '1',
      completedLessons: json['completedLessons'] as int? ?? 0,
      totalLessons: json['totalLessons'] as int? ?? 0,
    );
  }
}
