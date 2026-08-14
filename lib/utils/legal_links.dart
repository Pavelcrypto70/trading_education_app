import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens legal pages (static HTML on web deploy).
class LegalLinks {
  LegalLinks._();

  static Uri get privacyUri => kIsWeb
      ? Uri.parse('${Uri.base.origin}/privacy.html')
      : Uri.parse('https://pavelcrypto70.github.io/privacy.html');

  static Uri get termsUri => kIsWeb
      ? Uri.parse('${Uri.base.origin}/terms.html')
      : Uri.parse('https://pavelcrypto70.github.io/terms.html');

  static Future<void> openPrivacy() => _open(privacyUri);
  static Future<void> openTerms() => _open(termsUri);

  static Future<void> _open(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
