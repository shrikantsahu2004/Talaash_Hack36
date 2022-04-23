import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:talash/screens/choose_location.dart';
import 'package:talash/screens/match_fail.dart';
import 'package:talash/screens/match_success.dart';
import 'package:talash/utils/api.dart';
import 'package:talash/utils/get_place.dart';
import 'package:talash/utils/pick_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter/services.dart' show rootBundle;

enum AloneStatus { yes, no, notSure }

class ReportSightingPage extends StatefulWidget {
  // const ReportSightingPage({Key? key, required this.title}) : super(key: key);
  const ReportSightingPage({Key? key, required this.image}) : super(key: key);
  final XFile image;

  @override
  State<ReportSightingPage> createState() => _ReportSightingPageState();
}

class _ReportSightingPageState extends State<ReportSightingPage> {
  AloneStatus _status = AloneStatus.yes;
  String? contact = "";
  String? address = "Mumbai, 400083";
  // TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xfffbb500),
        title: Text(
          'Report Missing Child',
          style: TextStyle(
              fontSize: 24, color: Colors.black54, fontWeight: FontWeight.w800),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        height: double.infinity,
        width: double.infinity,
        color: Color(0xff353535),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image(
                  image: FileImage(File(widget.image.path)),
                  height: 150,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Q. Where did you see him/her?",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final location = await Navigator.push(
                      context,
                      // Create the SelectionScreen in the next step.
                      MaterialPageRoute(
                          builder: (context) => const ChooseLocationPage()),
                    );
                    // print(location);
                    final place = await getPlace(location);
                    print(place);
                    setState(() {
                      address = place;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Pick Location", style: TextStyle(fontSize: 20)),
                      Icon(Icons.location_on),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: address == ""
                    ? Text(
                        "Location",
                        style: TextStyle(fontSize: 20),
                      )
                    : Text("$address",
                        style: TextStyle(
                          fontSize: 20,
                        )),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Q. Was he/she alone?",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    fillColor: MaterialStateProperty.all(Colors.blue),
                    value: AloneStatus.yes,
                    groupValue: _status,
                    onChanged: (AloneStatus? value) {
                      setState(() {
                        _status = value!;
                      });
                    },
                  ),
                  Text(
                    "Yes",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Radio(
                    fillColor: MaterialStateProperty.all(Colors.blue),
                    value: AloneStatus.no,
                    groupValue: _status,
                    onChanged: (AloneStatus? value) {
                      setState(() {
                        _status = value!;
                      });
                    },
                  ),
                  Text(
                    "No",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Radio(
                    fillColor: MaterialStateProperty.all(Colors.blue),
                    // activeColor: Colors.white,
                    value: AloneStatus.notSure,
                    groupValue: _status,
                    onChanged: (AloneStatus? value) {
                      setState(() {
                        _status = value!;
                      });
                    },
                  ),
                  Text(
                    "Not Sure",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Q. Can you provide your contact number? (optional)",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 40,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      contact = value;
                    });
                  },
                  decoration: InputDecoration(
                      filled: true,
                      hintText: "Contact Number",
                      fillColor: Colors.white),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                        padding: const EdgeInsets.fromLTRB(70, 10, 70, 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        primary: Color(0xffE79600)),
                    onPressed: () async {
                      if (address != "") {
                        List<int> imageBytes =
                            File(widget.image.path).readAsBytesSync();

                        String imageB64 = base64Encode(imageBytes);
                        Map data = {
                          'image': imageB64,
                          'aloneStatus': _status.toString().split('.').last,
                          'address': address,
                          'contact': contact,
                        };
                        var response = await reportSightingAPI(data);
                        if (response.statusCode == 200) {
                          var jsonResponse = json.decode(response.body);
                          print(jsonResponse['status']);
                          if (jsonResponse['status'] == 'error') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MatchFailPage(
                                    title: "Match Result", image: widget.image),
                              ),
                            );
                          } else {
                            var matchedImage = jsonResponse['image'];
                            var matchPercent = jsonResponse['match_percent'];
                            var missingChild = jsonResponse['missing_child'];
                            var name = missingChild['Name'];
                            var missingDate = missingChild['Missing_date'];
                            var missingFrom = missingChild['Missing_From'];
                            var gender = missingChild['Sex'];
                            var age = missingChild['Age'];

                            final decodedBytes = base64Decode(matchedImage);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MatchSuccessPage(
                                          image: widget.image,
                                          matchedImageBytes: decodedBytes,
                                          name: name,
                                          gender: gender,
                                          age: age,
                                          missingDate: missingDate,
                                          missingFrom: missingFrom,
                                        )));
                          }
                        } else if (response.statusCode == 500) {
                          print("Server Error");
                        } else if (response.statusCode == 400) {
                          print("Bad Request");
                        } else if (response.statusCode == 404) {
                          print("Page Not Found");
                        } else {
                          print("Unknown Error");
                        }
                      }
                    },
                    child: Text("Report Sighting",
                        style: TextStyle(fontSize: 24, color: Colors.black))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
