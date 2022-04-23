import 'package:flutter/material.dart';
import 'package:talash/screens/match_resolver.dart';

//screens
import './screens/scan_photo.dart';
import './screens/report_sighting.dart';
import './screens/match_fail.dart';
import './screens/match_success.dart';
import './screens/child_details.dart';
import './screens/choose_location.dart';

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
      home: const ScanPhotoPage(title: 'Track Missing Child'),
      // home: const ReportSightingPage(title: 'Track Missing Child'),
      // home: MatchFailPage(title: 'Track Missing Child'),
      // home: const MatchSuccessPage(title: 'Track Missing Child'),
      // home: const ChildDetailsPage(title: 'Track Missing Child'),
      // home: const ChooseLocationPage(),
    );
  }
}
