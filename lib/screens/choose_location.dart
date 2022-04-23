import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChooseLocationPage extends StatefulWidget {
  // final String title;
  // const ChooseLocationPage({Key? key, required this.title}) : super(key: key);
  const ChooseLocationPage({Key? key}) : super(key: key);

  @override
  State<ChooseLocationPage> createState() => _ChooseLocationPageState();
}

class _ChooseLocationPageState extends State<ChooseLocationPage> {
  List<Marker> myMarker = [
    Marker(
        markerId: MarkerId(LatLng(19.0735, 72.8995).toString()),
        position: LatLng(19.0735, 72.8995),
        draggable: true),
  ];

  _handleTap(LatLng tappedPoint) {
    print("Tapped point: $tappedPoint");
    setState(() {
      myMarker = [];
      myMarker.add(
        Marker(
            markerId: MarkerId(tappedPoint.toString()),
            position: tappedPoint,
            draggable: true),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: LatLng(19.0735, 72.8995), zoom: 10),
              markers: Set.from(myMarker),
              onTap: _handleTap,
              mapType: MapType.hybrid,
            ),
          ),
          Container(
            // color: Color(0xffea4335),
            color: Color(0xff34a853),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // print(myMarker[0].position);
                    Navigator.pop(context, myMarker[0].position);
                  },
                  child: Text(
                    "Confirm Location",
                    // style: TextStyle(color: Color(0xfffbbc04), fontSize: 20),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(primary: Color(0xff4285f4)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
