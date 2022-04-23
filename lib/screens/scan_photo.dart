import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talash/screens/report_sighting.dart';
import '../utils/pick_image.dart';
import 'report_sighting.dart';

class ScanPhotoPage extends StatefulWidget {
  const ScanPhotoPage({Key? key}) : super(key: key);

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
      print("camera NOT found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xffE79600),
        title: Text(
          'Track Missing Child',
          style: TextStyle(
              fontSize: 24, color: Colors.black54, fontWeight: FontWeight.w800),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          height: double.infinity,
          width: double.infinity,
          color: Color(0xff222222),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Image Capture",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              Container(
                  height: 300,
                  width: 300,
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
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      padding: const EdgeInsets.fromLTRB(70, 10, 70, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      primary: Color(0xffE79600)),
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
                                    builder: (context) =>
                                        ReportSightingPage(image: image!)));
                          }
                        }
                      }
                    } catch (e) {
                      print(e); //show error
                    }
                  },
                  child: Text("Take Photo",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w700))),
              Center(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(45, 0, 20, 0),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          child: const Divider(
                            color: Colors.white,
                            thickness: 1.3,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: const Text(
                            'OR',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: const Divider(
                            color: Colors.white,
                            thickness: 1.3,
                          ),
                        ),
                      ],
                    )),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      padding: const EdgeInsets.fromLTRB(70, 10, 70, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      primary: Color(0xffE79600)),
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
                              builder: (context) =>
                                  ReportSightingPage(image: image!)));
                    }
                  },
                  child: Text("Upload",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w700))),
            ],
          ),
        ),
      ),
    );
  }
}
