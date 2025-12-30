import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class AssetFileUtil {
  AssetFileUtil._();

  static Future<File> assetToFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final Uint8List bytes = byteData.buffer.asUint8List();

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/${assetPath.split('/').last}');

    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
