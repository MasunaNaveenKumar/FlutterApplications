import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:mobile_number/mobile_number.dart';
String userCity;
GoogleMap googlemap;
double cameraLatitude;
double cameraLongitude;
double latitude;
double longitude;
TextEditingController userAddress = new TextEditingController();
bool registerButtonStatus = false;
final appTitle = 'GIVE';
String staticUrl = 'http://165.22.14.77:8080/Give/';
List fieldNamesList;
int counter = 0;
var feedbackAddress;
var noInternetConnectionMessage = "Check your Internet Connection and try again.";
LatLng userCoordinates ;


void showToastMessage(String message) {
  Fluttertoast.showToast(
      toastLength: Toast.LENGTH_SHORT,
      msg: message,
      gravity: ToastGravity.BOTTOM);
}

Future<String> getMobileNumberFromDevice() async
{
  String mobileNumber = await MobileNumber.mobileNumber;
  return mobileNumber.substring(2);
}

Future<bool> checkInternetConnection() async
{
  print('\n\nInternet permission');
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      return true;
    }
    else{
      return false;
    }
  } on SocketException catch (_) {
    print('not connected');
    return false;
  }
}