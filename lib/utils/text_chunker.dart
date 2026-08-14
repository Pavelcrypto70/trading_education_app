/// Splits long lesson paragraphs into mobile-friendly chunks.
/// Deduplicates repeated blocks and packs short paragraphs together.
class TextChunker {
  static const int defaultMaxChars = 520;

  static List<String> chunk(String text, {int maxChars = defaultMaxChars}) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return const [];

    final paragraphs = _uniqueParagraphs(trimmed);
    if (paragraphs.isEmpty) return const [];

    final packed = <String>[];
    var buffer = '';
    for (final para in paragraphs) {
      if (para.length > maxChars) {
        if (buffer.isNotEmpty) {
          packed.add(buffer);
          buffer = '';
        }
        packed.addAll(_chunkParagraph(para, maxChars));
        continue;
      }
      final next = buffer.isEmpty ? para : '$buffer\n\n$para';
      if (next.length <= maxChars) {
        buffer = next;
      } else {
        if (buffer.isNotEmpty) packed.add(buffer);
        buffer = para;
      }
    }
    if (buffer.isNotEmpty) packed.add(buffer);
    return _uniqueChunks(packed);
  }

  static List<String> _uniqueParagraphs(String text) {
    final parts = text.split(RegExp(r'\n\s*\n')).where((p) => p.trim().isNotEmpty);
    final out = <String>[];
    final seen = <String>{};
    for (final p in parts) {
      final key = p.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
      if (seen.contains(key)) continue;
      seen.add(key);
      out.add(p.trim());
    }
    return out;
  }

  static List<String> _uniqueChunks(List<String> chunks) {
    final out = <String>[];
    final seen = <String>{};
    for (final c in chunks) {
      final key = c.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
      if (seen.contains(key)) continue;
      seen.add(key);
      out.add(c);
    }
    return out;
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
