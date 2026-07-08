class LessonQuizQuestion {
  final int lessonId;
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const LessonQuizQuestion({
    required this.lessonId,
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory LessonQuizQuestion.fromJson(Map<String, dynamic> json, String lang) {
    final q = json['question'] as Map<String, dynamic>? ?? {};
    final o = json['options'] as Map<String, dynamic>? ?? {};
    final e = json['explanation'] as Map<String, dynamic>? ?? {};
    return LessonQuizQuestion(
      lessonId: json['lessonId'] as int,
      id: json['id'] as String,
      question: (q[lang] ?? q['en'] ?? '') as String,
      options: List<String>.from(o[lang] ?? o['en'] ?? const []),
      correctIndex: json['correctIndex'] as int? ?? 0,
      explanation: (e[lang] ?? e['en'] ?? '') as String,
    );
  }
}
