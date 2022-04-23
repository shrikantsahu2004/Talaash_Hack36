import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:talash/screens/report_sighting.dart';
import 'package:talash/screens/scan_photo.dart';
import 'package:talash/utils/pick_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

class MatchFailPage extends StatefulWidget {
  const MatchFailPage({Key? key, required this.title, required this.image})
      : super(key: key);
  final String title;
  final XFile? image;

  @override
  State<MatchFailPage> createState() => _MatchFailPageState();
}

class _MatchFailPageState extends State<MatchFailPage> {
  @override
  XFile? newImage;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xfffbb500),
        title: Text(
          'Match Result',
          style: TextStyle(
              fontSize: 24, color: Colors.black54, fontWeight: FontWeight.w800),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          height: double.infinity,
          width: double.infinity,
          color: Color(0xff353535),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "NO MATCH FOUND!",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                child: Image(
                  image: FileImage(File(widget.image!.path)),
                  height: 300,
                  width: 400,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => ScanPhotoPage()),
                        (Route<dynamic> route) => false);
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20),
                      child: Text("Take another Photo",
                          style: TextStyle(fontSize: 24))))
            ],
          ),
        ),
      ),
    );
  }
}
