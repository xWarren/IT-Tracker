import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  static Future<File?> pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  static Future<List<File>?> pickMultipleImage() async {
    final pickListFile = await _picker.pickMultiImage(imageQuality: 25);
    return pickListFile.map((xFile) => File(xFile.path)).toList();
  }
}