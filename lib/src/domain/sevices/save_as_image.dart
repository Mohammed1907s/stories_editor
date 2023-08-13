import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:render/render.dart';

Future takePicture(
    {required contentKey,
      required BuildContext context,
      RenderController? controller,
      required saveToGallery}) async {
  try {
    /// converter widget to image
    RenderRepaintBoundary boundary = contentKey.currentContext.findRenderObject();

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    /// create file
    final String dir = (await getApplicationDocumentsDirectory()).path;
    String imagePath = '$dir/stories_creator${DateTime.now()}.png';
    File capturedFile = File(imagePath);
    await capturedFile.writeAsBytes(pngBytes);
    final result = await controller?.captureMotion(
      Duration(seconds: 5),
      format: GifFormat(),
    );

    final file = result?.output;
    if (file != null) {
      final result = await ImageGallerySaver.saveFile(file.path);
      if (result != null) {
        return true;
      } else {
        return false;
      }
    }
    if (saveToGallery) {
      final result = await ImageGallerySaver.saveImage(pngBytes,
          quality: 100, name: "stories_creator${DateTime.now()}.png");
      if (result != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return imagePath;
    }
  } catch (e) {
    debugPrint('exception => $e');
    return false;
  }
}