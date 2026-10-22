import 'lesson_section.dart';
import 'lesson_reference.dart';

class Lesson {
  final int id;
  final String module;
  final String title;
  final String subtitle;
  final String difficulty;
  final int durationMin;
  final String outcome;
  final String content;
  final String takeaway;
  final List<int> prerequisites;
  final List<String> learningOutcomes;
  final List<LessonReference> references;
  final List<LessonSection> sections;
  /// Words this lesson explains for the first time (rebuilt course).
  final List<LessonTerm> newTerms;
  /// Trading pair used in every chart of the lesson.
  final String? pair;

  /// Rebuilt RU course format: explicit steps/charts, no runtime-generated content.
  bool get isCourseV2 => sections.any((s) => s.type == 'step');

  Lesson({
    required this.id,
    required this.module,
    required this.title,
    required this.subtitle,
    required this.difficulty,
    required this.durationMin,
    required this.outcome,
    required this.content,
    required this.takeaway,
    this.prerequisites = const [],
    this.learningOutcomes = const [],
    this.references = const [],
    this.sections = const [],
    this.newTerms = const [],
    this.pair,
  });

  bool get hasRichContent => sections.isNotEmpty;

  bool prerequisitesMet(Set<int> completedIds) =>
      prerequisites.every(completedIds.contains);

  factory Lesson.fromJson(Map<String, dynamic> json) {
    final sectionsJson = json['sections'] as List?;
    final refsJson = json['references'] as List?;
    return Lesson(
      id: json['id'] ?? 0,
      module: json['module'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      difficulty: json['difficulty'] ?? '',
      durationMin: json['durationMin'] ?? 0,
      outcome: json['outcome'] ?? '',
      content: json['content'] ?? '',
      takeaway: json['takeaway'] ?? '',
      prerequisites: (json['prerequisites'] as List?)?.cast<int>() ?? const [],
      learningOutcomes: (json['learningOutcomes'] as List?)?.cast<String>() ?? const [],
      references: refsJson != null
          ? refsJson
              .map((r) => LessonReference.fromJson(Map<String, dynamic>.from(r as Map)))
              .toList()
          : const [],
      sections: sectionsJson != null
          ? sectionsJson
              .map((s) => LessonSection.fromJson(Map<String, dynamic>.from(s)))
              .toList()
          : const [],
      newTerms: (json['newTerms'] as List?)
              ?.map((t) => LessonTerm.fromJson(Map<String, dynamic>.from(t as Map)))
              .toList() ??
          const [],
      pair: json['pair'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module': module,
      'title': title,
      'subtitle': subtitle,
      'difficulty': difficulty,
      'durationMin': durationMin,
      'outcome': outcome,
      'content': content,
      'takeaway': takeaway,
      'prerequisites': prerequisites,
      'learningOutcomes': learningOutcomes,
      'references': references.map((r) => {
            'title': r.title,
            'author': r.author,
            'year': r.year,
            'url': r.url,
            'type': r.type,
          }).toList(),
      'sections': sections.map((s) => s.toJson()).toList(),
      if (newTerms.isNotEmpty) 'newTerms': newTerms.map((t) => {'term': t.term, 'def': t.def}).toList(),
      if (pair != null) 'pair': pair,
    };
  }
}

class LessonTerm {
  final String term;
  final String def;

  const LessonTerm({required this.term, required this.def});

  factory LessonTerm.fromJson(Map<String, dynamic> json) =>
      LessonTerm(term: json['term'] as String? ?? '', def: json['def'] as String? ?? '');
}
