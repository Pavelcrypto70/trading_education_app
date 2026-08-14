import 'package:url_launcher/url_launcher.dart';

Future<bool> launchExternalUri(Uri uri) async {
  try {
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return await launchUrl(uri, mode: LaunchMode.platformDefault);
  } catch (_) {
    return false;
  }
}

bool launchExternalUriNow(Uri uri) {
  launchUrl(uri, mode: LaunchMode.externalApplication);
  return true;
}
