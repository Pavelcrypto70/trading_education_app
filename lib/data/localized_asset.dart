import 'package:flutter/services.dart';

import '../services/locale_service.dart';

/// Loads `assets/data/<base>_<lang>.json` when it exists (the rebuilt RU course
/// ships its own quizzes/glossary), otherwise the shared multi-locale file.
Future<String> loadLocalizedAsset(String base) async {
  final lang = LocaleService.instance.languageCode;
  if (lang == 'ru') {
    try {
      return await rootBundle.loadString('assets/data/${base}_ru.json');
    } catch (_) {}
  }
  return rootBundle.loadString('assets/data/$base.json');
}
