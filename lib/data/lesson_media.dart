/// Curated educational videos per module (Binance Academy / public sources).
class LessonMediaEntry {
  final String title;
  final String url;
  final String thumbnail;

  const LessonMediaEntry({
    required this.title,
    required this.url,
    required this.thumbnail,
  });
}

class LessonMedia {
  static const _byModule = <String, LessonMediaEntry>{
    'intro': LessonMediaEntry(
      title: 'What is cryptocurrency?',
      url: 'https://www.youtube.com/watch?v=1YyAzVmP9xQ',
      thumbnail: 'https://img.youtube.com/vi/1YyAzVmP9xQ/hqdefault.jpg',
    ),
    'chart': LessonMediaEntry(
      title: 'Candlestick charts explained',
      url: 'https://www.youtube.com/watch?v=ew1L6UqNi9s',
      thumbnail: 'https://img.youtube.com/vi/ew1L6UqNi9s/hqdefault.jpg',
    ),
    'patterns': LessonMediaEntry(
      title: 'Chart patterns for beginners',
      url: 'https://www.youtube.com/watch?v=UkiqyF0n9XQ',
      thumbnail: 'https://img.youtube.com/vi/UkiqyF0n9XQ/hqdefault.jpg',
    ),
    'strategy': LessonMediaEntry(
      title: 'Risk management in trading',
      url: 'https://www.youtube.com/watch?v=iwGFal8G04M',
      thumbnail: 'https://img.youtube.com/vi/iwGFal8G04M/hqdefault.jpg',
    ),
    'risk': LessonMediaEntry(
      title: 'Position sizing basics',
      url: 'https://www.youtube.com/watch?v=b5Y5X1tTqJo',
      thumbnail: 'https://img.youtube.com/vi/b5Y5X1tTqJo/hqdefault.jpg',
    ),
    'market': LessonMediaEntry(
      title: 'Bitcoin market cycles',
      url: 'https://www.youtube.com/watch?v=41JCpzvnn_0',
      thumbnail: 'https://img.youtube.com/vi/41JCpzvnn_0/hqdefault.jpg',
    ),
    'practice': LessonMediaEntry(
      title: 'How to journal your trades',
      url: 'https://www.youtube.com/watch?v=4Zl5-4u3QBM',
      thumbnail: 'https://img.youtube.com/vi/4Zl5-4u3QBM/hqdefault.jpg',
    ),
  };

  static LessonMediaEntry? forModule(String module) {
    final key = _normalizeModule(module);
    return _byModule[key];
  }

  static String _normalizeModule(String module) {
    final m = module.toLowerCase();
    if (m.contains('введ') || m.contains('intro') || m.contains('fund')) return 'intro';
    if (m.contains('график') || m.contains('chart') || m.contains('gráf') || m.contains('estrut')) return 'chart';
    if (m.contains('паттерн') || m.contains('pattern') || m.contains('padr')) return 'patterns';
    if (m.contains('стратег') || m.contains('strateg')) return 'strategy';
    if (m.contains('риск') || m.contains('risk') || m.contains('risco') || m.contains('этик')) return 'risk';
    if (m.contains('рынок') || m.contains('market') || m.contains('mercado') || m.contains('макро')) return 'market';
    if (m.contains('практ') || m.contains('practice') || m.contains('prát') || m.contains('аттест')) return 'practice';
    return m;
  }

  static LessonMediaEntry? forLesson(int lessonId, String module) {
    return forModule(module);
  }
}
