import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'bottom_sheet.dart';
import 'global_variables_and_functions.dart';
import 'registration.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class GMap extends StatefulWidget {
  String serviceId, serviceName;
  GMap(this.serviceId, this.serviceName);
  @override
  _GMapState createState() => _GMapState(serviceId, serviceName);
}

class _GMapState extends State<GMap> {
  String serviceId, serviceName;
  _GMapState(this.serviceId, this.serviceName);

  @override
  //get default UserCoordinates at the time of app opening.
  LatLng userCoordinates = LatLng( latitude == null ? 17.38: latitude, longitude == null ? 78.48 : longitude); // Hyderabad
  GoogleMapController gMapController;
  Set<Marker> markers = Set<Marker>();

  Location currentLocation = Location();

  List<double> latList = [];
  List<double> longList = [];

  Future<Uint8List> getBytesFromCanvas(String text) async {

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.black;
    final int size = 100; //change this according to your app
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,//you can write your own text here or take from parameter
      style: TextStyle(
          fontSize: size / 4, color: Colors.white, fontWeight: FontWeight.bold),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
    );

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  Future<void> addServiceProvidersMarkers(List record)
  async {
    double distanceFromCurrentLocation = double.parse(record[6]);
//    String titleInfo = record['UserName'];

    final Uint8List desiredMarker = await getBytesFromCanvas('GIVE');

    print(record);
    setState(() {
      try
      {
        latList.add(double.parse(record[4]));
        longList.add(double.parse(record[5]));

        markers.add(Marker(
          markerId: MarkerId(record[1]),
          position: LatLng(double.parse(record[4]), double.parse(record[5])),
          icon: BitmapDescriptor.fromBytes(desiredMarker),
          alpha: 0.5,
          infoWindow: InfoWindow(title: distanceFromCurrentLocation.toStringAsFixed(2) + "Km away"),
          onTap: ()
          {
            showInfoBottomSheet(record, context);
          },
        ));
      }
      catch(e)
      {
        print(e);
      }
    });
  }

  void getServiceProviders() async
  {
    double lat1 = userCoordinates.latitude;
    double lon1 = userCoordinates.longitude;
    Response userInfo = await get("http://165.22.14.77:8080/Give/Apis/getServiceProvidersInfo.jsp?lat1=$lat1&lon1=$lon1&serviceId=$serviceId");
    print(userInfo.body);
    List listOfServiceProviders = jsonDecode(userInfo.body);
    print(listOfServiceProviders.length);
    fieldNamesList = listOfServiceProviders[0];

    print(fieldNamesList);

    for(int counter=1; counter < listOfServiceProviders.length; counter++) {
      addServiceProvidersMarkers(listOfServiceProviders[counter]);
    }
  }


  void addUserMarker()
  {
    //throws an error if marker id is not found.
    setState(() {
      try
      {
        markers.removeWhere(
                (m) => m.markerId.value == 'userPin');
      }
      catch(e)
      {
        print(e);
      }
      markers.add(Marker(
        markerId: MarkerId('userPin'),
        position: userCoordinates, // updated position
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure
        ),
        infoWindow: const InfoWindow(title: 'You are here!'),
      ));
      gMapController.showMarkerInfoWindow(MarkerId('userPin'));
    });
  }

  void onMapCreated(GoogleMapController controller)  async{
    gMapController = controller;
    //getLocation waits and throws an error if permission is not granted.
    try
    {
      LocationData position =  await currentLocation.getLocation().timeout(const Duration(seconds: 30));
      //set time limit if not checking for gps status.
      print(position.latitude);
      print(position.longitude);
      userCoordinates = LatLng(position.latitude, position.longitude);
    }
    on TimeoutException catch(e)
    {
      print(e);
    }
    catch(e)
    {
      print(e);
    }
    latList.add(userCoordinates.latitude);
    longList.add(userCoordinates.longitude);
    addUserMarker();
    await getServiceProviders();
    latList.sort();
    longList.sort();
    print("testing testing testing");
    print(latList);
    print(longList);
    //Adjusts camera position to show all available markers.
    if(latList.length > 1)
    {
      print("In LatLngBounds");
      controller.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(latList.first,longList.first),
            northeast: LatLng(latList.last, longList.last),
          ),
          100
      ));
    }

    //continuous location updates for live tracking.
    currentLocation.onLocationChanged.listen((loc) {
      if(loc != null)
      {
        print("Inside onLocation changed");
        userCoordinates = LatLng(loc.latitude, loc.longitude);
        addUserMarker();
      }
    });
  }

  Widget build(BuildContext context) {
    return
      SafeArea(
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar:  AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: new Text(serviceName),
            ),
            body: Stack(
              children: <Widget>[
                Center(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(target: userCoordinates, zoom:10),
                    onMapCreated: onMapCreated,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    markers: markers,
                  ),
                ),

                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Visibility(
                    visible: registerButtonStatus,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>Registration(serviceId),
                          ),);
                        },
                        child: Text("Register", style: TextStyle(fontSize: 15,),),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                  ),
                ),
//                  ),


              ],
            )
        ),
      )
    ;
  }
}