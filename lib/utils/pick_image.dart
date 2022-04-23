import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

import '../constants.dart';

Future<XFile?> pickImage(ImageSource source) async {
  try {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return null;

    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      maxHeight: 10,
      aspectRatioPresets: kAspectRatioPresets,
      androidUiSettings: kAndroidUiSettings,
      iosUiSettings: kIOSUiSettings,
    );
    if (croppedImage == null) return null;
    final imageTemporary = XFile(croppedImage.path);
    return imageTemporary;
  } on PlatformException catch (e) {
    print("Failed to pick image: $e");
  }
}
