import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

var kButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
  ),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
);

var kInputDecoration = InputDecoration(
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
  ),
);

var kAndroidUiSettings = AndroidUiSettings(
    toolbarTitle: 'Cropper',
    toolbarColor: Colors.deepOrange,
    toolbarWidgetColor: Colors.white,
    initAspectRatio: CropAspectRatioPreset.original,
    lockAspectRatio: false);

var kIOSUiSettings = IOSUiSettings(
  minimumAspectRatio: 1.0,
);

var kAspectRatioPresets = [
  CropAspectRatioPreset.square,
  CropAspectRatioPreset.ratio3x2,
  CropAspectRatioPreset.original,
  CropAspectRatioPreset.ratio4x3,
  CropAspectRatioPreset.ratio16x9
];

var kBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  color: Colors.white,
  boxShadow: [
    BoxShadow(color: Colors.purple, spreadRadius: 1),
  ],
);

var kBoxDecorationSelected = BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  color: Colors.purple,
  boxShadow: [
    BoxShadow(color: Colors.white, spreadRadius: 1),
  ],
);

var kHomeBottomCardTextStyle = TextStyle(
  fontSize: 10.0,
  color: Colors.white,
);

var kBoxGradient = BoxDecoration(
  gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.purple.shade800,
        // Colors.purple.shade600,
        Colors.purple.shade400,
        Colors.purple.shade200,
        // Colors.purple.shade100,
        Colors.deepPurpleAccent,
      ]),
);
