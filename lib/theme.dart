import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Visual system aligned with Trade Master presentations (ink / cyan desk).
class AppTheme {
  // Brand tokens (presentation :root)
  static const Color bg = Color(0xFF03050A);
  static const Color bg2 = Color(0xFF070B12);
  static const Color surface = Color(0xFF0C121C);
  static const Color surface2 = Color(0xFF121A27);
  static const Color surface3 = Color(0xFF182233);
  static const Color line = Color(0xFF2B364A);
  static const Color lineSoft = Color(0xFF1A2332);
  static const Color text = Color(0xFFF4F7FB);
  static const Color muted = Color(0xFF95A3B8);
  static const Color faint = Color(0xFF5E6D84);

  static const Color accent = Color(0xFF5AE2FF);
  static const Color accentSoft = Color(0xFF123845);
  static const Color accentDim = Color(0xFF0B2430);
  static const Color onAccent = Color(0xFF021018);

  static const Color bull = Color(0xFF2AD49A);
  static const Color bullSoft = Color(0xFF0F2F26);
  static const Color bear = Color(0xFFFF5566);
  static const Color bearSoft = Color(0xFF3A141C);
  static const Color warn = Color(0xFFFFB020);

  /// Legacy aliases used across screens — map to new brand.
  static const Color gold = accent;
  static const Color card = surface2;

  static const Color accentLessons = bull;
  static const Color accentPractice = warn;
  static const Color accentCommunity = accent;
  static const Color accentQuizzes = Color(0xFF7DD3FC);
  static const Color accentJournal = warn;
  static const Color accentPath = accent;

  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 24;
  static const double space2xl = 32;

  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusXl = 24;

  static TextTheme _textTheme(TextTheme base) {
    final body = GoogleFonts.ibmPlexSansTextTheme(base).apply(
      bodyColor: text,
      displayColor: text,
    );
    final mono = GoogleFonts.jetBrainsMonoTextTheme(base);
    return body.copyWith(
      displayLarge: body.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: text,
      ),
      headlineMedium: body.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: text,
      ),
      titleLarge: body.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: text,
      ),
      titleMedium: body.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: text,
      ),
      bodyLarge: body.bodyLarge?.copyWith(color: text, height: 1.45),
      bodyMedium: body.bodyMedium?.copyWith(color: muted, height: 1.45),
      bodySmall: body.bodySmall?.copyWith(color: faint, height: 1.4),
      labelLarge: mono.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.08,
        color: faint,
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = _textTheme(base.textTheme);
    const scheme = ColorScheme.dark(
      surface: surface,
      primary: accent,
      onPrimary: onAccent,
      secondary: bull,
      onSecondary: onAccent,
      error: bear,
      onError: text,
      onSurface: text,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      canvasColor: bg,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        centerTitle: true,
        elevation: 0,
        foregroundColor: text,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardColor: card,
      dividerColor: lineSoft,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: accent.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: GoogleFonts.ibmPlexSans().fontFamily,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? accent : faint,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? accent : faint);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onAccent,
          minimumSize: const Size(double.infinity, 52),
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: const BorderSide(color: line),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: accent),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: surface2,
        selectedColor: accentDim,
        labelStyle: const TextStyle(color: text),
        side: const BorderSide(color: lineSoft),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bg2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lineSoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lineSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
        hintStyle: const TextStyle(color: faint),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: accent),
    );
  }

  static ThemeData get lightTheme => darkTheme;

  static BoxDecoration cardDecoration({Color? color, Border? border}) {
    return BoxDecoration(
      color: color ?? card,
      borderRadius: BorderRadius.circular(radiusLg),
      border: border ?? Border.all(color: lineSoft),
    );
  }

  static BoxDecoration accentCardDecoration(
    Color accentColor, {
    Color? color,
    double radius = 20,
  }) {
    return BoxDecoration(
      color: color ?? card,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: accentColor.withValues(alpha: 0.55)),
    );
  }

  static BoxDecoration heroGradient() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [accentDim, surface, bg],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(radiusXl),
      border: Border.all(color: const Color(0xFF1F5566)),
    );
  }
}
