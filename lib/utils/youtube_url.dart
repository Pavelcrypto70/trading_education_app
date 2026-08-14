/// Extracts a YouTube video id from common watch / embed / short URLs.
String? youtubeVideoIdFromUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return null;

  final host = uri.host.toLowerCase();
  if (host.contains('youtu.be')) {
    return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
  }

  if (host.contains('youtube.com') || host.contains('youtube-nocookie.com')) {
    final segments = uri.pathSegments;
    final embedIndex = segments.indexOf('embed');
    if (embedIndex >= 0 && embedIndex + 1 < segments.length) {
      return segments[embedIndex + 1];
    }
    final v = uri.queryParameters['v'];
    if (v != null && v.isNotEmpty) return v;
  }

  return null;
}
