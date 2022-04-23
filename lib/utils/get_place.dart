import 'package:geocoding/geocoding.dart';

Future<String> getPlace(var position) async {
  print("In get place");
  print(position.latitude);
  print(position.longitude);
  List<Placemark> newPlace =
      await placemarkFromCoordinates(position.latitude, position.longitude);

  // this is all you need
  Placemark placeMark = newPlace[0];
  String? name = placeMark.name;
  String? subLocality = placeMark.subLocality;
  String? locality = placeMark.locality;
  String? administrativeArea = placeMark.administrativeArea;
  String? postalCode = placeMark.postalCode;
  String? country = placeMark.country;
  String address = "";

  if (name != "") {
    address += "$name, ";
  }

  if (subLocality != "") {
    address += "$subLocality, ";
  }

  if (locality != "") {
    address += "$locality, ";
  }

  if (administrativeArea != "") {
    address += "$administrativeArea, ";
  }

  if (postalCode != "") {
    address += "$postalCode, ";
  }

  if (country != "") {
    address += "$country";
  }
  // String? address =
  //     "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";

  print(address);
  return address;
}
