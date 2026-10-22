import '../data/lessons_repository.dart';
import '../models/lesson.dart';
import '../models/lesson_section.dart';
import 'locale_service.dart';

/// Simulator task for a lesson. In the rebuilt course it comes straight from the
/// lesson's `practice` section (authored and validated in tools/course).
class PracticeBrief {
  final String ideaTitle;
  final String idea;
  final List<String> steps;
  final String howToFinish;
  final double minRiskReward;
  final String direction;
  /// Short reminders of words (legacy courses only; the RU course explains them in lessons).
  final List<(String, String)> terms;

  const PracticeBrief({
    required this.ideaTitle,
    required this.idea,
    required this.steps,
    required this.howToFinish,
    this.minRiskReward = 0,
    this.direction = 'long',
    this.terms = const [],
  });
}

class PracticeBriefService {
  PracticeBriefService._();

  static LessonSection? practiceSection(Lesson lesson) {
    for (final s in lesson.sections) {
      if (s.type == 'practice') return s;
    }
    return null;
  }

  static PracticeBrief? fromLesson(Lesson lesson) {
    final s = practiceSection(lesson);
    if (s == null || !lesson.isCourseV2) return null;
    final l10n = LocaleService.instance.strings;
    return PracticeBrief(
      ideaTitle: l10n.lessonTitleWithId(lesson.id, lesson.title),
      idea: s.body ?? '',
      steps: s.items ?? const [],
      howToFinish: s.finish ?? '',
      minRiskReward: s.minRiskReward ?? 0,
      direction: s.direction ?? 'long',
    );
  }

  static Future<PracticeBrief> load(int lessonId) async {
    final lesson = await LessonsRepository().getLessonById(lessonId);
    if (lesson != null) {
      final b = fromLesson(lesson);
      if (b != null) return b;
      return forLesson(lessonId: lesson.id, lessonTitle: lesson.title, takeaway: lesson.takeaway);
    }
    return free();
  }

  /// Free practice without a lesson.
  static PracticeBrief free() {
    final l10n = LocaleService.instance.strings;
    return PracticeBrief(
      ideaTitle: l10n.freePracticeTitle,
      idea: l10n.freePracticeIdea,
      steps: [
        l10n.freePracticeStep1,
        l10n.freePracticeStep2,
        l10n.freePracticeStep3,
        l10n.freePracticeStep4,
      ],
      howToFinish: l10n.freePracticeHowToFinish,
    );
  }

  /// Legacy courses (EN/ES/PT) without authored practice sections.
  static PracticeBrief forLesson({
    required int lessonId,
    required String lessonTitle,
    required String takeaway,
    String? sectionBody,
  }) {
    final l10n = LocaleService.instance.strings;
    return PracticeBrief(
      ideaTitle: l10n.lessonTitleWithId(lessonId, lessonTitle),
      idea: sectionBody?.isNotEmpty == true ? sectionBody! : takeaway,
      steps: [
        l10n.legacyPracticeStep1,
        l10n.legacyPracticeStep2,
        l10n.legacyPracticeStep3,
        l10n.legacyPracticeStep4,
      ],
      howToFinish: l10n.freePracticeHowToFinish,
    );
  }
}
