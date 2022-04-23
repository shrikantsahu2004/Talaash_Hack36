import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:talash/screens/child_details.dart';
import 'package:talash/utils/pick_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

class MatchSuccessPage extends StatefulWidget {
  const MatchSuccessPage(
      {Key? key,
      required this.title,
      required this.image,
      required this.matchedImageBytes,
      required this.name,
      required this.age,
      required this.gender,
      required this.missingDate,
      required this.missingFrom})
      : super(key: key);
  // const ReportSightingPage({Key? key, required this.title, required this.image}) : super(key: key);
  final String title;
  final XFile image;
  final Uint8List matchedImageBytes;
  final String name;
  final String age;
  final String gender;
  final String missingDate;
  final String missingFrom;

  @override
  State<MatchSuccessPage> createState() => _MatchSuccessPageState();
}

class _MatchSuccessPageState extends State<MatchSuccessPage> {
  @override
  XFile? newImage;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffbb500),
        title: Center(child: Text(widget.title)),
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
                "MATCH FOUND!",
                style: TextStyle(
                    color: Color(0xff6af100),
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                // child: Image(
                //   image: AssetImage('images/child1.jfif'),
                //   height: 150,
                // ),
                child: Image(
                  image: FileImage(File(widget.image.path)),
                  height: 150,
                ),
              ),
              Container(
                child: Image(
                  image: Image.memory(widget.matchedImageBytes).image,
                  height: 150,
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff6af100),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChildDetailsPage(
                                  title: "Report Missing Child",
                                  image: widget.matchedImageBytes,
                                  age: widget.age,
                                  missingDate: widget.missingDate,
                                  gender: widget.gender,
                                  missingFrom: widget.missingFrom,
                                  name: widget.name,
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: Text("SEE DETAILS", style: TextStyle(fontSize: 24)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
