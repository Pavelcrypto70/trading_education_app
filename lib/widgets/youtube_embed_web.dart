// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class YoutubeEmbed extends StatefulWidget {
  final String videoId;

  const YoutubeEmbed({super.key, required this.videoId});

  @override
  State<YoutubeEmbed> createState() => _YoutubeEmbedState();
}

class _YoutubeEmbedState extends State<YoutubeEmbed> {
  static final _registered = <String>{};
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'youtube-embed-${widget.videoId}';
    if (_registered.contains(_viewType)) return;

    _registered.add(_viewType);
    final videoId = widget.videoId;
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = web.HTMLIFrameElement()
        ..src = 'https://www.youtube.com/embed/$videoId?rel=0'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true;
      iframe.setAttribute(
        'allow',
        'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share',
      );
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
