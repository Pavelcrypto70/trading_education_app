import 'package:flutter/material.dart';

/// Trade Master visual system «Ночной пластилин»: plum night base, puffy clay
/// cards, Lora serif for headings/numbers, Nunito for everything else.
class AppTheme {
  // Base surfaces (plum night).
  static const Color bg = Color(0xFF1B1530);
  static const Color bg2 = Color(0xFF221B38);
  static const Color backdrop = Color(0xFF120E22);
  static const Color surface = Color(0xFF2A2242);
  static const Color surface2 = Color(0xFF312850);
  static const Color surface3 = Color(0xFF3A2F5C);
  static const Color surfaceNow = Color(0xFF3A2A4A);
  static const Color surfaceLocked = Color(0xFF241D38);
  static const Color line = Color(0xFF4A3E70);
  static const Color lineSoft = Color(0xFF362C56);
  static const Color text = Color(0xFFF4EEFF);
  static const Color textSoft = Color(0xFFDCD3F2);
  static const Color muted = Color(0xFFA79CC4);
  static const Color faint = Color(0xFF7F75A0);

  // Brand: coral primary, lavender secondary.
  static const Color accent = Color(0xFFFF7A6B);
  static const Color accentText = Color(0xFFFF9A8B);
  static const Color accentSoft = Color(0xFF4A2A40);
  static const Color accentDim = Color(0xFF3A2340);
  static const Color onAccent = Color(0xFFFFFFFF);
  static const Color lavender = Color(0xFFB9A4FF);
  static const Color progress = Color(0xFFFFE36B);
  static const Color onPastel = Color(0xFF2E2440);

  // Market semantics.
  static const Color ok = Color(0xFF5FE0A0);
  static const Color bull = Color(0xFF3FCB8A);
  static const Color bullSoft = Color(0xFF1F3B3A);
  static const Color bear = Color(0xFFFF6B6B);
  static const Color bearSoft = Color(0xFF4A2236);
  static const Color warn = Color(0xFFFFC86B);
  static const Color warnSoft = Color(0xFF433422);
  static const Color info = Color(0xFF7FD4FF);
  static const Color grid = Color(0x12FFFFFF);

  // Pastel palette for icon squares, stages and avatars.
  static const Color peach = Color(0xFFFFB38A);
  static const Color mint = Color(0xFF8EE3B5);
  static const Color violet = lavender;
  static const Color pink = Color(0xFFFF9EB8);
  static const Color sky = info;
  static const Color sun = progress;
  static const Color coral = accent;
  static const Color orange = peach;

  static const List<Color> pastel = [peach, mint, lavender, pink, sky, sun];

  /// Legacy aliases used across screens.
  static const Color gold = warn;
  static const Color card = surface2;

  static const Color accentLessons = mint;
  static const Color accentPractice = peach;
  static const Color accentCommunity = sky;
  static const Color accentQuizzes = lavender;
  static const Color accentJournal = sun;
  static const Color accentPath = accent;
  static const Color accentProfile = pink;

  /// Stage colors for the 6-step journey.
  static const List<Color> stageColors = [peach, mint, lavender, pink, sky, sun];

  static Color stageColor(int stage) =>
      stageColors[(stage - 1).clamp(0, stageColors.length - 1)];

  static const LinearGradient heroGradientColors = LinearGradient(
    colors: [Color(0xFFFF7A6B), Color(0xFFE8559A), Color(0xFF8B6BFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient brandGradient = heroGradientColors;

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFF7A6B), Color(0xFFFFB38A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF1B1530), Color(0xFF251831)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient tintGradient(Color c) => LinearGradient(
        colors: [
          Color.alphaBlend(c.withValues(alpha: 0.20), surface),
          Color.alphaBlend(c.withValues(alpha: 0.06), surface),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Puffy clay depth: dark drop shadow + faint top-left highlight.
  static const List<BoxShadow> clayShadow = [
    BoxShadow(color: Color(0x73000000), offset: Offset(8, 10), blurRadius: 22),
    BoxShadow(color: Color(0x09FFFFFF), offset: Offset(-4, -4), blurRadius: 12),
  ];

  static List<BoxShadow> glow(Color c, {double alpha = 0.32}) => [
        BoxShadow(color: c.withValues(alpha: alpha), offset: const Offset(6, 8), blurRadius: 18),
      ];

  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 24;
  static const double space2xl = 32;

  static const double radiusSm = 16;
  static const double radiusMd = 20;
  static const double radiusLg = 24;
  static const double radiusXl = 30;

  /// Serif display style for headings and big numbers.
  static const serifFamily = 'Lora';
  static const sansFamily = 'Nunito';

  static TextStyle display(double size, {FontWeight weight = FontWeight.w700, Color color = text}) => TextStyle(
        fontFamily: serifFamily,
        fontSize: size,
        fontWeight: weight == FontWeight.w800 || weight == FontWeight.w900 ? FontWeight.w700 : weight,
        color: color,
        height: 1.15,
        letterSpacing: -0.2,
      );

  static TextTheme _textTheme(TextTheme base) {
    final body = base.apply(fontFamily: sansFamily, bodyColor: text, displayColor: text);
    TextStyle? serif(TextStyle? s, {double? spacing}) => s?.copyWith(
          fontFamily: serifFamily,
          fontWeight: FontWeight.w700,
          letterSpacing: spacing ?? -0.3,
          color: text,
        );
    return body.copyWith(
      displayLarge: serif(body.displayLarge, spacing: -0.8),
      displayMedium: serif(body.displayMedium, spacing: -0.6),
      displaySmall: serif(body.displaySmall, spacing: -0.6),
      headlineLarge: serif(body.headlineLarge),
      headlineMedium: serif(body.headlineMedium),
      headlineSmall: serif(body.headlineSmall),
      titleLarge: serif(body.titleLarge, spacing: -0.2),
      titleMedium: body.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: text),
      titleSmall: body.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: text),
      bodyLarge: body.bodyLarge?.copyWith(color: text, height: 1.5, fontWeight: FontWeight.w600),
      bodyMedium: body.bodyMedium?.copyWith(color: textSoft, height: 1.5, fontWeight: FontWeight.w600),
      bodySmall: body.bodySmall?.copyWith(color: muted, height: 1.4, fontWeight: FontWeight.w600),
      labelLarge: body.labelLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.2, color: muted),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = _textTheme(base.textTheme);
    const nunito = sansFamily;
    const scheme = ColorScheme.dark(
      surface: surface,
      primary: accent,
      onPrimary: onAccent,
      secondary: lavender,
      onSecondary: onPastel,
      tertiary: mint,
      error: bear,
      onError: text,
      onSurface: text,
      surfaceContainerHighest: surface3,
      outline: line,
      outlineVariant: lineSoft,
    );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMd),
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      canvasColor: bg,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: text,
        titleTextStyle: textTheme.titleLarge?.copyWith(fontSize: 20),
        iconTheme: const IconThemeData(color: text, size: 22),
      ),
      cardColor: card,
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
      ),
      dividerColor: lineSoft,
      dividerTheme: const DividerThemeData(color: lineSoft, thickness: 1),
      listTileTheme: const ListTileThemeData(
        iconColor: muted,
        textColor: text,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: bg2,
        height: 72,
        indicatorColor: accent.withValues(alpha: 0.16),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: nunito,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
            color: selected ? accentText : faint,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(size: 24, color: selected ? accentText : faint);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onAccent,
          disabledBackgroundColor: surface3,
          disabledForegroundColor: faint,
          minimumSize: const Size(double.infinity, 54),
          elevation: 0,
          shadowColor: accent,
          textStyle: TextStyle(fontFamily: nunito, fontWeight: FontWeight.w900, fontSize: 16),
          shape: buttonShape,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onAccent,
          minimumSize: const Size(double.infinity, 54),
          textStyle: TextStyle(fontFamily: nunito, fontWeight: FontWeight.w900, fontSize: 16),
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          backgroundColor: surface,
          side: const BorderSide(color: line, width: 1.2),
          minimumSize: const Size(double.infinity, 52),
          textStyle: TextStyle(fontFamily: nunito, fontWeight: FontWeight.w800, fontSize: 15),
          shape: buttonShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentText,
          textStyle: TextStyle(fontFamily: nunito, fontWeight: FontWeight.w800),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: surface,
        selectedColor: accent,
        labelStyle: const TextStyle(color: text, fontWeight: FontWeight.w700),
        secondaryLabelStyle: const TextStyle(color: onAccent, fontWeight: FontWeight.w800),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: lineSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: accent, width: 1.6),
        ),
        labelStyle: const TextStyle(color: muted),
        hintStyle: const TextStyle(color: faint),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusXl)),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: line,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surface3,
        contentTextStyle: TextStyle(fontFamily: nunito, color: text, fontWeight: FontWeight.w700),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? onAccent : muted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? accent : surface3,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? accent : Colors.transparent,
        ),
        side: const BorderSide(color: line, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: text,
        unselectedLabelColor: muted,
        indicatorColor: accent,
        dividerColor: lineSoft,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: progress,
        linearTrackColor: surfaceLocked,
        circularTrackColor: surfaceLocked,
      ),
    );
  }

  static ThemeData get lightTheme => darkTheme;

  static BoxDecoration cardDecoration({Color? color, Border? border}) {
    return BoxDecoration(
      color: color ?? surface,
      borderRadius: BorderRadius.circular(radiusLg),
      border: border,
      boxShadow: clayShadow,
    );
  }

  /// Tinted clay card: soft wash of [accentColor].
  static BoxDecoration accentCardDecoration(
    Color accentColor, {
    Color? color,
    double radius = radiusLg,
  }) {
    return BoxDecoration(
      color: color,
      gradient: color == null ? tintGradient(accentColor) : null,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: accentColor.withValues(alpha: 0.35)),
      boxShadow: clayShadow,
    );
  }

  static BoxDecoration heroGradient() {
    return BoxDecoration(
      gradient: heroGradientColors,
      borderRadius: BorderRadius.circular(radiusXl),
      boxShadow: const [
        BoxShadow(color: Color(0x73000000), offset: Offset(10, 14), blurRadius: 28),
      ],
    );
  }

  /// Pastel squircle with sculpted inner light — icon tiles, lesson numbers.
  static BoxDecoration claySquare(Color c, {double radius = radiusSm}) {
    return BoxDecoration(
      color: c,
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        colors: [Color.lerp(c, Colors.white, 0.18)!, c, Color.lerp(c, Colors.black, 0.12)!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}
