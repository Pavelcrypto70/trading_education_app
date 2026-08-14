import 'external_link_stub.dart'
    if (dart.library.html) 'external_link_web.dart'
    if (dart.library.js_interop) 'external_link_web.dart'
    if (dart.library.io) 'external_link_io.dart';

/// Opens http(s) links reliably on web, mobile and desktop.
Future<bool> openExternalLink(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  return launchExternalUri(uri);
}

/// Opens a link synchronously inside a click handler (important for web popups).
bool openExternalLinkNow(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  return launchExternalUriNow(uri);
}
