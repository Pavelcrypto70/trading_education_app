enum LessonTextBlockKind {
  paragraph,
  analogy,
  warning,
  myth,
  compare,
  steps,
  quote,
}

class LessonTextBlock {
  final LessonTextBlockKind kind;
  final String? title;
  final String? body;
  final List<String> items;

  const LessonTextBlock({
    required this.kind,
    this.title,
    this.body,
    this.items = const [],
  });
}

/// Turns dense lesson prose into scannable UI blocks.
class LessonTextParser {
  static final _mythPattern = RegExp(
    r'Миф\s+(?:первый|второй|третий|четвёртый|четвертый|пятый|\d+)[^:]*:\s*',
    caseSensitive: false,
  );

  static List<LessonTextBlock> parse(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return const [];

    if (_mythPattern.hasMatch(trimmed)) {
      return _parseMyths(trimmed);
    }

    if (_looksLikeCompare(trimmed)) {
      return [LessonTextBlock(kind: LessonTextBlockKind.compare, body: trimmed)];
    }

    if (_looksLikeAnalogy(trimmed)) {
      return [LessonTextBlock(kind: LessonTextBlockKind.analogy, body: trimmed)];
    }

    if (_looksLikeWarning(trimmed)) {
      return [LessonTextBlock(kind: LessonTextBlockKind.warning, body: trimmed)];
    }

    final steps = _parseSteps(trimmed);
    if (steps.length >= 3) {
      return [LessonTextBlock(kind: LessonTextBlockKind.steps, items: steps)];
    }

    final sentences = _splitSentences(trimmed);
    if (sentences.length >= 4) {
      return [
        LessonTextBlock(kind: LessonTextBlockKind.quote, body: sentences.first),
        LessonTextBlock(
          kind: LessonTextBlockKind.paragraph,
          body: sentences.sublist(1).join(' '),
        ),
      ];
    }

    return [LessonTextBlock(kind: LessonTextBlockKind.paragraph, body: trimmed)];
  }

  static bool _looksLikeCompare(String t) {
    final lower = t.toLowerCase();
    return lower.contains(' vs ') ||
        lower.contains('сравнен') ||
        lower.contains('сведём в одну таблицу') ||
        (lower.contains('спот:') && lower.contains('фьючерс:'));
  }

  static bool _looksLikeAnalogy(String t) {
    final lower = t.toLowerCase();
    return lower.startsWith('представьте') ||
        lower.contains('как будто') ||
        lower.contains('аналогия:') ||
        lower.contains('это как ');
  }

  static bool _looksLikeWarning(String t) {
    final lower = t.toLowerCase();
    return lower.contains('ликвидац') ||
        lower.contains('мошенник') ||
        lower.contains('никому не давайте') ||
        lower.contains('не лезьте') ||
        lower.contains('опасн');
  }

  static List<LessonTextBlock> _parseMyths(String text) {
    final parts = text.split(_mythPattern);
    final matches = _mythPattern.allMatches(text).toList();
    if (matches.isEmpty || parts.length < 2) {
      return [LessonTextBlock(kind: LessonTextBlockKind.paragraph, body: text)];
    }

    final blocks = <LessonTextBlock>[];
    if (parts.first.trim().isNotEmpty) {
      blocks.add(LessonTextBlock(kind: LessonTextBlockKind.paragraph, body: parts.first.trim()));
    }

    for (var i = 0; i < matches.length; i++) {
      final label = matches[i].group(0)?.replaceAll(':', '').trim() ?? 'Миф';
      final content = i + 1 < parts.length ? parts[i + 1].trim() : '';
      if (content.isEmpty) continue;
      final dot = content.indexOf('. ');
      final myth = dot > 0 && dot < 120 ? content.substring(0, dot + 1) : content;
      blocks.add(LessonTextBlock(kind: LessonTextBlockKind.myth, title: label, body: myth));
    }
    return blocks;
  }

  static List<String> _parseSteps(String text) {
    final lines = text.split(RegExp(r'(?<=[.!?])\s+')).where((s) => s.trim().length > 12);
    final steps = <String>[];
    for (final line in lines) {
      if (RegExp(r'^(сначала|затем|потом|шаг|1\.|2\.|3\.)', caseSensitive: false).hasMatch(line.trim())) {
        steps.add(line.trim());
      }
    }
    return steps;
  }

  static List<String> _splitSentences(String text) {
    return text.split(RegExp(r'(?<=[.!?…])\s+')).where((s) => s.trim().length > 8).toList();
  }
}
