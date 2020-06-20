import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MaterialApp(
  home: WeatherForecast(),
));

class WeatherForecast extends StatefulWidget {
  @override
  _WeatherForecastState createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {

  var cityName;
  final cityNameController = TextEditingController();

  String outputString;
  String temperature;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Forecast"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: cityNameController,
              decoration: InputDecoration(
                hintText: "Enter your city name"
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: RaisedButton(
                onPressed: () {
                  getTemperature();
                },
                child: Text("Get Temperature"),
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: RaisedButton(
                onPressed: () {
                  getTemperatureUsingLocation();
                },
                child: Text("Get Current Location Temperature"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getTemperature() async {
    cityName = cityNameController.text;
    Response response = await get('http://api.openweathermap.org/data/2.5/weather?q=' + cityName + '&appid=9a2b3712c20ace3faf7d2b02d0199080&units=metric');
    Map jsonDataFromServer = jsonDecode(response.body);
    if(jsonDataFromServer['cod'] == 200) {
      temperature = jsonDataFromServer['main']['temp'].toString();
      setState(() {
        outputString = "Temperature in " + cityName + " is "+temperature;
        displayToast();
      });
    }
    else {
      setState(() {
        outputString = "Invalid city name!";
        displayToast();
      });
    }
  }

  void getTemperatureUsingLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Response response = await get("http://api.openweathermap.org/data/2.5/weather?lat=" + position.latitude.toString() + "&lon=" + position.longitude.toString() + "&units=metric&appid=9a2b3712c20ace3faf7d2b02d0199080");
    Map jsonDataFromServer = jsonDecode(response.body);
    temperature = jsonDataFromServer['main']['temp'].toString();
    setState(() {
      outputString = "Temperature in your location is " + temperature;
      displayToast();
    });
  }

  void displayToast()
  {
    Fluttertoast.showToast(
        msg: "$outputString",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
