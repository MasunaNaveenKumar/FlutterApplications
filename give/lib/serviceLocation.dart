import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'globalvariables_and_functions.dart';



firstLocation() async {
  var location = new Location();
  await location.getLocation().then((LocationData locationData) {
    //Sets the changing location in the Map Controller
    latitude = locationData.latitude;
    longitude = locationData.longitude;
  });
  var addresses = await Geocoder.local.findAddressesFromCoordinates(
      Coordinates(latitude, longitude));
  var first = addresses.first;
  print("\n");
  print("${first.subAdminArea}");
  print("\n");
  userCity = first.subAdminArea;
  print("\n");
}



void loadMap()
{

  googlemap = GoogleMap(
    scrollGesturesEnabled: true,
    myLocationButtonEnabled: true,
    myLocationEnabled: true,
    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
      new Factory<OneSequenceGestureRecognizer>(
            () => new EagerGestureRecognizer(),
      ),
    ].toSet(),
    initialCameraPosition: CameraPosition(
      target: LatLng(latitude == null ? 0: latitude, longitude == null ? 0 : longitude),
      zoom: 20,
    ),
    onMapCreated: (controller)  {
      print(latitude.toString() + longitude.toString());
      controller.animateCamera(
          CameraUpdate.newLatLngZoom(
              LatLng(latitude, longitude), 20));
    },
    onCameraMove: (cameraPosition) async{
      latitude = cameraPosition.target.latitude;
      longitude = cameraPosition.target.longitude;
//      var address =  await Geocoder.local.findAddressesFromCoordinates(Coordinates(latitude, longitude));
//      userAddress.text = address.first.addressLine;
//        print(latitude);
//        print(longitude);
    },
    onCameraIdle: () async{
      var address =  await Geocoder.local.findAddressesFromCoordinates(Coordinates(latitude, longitude));
      userAddress.text = address.first.addressLine;
        print(userAddress.text);
        print(longitude);
    },

  );
}