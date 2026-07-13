/// Splits long lesson paragraphs into mobile-friendly chunks.
class TextChunker {
  static const int defaultMaxChars = 200;

  static List<String> chunk(String text, {int maxChars = defaultMaxChars}) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return const [];
    if (trimmed.length <= maxChars) return [trimmed];

    final paragraphs = trimmed.split(RegExp(r'\n\s*\n')).where((p) => p.trim().isNotEmpty);
    final result = <String>[];
    for (final para in paragraphs) {
      result.addAll(_chunkParagraph(para.trim(), maxChars));
    }
    return result;
  }

  static List<String> _chunkParagraph(String para, int maxChars) {
    if (para.length <= maxChars) return [para];

    final sentences = para.split(RegExp(r'(?<=[.!?…])\s+')).where((s) => s.trim().isNotEmpty).toList();
    if (sentences.length <= 1) {
      return _splitByWords(para, maxChars);
    }

    final chunks = <String>[];
    var buffer = '';
    for (final sentence in sentences) {
      final next = buffer.isEmpty ? sentence : '$buffer $sentence';
      if (next.length <= maxChars) {
        buffer = next;
      } else {
        if (buffer.isNotEmpty) chunks.add(buffer.trim());
        if (sentence.length <= maxChars) {
          buffer = sentence;
        } else {
          chunks.addAll(_splitByWords(sentence, maxChars));
          buffer = '';
        }
      }
    }
    if (buffer.isNotEmpty) chunks.add(buffer.trim());
    return chunks;
  }

  static List<String> _splitByWords(String text, int maxChars) {
    final words = text.split(RegExp(r'\s+'));
    final chunks = <String>[];
    var buffer = '';
    for (final word in words) {
      final next = buffer.isEmpty ? word : '$buffer $word';
      if (next.length <= maxChars) {
        buffer = next;
      } else {
        if (buffer.isNotEmpty) chunks.add(buffer);
        buffer = word;
      }
    }
    if (buffer.isNotEmpty) chunks.add(buffer);
    return chunks;
  }
}
