import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:logger/logger.dart';

final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

/// pic cache and load
Future<Uint8List?> downloadImageBytes(String url) async {
  var uiImage = await loadImage(url);
  var pngBytes = await uiImage.toByteData(format: ui.ImageByteFormat.png);
  if (pngBytes != null) {
    return pngBytes.buffer.asUint8List();
  }
  return null;
}

Future<ui.Image> loadImage(String url) async {
  Completer<ui.Image> completer = Completer<ui.Image>();
  ImageStreamListener? listener;
  ImageStream stream = CachedNetworkImageProvider(url).resolve(ImageConfiguration.empty);
  listener = ImageStreamListener((ImageInfo frame, bool sync) {
    final ui.Image image = frame.image;
    completer.complete(image);
    if (listener != null) {
      stream.removeListener(listener);
    }
  });
  stream.addListener(listener);
  return completer.future;
}

saveNetworkImage(String path) async {
  GallerySaver.saveImage(path);
  _logger.i('Saving photo, url: $path');
}
