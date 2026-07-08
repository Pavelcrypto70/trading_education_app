import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/lessons_repository.dart';
import '../l10n/app_localizations.dart';

enum AppLanguage {
  en('en', 'English', '🇬🇧'),
  ru('ru', 'Русский', '🇷🇺'),
  pt('pt', 'Português', '🇧🇷');

  const AppLanguage(this.code, this.label, this.flag);
  final String code;
  final String label;
  final String flag;

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (l) => l.code == code,
      orElse: () => AppLanguage.en,
    );
  }
}

class LocaleService extends ChangeNotifier {
  LocaleService._();
  static final LocaleService instance = LocaleService._();

  static const _prefKey = 'appLanguage';

  AppLanguage _language = AppLanguage.en;
  AppLanguage get language => _language;
  String get languageCode => _language.code;
  Locale get locale => Locale(_language.code);
  AppLocalizations get strings => AppLocalizations(_language);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _language = AppLanguage.fromCode(prefs.getString(_prefKey));
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_language == language) return;
    _language = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, language.code);
    LessonsRepository.instance.clearCache();
    notifyListeners();
  }
}

extension L10nContext on BuildContext {
  AppLocalizations get l10n => LocaleService.instance.strings;
}
