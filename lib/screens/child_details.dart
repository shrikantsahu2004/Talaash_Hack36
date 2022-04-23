import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:talash/screens/scan_photo.dart';
import 'package:talash/utils/pick_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

class ChildDetailsPage extends StatefulWidget {
  // const ChildDetailsPage({Key? key, required this.title}) : super(key: key);
  const ChildDetailsPage(
      {Key? key,
      required this.image,
      required this.name,
      required this.age,
      required this.gender,
      required this.missingDate,
      required this.missingFrom})
      : super(key: key);
  final Uint8List image;
  final String name;
  final String age;
  final String gender;
  final String missingDate;
  final String missingFrom;

  @override
  State<ChildDetailsPage> createState() => _ChildDetailsPageState();
}

class _ChildDetailsPageState extends State<ChildDetailsPage> {
  @override
  XFile? newImage;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xfffbb500),
        title: Center(
          child: Text(
            'Report Missing Child',
            style: TextStyle(
                fontSize: 24,
                color: Colors.black54,
                fontWeight: FontWeight.w800),
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          height: double.infinity,
          width: double.infinity,
          color: Color(0xff353535),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "DETAILS",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                child: CircleAvatar(
                  backgroundImage: Image.memory(widget.image).image,
                  radius: 70,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CustomTile(
                      title: "Name",
                      value: widget.name,
                    ),
                    CustomTile(
                      title: "Age",
                      value: widget.age,
                    ),
                    CustomTile(
                      title: "Gender",
                      value: widget.gender,
                    ),
                    CustomTile(
                      title: "Date",
                      value: widget.missingDate,
                    ),
                    CustomTile(
                      title: "Missing from",
                      value: widget.missingFrom,
                    ),
                  ],
                ),
              ),
              Text(
                "Concerned Authorities have been alerted",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
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
                        style: TextStyle(fontSize: 24)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  const CustomTile({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$title: ",
            style: TextStyle(
                color: Color(0xff6af100),
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1)),
        Text("$value",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1)),
      ],
    );
  }
}
