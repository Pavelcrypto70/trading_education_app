import '../services/locale_service.dart';

/// Curated educational videos per module.
class LessonMediaEntry {
  final String titleRu;
  final String titleEn;
  final String titlePt;
  final String url;
  final String thumbnail;

  const LessonMediaEntry({
    required this.titleRu,
    required this.titleEn,
    required this.titlePt,
    required this.url,
    required this.thumbnail,
  });

  String titleFor(String lang) {
    switch (lang) {
      case 'ru':
        return titleRu;
      case 'pt':
        return titlePt;
      default:
        return titleEn;
    }
  }
}

class LessonMedia {
  static const _byModule = <String, LessonMediaEntry>{
    'intro': LessonMediaEntry(
      titleRu: 'Криптовалюта за 5 минут (Simplilearn)',
      titleEn: 'Cryptocurrency in 5 minutes (Simplilearn)',
      titlePt: 'Criptomoeda em 5 minutos (Simplilearn)',
      url: 'https://www.youtube.com/watch?v=1YyAzVmP9xQ',
      thumbnail: 'https://img.youtube.com/vi/1YyAzVmP9xQ/hqdefault.jpg',
    ),
    'chart': LessonMediaEntry(
      titleRu: 'Свечные графики для начинающих',
      titleEn: 'Candlestick charts explained',
      titlePt: 'Gráficos de velas explicados',
      url: 'https://www.youtube.com/watch?v=ew1L6UqNi9s',
      thumbnail: 'https://img.youtube.com/vi/ew1L6UqNi9s/hqdefault.jpg',
    ),
    'patterns': LessonMediaEntry(
      titleRu: 'Графические паттерны',
      titleEn: 'Chart patterns for beginners',
      titlePt: 'Padrões de gráfico para iniciantes',
      url: 'https://www.youtube.com/watch?v=UkiqyF0n9XQ',
      thumbnail: 'https://img.youtube.com/vi/UkiqyF0n9XQ/hqdefault.jpg',
    ),
    'strategy': LessonMediaEntry(
      titleRu: 'Риск-менеджмент в трейдинге',
      titleEn: 'Risk management in trading',
      titlePt: 'Gestão de risco no trading',
      url: 'https://www.youtube.com/watch?v=iwGFal8G04M',
      thumbnail: 'https://img.youtube.com/vi/iwGFal8G04M/hqdefault.jpg',
    ),
    'risk': LessonMediaEntry(
      titleRu: 'Размер позиции и риск',
      titleEn: 'Position sizing basics',
      titlePt: 'Tamanho de posição e risco',
      url: 'https://www.youtube.com/watch?v=b5Y5X1tTqJo',
      thumbnail: 'https://img.youtube.com/vi/b5Y5X1tTqJo/hqdefault.jpg',
    ),
    'market': LessonMediaEntry(
      titleRu: 'Циклы рынка Bitcoin',
      titleEn: 'Bitcoin market cycles',
      titlePt: 'Ciclos de mercado do Bitcoin',
      url: 'https://www.youtube.com/watch?v=41JCpzvnn_0',
      thumbnail: 'https://img.youtube.com/vi/41JCpzvnn_0/hqdefault.jpg',
    ),
    'practice': LessonMediaEntry(
      titleRu: 'Как вести журнал сделок',
      titleEn: 'How to journal your trades',
      titlePt: 'Como manter diário de trades',
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
    if (m.contains('график') || m.contains('chart') || m.contains('gráf') || m.contains('estrut')) {
      return 'chart';
    }
    if (m.contains('паттерн') || m.contains('pattern') || m.contains('padr')) return 'patterns';
    if (m.contains('стратег') || m.contains('strateg')) return 'strategy';
    if (m.contains('риск') || m.contains('risk') || m.contains('risco') || m.contains('этик')) {
      return 'risk';
    }
    if (m.contains('рынок') || m.contains('market') || m.contains('mercado') || m.contains('макро')) {
      return 'market';
    }
    if (m.contains('практ') || m.contains('practice') || m.contains('prát') || m.contains('аттест')) {
      return 'practice';
    }
    return m;
  }

  static LessonMediaEntry? forLesson(int lessonId, String module) {
    return forModule(module);
  }

  static String localizedTitle(LessonMediaEntry entry) {
    return entry.titleFor(LocaleService.instance.languageCode);
  }
}
