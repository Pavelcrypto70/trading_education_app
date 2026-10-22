import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'router.dart';
import 'services/locale_service.dart';
import 'theme.dart';

/// Web/desktop: allow mouse + trackpad to drag horizontal chip rows, etc.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

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
          scrollBehavior: const AppScrollBehavior(),
          locale: localeService.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
            Locale('pt'),
            Locale('ru'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) => _PhoneFrame(child: child ?? const SizedBox()),
        );
      },
    );
  }
}

/// On tablets/desktop web the app is a centered phone column, not a stretched layout.
class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.child});

  final Widget child;

  static const double _maxWidth = 480;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width <= _maxWidth + 40) return child;
    return ColoredBox(
      color: AppTheme.backdrop,
      child: Center(
        child: Container(
          width: _maxWidth,
          decoration: BoxDecoration(
            border: Border.symmetric(
              vertical: BorderSide(color: AppTheme.lineSoft.withValues(alpha: 0.8)),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: Size(_maxWidth, MediaQuery.sizeOf(context).height),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
