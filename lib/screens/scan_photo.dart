import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:talash/screens/match_resolver.dart';
import 'package:talash/screens/report_sighting.dart';
import 'package:talash/utils/pick_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

class ScanPhotoPage extends StatefulWidget {
  const ScanPhotoPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ScanPhotoPage> createState() => _ScanPhotoPageState();
}

class _ScanPhotoPageState extends State<ScanPhotoPage> {
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for caputred image

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![0], ResolutionPreset.max);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

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
              Text(
                "Capture the photo of the child in the given camera frame",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Container(
                  height: 300,
                  width: 400,
                  child: controller == null
                      ? Center(
                          child: Text("Loading Camera...",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)))
                      : !controller!.value.isInitialized
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : CameraPreview(controller!)),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      if (controller != null) {
                        //check if contrller is not null
                        if (controller!.value.isInitialized) {
                          //check if controller is initialized
                          XFile? tmp;
                          tmp = await controller!.takePicture(); //capture image
                          print(tmp);
                          setState(() {
                            //update UI
                            image = tmp;
                          });
                          if (image != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReportSightingPage(
                                        title: "Report Missing Child",
                                        image: image!)));
                          }
                        }
                      }
                    } catch (e) {
                      print(e); //show error
                    }
                  },
                  child: Text("Take Photo", style: TextStyle(fontSize: 20))),
              Text(
                "OR",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
              ElevatedButton(
                  onPressed: () async {
                    XFile? tmp = await pickImage(ImageSource.gallery);
                    print(tmp);
                    setState(() {
                      image = tmp;
                    });
                    if (image != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportSightingPage(
                                  title: "Report Missing Child",
                                  image: image!)));
                    }
                  },
                  child: Text("Upload", style: TextStyle(fontSize: 20))),
              // image != null
              //     ? Image(
              //         image: FileImage(File(image!.path)),
              //         height: 300,
              //         width: 400,
              //       )
              //     : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
