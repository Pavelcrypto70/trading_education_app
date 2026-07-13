import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens http(s) links reliably on web, mobile and desktop.
Future<bool> openExternalLink(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;

  try {
    return await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: kIsWeb ? '_blank' : null,
    );
  } catch (_) {
    if (kIsWeb) {
      try {
        return await launchUrl(uri, webOnlyWindowName: '_blank');
      } catch (_) {
        return false;
      }
    }
    return false;
  }
}
