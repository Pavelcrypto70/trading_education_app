class QuizQuestion {
  final String category;
  final String difficulty;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final int? lessonId;
  final bool showChart;
  final String? sourceId;

  const QuizQuestion({
    required this.category,
    required this.difficulty,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.lessonId,
    this.showChart = false,
    this.sourceId,
  });
}