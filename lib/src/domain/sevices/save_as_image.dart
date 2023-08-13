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
    // final String dir = (await getApplicationDocumentsDirectory()).path;
    // String imagePath = '$dir/stories_creator${DateTime.now()}.gif';
    // await capturedFile.writeAsBytes(pngBytes);
    final results = await controller?.captureMotion(
      Duration(seconds: 5),
      format: GifFormat(),
    );
    // final String dir = (await getApplicationDocumentsDirectory()).path;
    // String imagePath = '$dir/stories_creator${DateTime.now()}.gif';
    File capturedFile = results!.output;
    debugPrint('capturedFile ${capturedFile.path}');
    if (saveToGallery) {
      final file = results?.output;
      if (file != null) {
        final result = await ImageGallerySaver.saveFile(file.path,isReturnPathOfIOS: true);
        if (result != null) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      return capturedFile.path;
    }
  } catch (e) {
    debugPrint('exception => $e');
    return false;
  }
}
