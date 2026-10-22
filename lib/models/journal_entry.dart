class JournalEntry {
  final String id;
  final DateTime createdAt;
  final int? lessonId;
  final String? lessonTitle;
  final String pair;
  final String setup;
  final String entry;
  final String stop;
  final String target;
  final String emotion;
  final String notes;
  final String? result;
  /// Set by the simulator: stop | target | liquidation | manual. The learner never edits it.
  final String? closeReason;

  JournalEntry({
    required this.id,
    required this.createdAt,
    this.lessonId,
    this.lessonTitle,
    required this.pair,
    required this.setup,
    required this.entry,
    required this.stop,
    required this.target,
    required this.emotion,
    required this.notes,
    this.result,
    this.closeReason,
  });

  static const _simReasons = {'stop', 'target', 'liquidation', 'manual'};

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    var emotion = json['emotion'] as String? ?? '';
    var reason = json['closeReason'] as String?;
    // Entries saved before closeReason existed kept the code in «emotion».
    if (reason == null && _simReasons.contains(emotion)) {
      reason = emotion;
      emotion = '';
    }
    return JournalEntry(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lessonId: json['lessonId'] as int?,
      lessonTitle: json['lessonTitle'] as String?,
      pair: json['pair'] as String? ?? '',
      setup: json['setup'] as String? ?? '',
      entry: json['entry'] as String? ?? '',
      stop: json['stop'] as String? ?? '',
      target: json['target'] as String? ?? '',
      emotion: emotion,
      notes: json['notes'] as String? ?? '',
      result: json['result'] as String?,
      closeReason: reason,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        if (lessonId != null) 'lessonId': lessonId,
        if (lessonTitle != null) 'lessonTitle': lessonTitle,
        'pair': pair,
        'setup': setup,
        'entry': entry,
        'stop': stop,
        'target': target,
        'emotion': emotion,
        'notes': notes,
        if (result != null) 'result': result,
        if (closeReason != null) 'closeReason': closeReason,
      };
}
