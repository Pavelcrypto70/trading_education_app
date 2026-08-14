import 'package:flutter_test/flutter_test.dart';
import 'package:trading_education_app/services/certificate_service.dart';

void main() {
  test('verification hash is stable and 16 hex chars', () {
    final a = CertificateService.verificationHash(
      completed: {1, 3, 2},
      total: 58,
      version: '1',
      holderName: 'Pavel',
      issuedAt: '2026-08-14',
    );
    final b = CertificateService.verificationHash(
      completed: {3, 1, 2},
      total: 58,
      version: '1',
      holderName: 'Pavel',
      issuedAt: '2026-08-14',
    );
    expect(a, b);
    expect(a.length, 16);
    expect(a, equals(a.toUpperCase()));
  });

  test('hash changes with holder name', () {
    final a = CertificateService.verificationHash(
      completed: {1},
      total: 1,
      version: '1',
      holderName: 'Ada',
      issuedAt: '2026-08-14',
    );
    final b = CertificateService.verificationHash(
      completed: {1},
      total: 1,
      version: '1',
      holderName: 'Bob',
      issuedAt: '2026-08-14',
    );
    expect(a, isNot(b));
  });

  test('isReady requires lessons, modules, journal and homework', () {
    CertificateStatus status({
      bool lessons = true,
      bool journal = true,
      bool modules = true,
      bool homework = true,
    }) {
      return CertificateStatus(
        completedLessons: 58,
        totalLessons: 58,
        lessonPercent: 100,
        journalEntries: 3,
        modulesPassed: 7,
        totalModules: 7,
        homeworkLessons: 3,
        lessonsOk: lessons,
        journalOk: journal,
        modulesOk: modules,
        homeworkOk: homework,
      );
    }

    expect(status().isReady, isTrue);
    expect(status(lessons: false).isReady, isFalse);
    expect(status(journal: false).isReady, isFalse);
    expect(status(modules: false).isReady, isFalse);
    expect(status(homework: false).isReady, isFalse);
  });

  test('issued certificate json roundtrip', () {
    const cert = IssuedCertificate(
      holderName: 'Pavel',
      issuedAt: '2026-08-14',
      hash: 'ABCD1234EFGH5678',
      version: '1',
      completedLessons: 58,
      totalLessons: 58,
    );
    final copy = IssuedCertificate.fromJson(cert.toJson());
    expect(copy.holderName, 'Pavel');
    expect(copy.hash, cert.hash);
    expect(copy.completedLessons, 58);
  });

  test('share text includes verification id', () {
    const cert = IssuedCertificate(
      holderName: 'Pavel',
      issuedAt: '2026-08-14',
      hash: 'ABCD1234EFGH5678',
      version: '1',
      completedLessons: 58,
      totalLessons: 58,
    );
    final text = CertificateService.shareText(
      cert: cert,
      courseName: 'Trade Master',
    );
    expect(text, contains('TM-ABCD1234EFGH5678'));
    expect(text, contains('Pavel'));
  });

  test('certificate bar is full course not 70 percent', () {
    expect(CertificateService.minLessonPercent, 100);
    expect(CertificateService.minJournalEntries, 3);
    expect(CertificateService.minHomeworkLessons, 3);
  });
}
