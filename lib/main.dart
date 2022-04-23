import 'package:flutter/material.dart';

//screens
import './screens/scan_photo.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talash',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScanPhotoPage(),
    );
  }
}
