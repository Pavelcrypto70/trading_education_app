import 'package:web/web.dart' as web;

Future<bool> launchExternalUri(Uri uri) async {
  web.window.open(uri.toString(), '_blank');
  return true;
}

bool launchExternalUriNow(Uri uri) {
  web.window.open(uri.toString(), '_blank');
  return true;
}
