import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:location/location.dart';

Location location = new Location();

bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;

void checkNetworkState() async
{
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    print("Connected to internet.");
  } else {
    print("Not connected to internet.");
  }
}


void checkGPSState() async
{
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled){
    print("GPS Disabled");
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      print("GPS Disabled");
      SystemNavigator.pop();
    }
    else
    {
      print("GPS Enabled.");
    }
  }
  else
  {
    print("GPS Enabled.");
  }
}