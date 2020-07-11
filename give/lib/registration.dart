import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'serviceLocation.dart' as locationFile;
import 'package:flutter/services.dart';
import 'globalvariables_and_functions.dart';

// ignore: must_be_immutable
class Registration extends StatefulWidget {
String _serviceId;
  Registration(this._serviceId);

  @override
  _RegistrationState createState() => _RegistrationState(_serviceId);
}

class _RegistrationState extends State<Registration> {
  List<Widget> listOfWidgets = [];
  List<Widget> listOfForms = [];
  List<TextEditingController> listOfControllers = [];
  List<String> data = [];
  List<String> headerList = [];
  List<String> fieldNameList = [];
  String fieldValues;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget googleMapWidget;


  TextEditingController userName = new TextEditingController();
  TextEditingController mobileNumber = new TextEditingController();
  TextEditingController emailId = new TextEditingController();

  double mapWidth, mapHeight, iconSize;


  String
      userLatitude = "0",
      userLongitude = '0',
      serviceName = "",
      serviceId,
      registrationPrompt = "",
      userIp = "";
  List<String> fieldNames = [];
  _RegistrationState(this.serviceId);

  autoFillMobileNumber() async{
    print('\n\n\n mbl nmbr\n');
    var deviceMobileNumber = await getMobileNumberFromDevice();
 print(deviceMobileNumber);
 setState(() {
   mobileNumber.text = deviceMobileNumber;
 });
    print('\n mbl nmbr\n\n\n');
  }


  addWidgetsToList() {

    listOfWidgets.clear();
    listOfWidgets.add(
        Container(
          child: Text(
            "$serviceName Registration",
            style: TextStyle(fontSize: 23, color: Colors.brown),
          ),
        )
    );
    if(registrationPrompt.length > 0)
    {
      listOfWidgets.add(
        Container(
//          color: Colors.yellowAccent[100],
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text(
            registrationPrompt,
            style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    listOfWidgets.add(TextFormField(
      controller: userName,
      decoration: InputDecoration(labelText: 'Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name can\'t be empty.';
        }
        if (!RegExp(
            r"""^[a-zA-Z0-9_\- \'+"=@,\.;]+$""")
            .hasMatch(value)) {
          return """Allowed characters [a-zA-Z0-9_\"-'=@,\.;]+""";
        }
        return null;
      },
    ));

    listOfWidgets.add(TextFormField(
      controller: mobileNumber,
      decoration: InputDecoration(labelText: 'Mobile number'),
      keyboardType: TextInputType.phone,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Mobile number can\'t be empty.';
        }
        if(value.length != 10)
          {
            return 'Please enter a valid mobile number.';
          }
        return null;
      },
    ));

    listOfWidgets.add(TextFormField(
      controller: emailId,
      decoration: InputDecoration(labelText: 'Email'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email Id can\'t be empty.';
        }
        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email address.';
        }
        return null;
      },
      onSaved: (String val) {
        emailId.text = val;
      },
    ));


    for (int index = 0; index < fieldNames.length; index++) {
      listOfControllers.add(TextEditingController());
      listOfWidgets.add(TextFormField(
          validator: (String value) {
            if (value.isEmpty) {
              return '${fieldNames[index]} can\'t be empty.';
            }
            if (!RegExp(
                r"""^[a-zA-Z0-9_\- +=@,'\".;]+$""")
                .hasMatch(value)) {
              return """Allowed characters [a-zA-Z0-9_"\'-=@,\.;]+""";
            }
            return null;
          },
          controller: listOfControllers[index],
          decoration: InputDecoration(labelText: fieldNames[index])));
    }

    listOfWidgets.add(TextFormField(
      controller: userAddress,
      decoration: InputDecoration(labelText: 'Address'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Address can\'t be empty.';
        }
        if (!RegExp(
            r"""^[a-zA-Z0-9_\- =@+,'\".;]+$""")
            .hasMatch(value)) {
          return """Allowed characters [a-zA-Z0-9'"_\-=@,\.;]+""";
        }
        return null;
      },
    ));

    listOfWidgets.addAll([
      Container(
        margin: EdgeInsets.fromLTRB(0, 20, 105, 10),
        child: Text("Please set your service location:", textAlign: TextAlign.left, style: TextStyle(fontSize: 16),),
      ),
      Column(
        children: <Widget>[
          new Stack(alignment: Alignment(0.0, 0.0), children: <Widget>[
            new Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                width: mapWidth,
                height: mapHeight,
                child: googlemap),
            new Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
              child:
              new Icon(Icons.location_on, size: iconSize, color: Colors.red),
            ),
          ]),
        ],
      )]);

    listOfWidgets.add(Container(
        margin: EdgeInsets.fromLTRB(0, 15, 0, 50),
        child: RaisedButton(
          child: Text("Submit"),
          onPressed: () {
            _formKey.currentState.save();
            _formKey.currentState.validate()
                ? submitData()
                : showMessageUsingSnackBar("Please fill all details.");
          },
        )));
  }

  submitData() {
    setState(()
    {
//      print(GMap().latitude.toString());
      userLatitude = latitude.toString();
      print(userLatitude);
      print('\n');
      userLongitude = longitude.toString();
      print(userLongitude);
    });
    fieldNameList.clear();
    fieldValues = '';
    fieldNameList.addAll(['ServiceId', 'MobileNumber', 'UserName', 'EmailId', 'UserAddress', 'Latitude', 'Longitude', 'UserCity' ]);
    fieldValues =  serviceId + '~~'+ mobileNumber.text + '~~'+ userName.text + '~~'+ emailId.text + '~~'+ userAddress.text + '~~'+ userLatitude + '~~'+ userLongitude + '~~'+ userCity;

    for (int index = 0; index < fieldNames.length; index++) {
      fieldNameList.add('FieldValue${index + 1}');
        fieldValues = fieldValues + '~~' + listOfControllers[index].text;
    }
    registerService();
  }

  getFieldNamesFromApi() async {
    var url =
        "http://165.22.14.77:8080/Anwesh/Give/getFieldNames.jsp?ServiceId=${serviceId}";
    var response = await read(url);

    var parsedJson = json.decode(response.trim());

    String headers = parsedJson["headers"];
    headers = headers.replaceAll("[", "");
    headers = headers.replaceAll("]", "");
    if (response.contains("field names")) {
      String fieldNameList = parsedJson["field names"];
      fieldNameList = fieldNameList.replaceAll("[", "");
      fieldNameList = fieldNameList.replaceAll("]", "");
      setState(() {
        fieldNames = fieldNameList.split(", ");
      });
    }

    setState(() {
      headerList = headers.split(", ");
      serviceName = headerList[0];
      if (headerList.length > 1) {
        registrationPrompt = headerList[1];
      }
    });
  }


  registerService() async {
    print(fieldValues);
    String postUrl =
        'http://165.22.14.77:8080/Anwesh/Give/Register.jsp?fieldNameList=${fieldNameList.toString().replaceAll("[", "").replaceAll("]", "")}&fieldValues=${fieldValues.replaceAll("+", "%2B")}';
    print(postUrl);
    Response apiResponse = await post("${postUrl.replaceAll("'", "'")}");
    if (apiResponse.statusCode == 200) {
      print("\nResponse\n");
      print(apiResponse.body);
      print("\nResponse\n");
      showMessageUsingSnackBar(apiResponse.body.trim());
      if (apiResponse.body.contains("Registered"))
      {

        showToastMessage(apiResponse.body.trim());
        _formKey.currentState.reset();
        Navigator.popAndPushNamed(context, "/home");

      }
    }
    else
    {
      showMessageUsingSnackBar("No internet connection.");
    }
  }

  void showMessageUsingSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  @override
  void initState() {
    // TODO: implement initState
    autoFillMobileNumber();
    locationFile.firstLocation();
    locationFile.loadMap();
    getFieldNamesFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    addWidgetsToList();

    mapWidth = 300;
    mapHeight = 300;
    iconSize = 40.0;
    return new MaterialApp(
      title: appTitle,
      home: new Scaffold(
        key: _scaffoldKey,
//        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: new Text('Registration Form'),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: listOfWidgets,
              ),
            ),
          ),
        ),
      ),
    );

  }
}
