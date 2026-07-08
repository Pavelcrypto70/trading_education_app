import 'lesson_section.dart';

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
  final List<LessonSection> sections;

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
    this.sections = const [],
  });

  bool get hasRichContent => sections.isNotEmpty;

  factory Lesson.fromJson(Map<String, dynamic> json) {
    final sectionsJson = json['sections'] as List?;
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
      sections: sectionsJson != null
          ? sectionsJson
              .map((s) => LessonSection.fromJson(Map<String, dynamic>.from(s)))
              .toList()
          : const [],
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
      'sections': sections.map((s) => s.toJson()).toList(),
    };
  }
}
