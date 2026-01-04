import 'dart:io';

import 'package:nearby_service/nearby_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class FilesSaver {
  FilesSaver._();

  static Future<bool> savePack(
    ReceivedNearbyFilesPack pack,
  ) async {
    final directory = Platform.isAndroid
    ? Directory('storage/emulated/0/Download')
    : await getApplicationDocumentsDirectory();

    for (final nearbyFile in pack.files) {
      final newFile = await File(nearbyFile.path).copy(
        '${directory.path}/${DateTime.now().microsecondsSinceEpoch}.${nearbyFile.extension}',
      );
      if (!await newFile.exists()) {
        await newFile.create();
      }
    }
    return true;
  }

  static Future<String> saveProfileImage(File file) async {
    final dir = await getApplicationDocumentsDirectory();
    final profileDir = Directory(p.join(dir.path, 'profile'));

    if (!profileDir.existsSync()) {
      await profileDir.create(recursive: true);
    }

    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${p.extension(file.path)}';
    final savedFile = await file.copy(p.join(profileDir.path, fileName));

    return savedFile.path;
  }
}