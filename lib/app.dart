import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'router.dart';
import 'services/locale_service.dart';
import 'theme.dart';

class TradeMasterApp extends StatelessWidget {
  const TradeMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleService.instance,
      builder: (context, _) {
        final localeService = LocaleService.instance;
        return MaterialApp.router(
          key: ValueKey(localeService.languageCode),
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          title: localeService.strings.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          locale: localeService.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('ru'),
            Locale('pt'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}
