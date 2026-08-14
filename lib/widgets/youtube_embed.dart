export 'youtube_embed_stub.dart'
    if (dart.library.html) 'youtube_embed_web.dart'
    if (dart.library.js_interop) 'youtube_embed_web.dart';
