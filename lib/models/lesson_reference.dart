class LessonReference {
  final String title;
  final String author;
  final int? year;
  final String url;
  final String type;

  const LessonReference({
    required this.title,
    required this.author,
    this.year,
    required this.url,
    this.type = 'article',
  });

  factory LessonReference.fromJson(Map<String, dynamic> json) {
    return LessonReference(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      year: json['year'] as int?,
      url: json['url'] ?? '',
      type: json['type'] ?? 'article',
    );
  }
}
