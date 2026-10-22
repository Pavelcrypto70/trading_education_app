import '../services/locale_service.dart';

/// Numbers the way the course text writes them: decimal comma, thin groups (10 000,50).
String fmtNum(double v, [int digits = 2]) {
  final neg = v < 0;
  final s = v.abs().toStringAsFixed(digits);
  final dot = s.indexOf('.');
  final whole = dot < 0 ? s : s.substring(0, dot);
  final frac = dot < 0 ? '' : s.substring(dot + 1);
  final b = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0 && whole.length > 4) b.write('\u00A0');
    b.write(whole[i]);
  }
  return '${neg ? '-' : ''}$b${frac.isEmpty ? '' : ',$frac'}';
}

/// Signed amount: +12,30 / -4,10.
String fmtSigned(double v, [int digits = 2]) => '${v >= 0 ? '+' : ''}${fmtNum(v, digits)}';

/// Localized plural for points / очко / ponto / punto.
String pointsWord(num n) {
  final abs = n.abs().toInt();
  switch (LocaleService.instance.language) {
    case AppLanguage.ru:
      final a = abs % 100;
      final b = a % 10;
      if (a >= 11 && a <= 14) return 'очков';
      if (b == 1) return 'очко';
      if (b >= 2 && b <= 4) return 'очка';
      return 'очков';
    case AppLanguage.pt:
      return abs == 1 ? 'ponto' : 'pontos';
    case AppLanguage.es:
      return abs == 1 ? 'punto' : 'puntos';
    case AppLanguage.en:
      return abs == 1 ? 'point' : 'points';
  }
}

/// Price with precision by size.
String fmtPrice(double p) => fmtNum(p, p >= 100 ? 2 : (p >= 1 ? 3 : 4));
