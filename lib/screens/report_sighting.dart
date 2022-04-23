import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:talash/screens/choose_location.dart';
import 'package:talash/screens/match_fail.dart';
import 'package:talash/screens/match_resolver.dart';
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
  const ReportSightingPage({Key? key, required this.title, required this.image})
      : super(key: key);
  final String title;
  final XFile image;

  @override
  State<ReportSightingPage> createState() => _ReportSightingPageState();
}

class _ReportSightingPageState extends State<ReportSightingPage> {
  AloneStatus _status = AloneStatus.yes;
  String? contact = "";
  String? address = "Vidyavihar, 734773";
  // TextEditingController _textEditingController = TextEditingController();
  @override
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
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
              Text(
                "Where did you sight him/her?",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              ElevatedButton(
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
              Container(
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
              Text(
                "Was he/she alone?",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
              Text(
                "Can you provide your contact number? (optional)",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    contact = value;
                  });
                },
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Contact Number",
                    labelText: '$contact',
                    fillColor: Colors.white),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xff209c1e)),
                  onPressed: () async {
                    if (address != "") {
                      List<int> imageBytes =
                          File(widget.image.path).readAsBytesSync();

                      String imageB64 = base64Encode(imageBytes);
                      Map data = {
                        'image': imageB64,
                        'aloneStatus': _status.toString(),
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
                                        title: "Match Result",
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
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => MatchResolver(
                      //             address: address!,
                      //             aloneStatus: _status.toString(),
                      //             title: "Report Missing Child",
                      //             contact: contact!,
                      //             image: widget.image)));
                    }
                  },
                  child:
                      Text("Report Sighting", style: TextStyle(fontSize: 24))),
            ],
          ),
        ),
      ),
    );
  }
}
