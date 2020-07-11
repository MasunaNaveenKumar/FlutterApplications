import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:give/registration_hint.dart';
import 'package:give/service_cancellation.dart';
import 'globalvariables_and_functions.dart';
import 'package:http/http.dart';
import 'map.dart';
import 'registration.dart';
import 'serviceLocation.dart' as locationFile;

void main() {
  runApp(MaterialApp(initialRoute: '/home', routes: {
    '/home': (context) => Home(),
  }));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: SafeArea(child: MyHomePage(title: appTitle)),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map serviceList;
  TextEditingController feedbackController = new TextEditingController();
  final feedbackFormKey = GlobalKey<FormState>();
  List<String> childServiceList = [];
  Drawer drawer;
  final globalKey = GlobalKey<ScaffoldState>();
  List<Widget> listOfTiles = [];
  List<String> parentServiceIdList = [];
  List<String> serviceIdList = [];


  void changeDrawer(String id) {
    int counter = 0;
    setState(() {
      listOfTiles.clear();
      serviceList.forEach((key, value) {
        registerButtonStatus = true;
        if (serviceList[key][1] == id) {
          if (counter == 0) {
            counter++;
            addBackButtonToDrawer(id);
          }
          if (childServiceList.contains(key) &&
              id == serviceList[key][1]) {
            if (serviceList[key][2]
                .toString()
                .contains("0")) {
              setState(() {
                print(serviceList[key][2]);
                registerButtonStatus = false;
              });
            }
            listOfTiles.add(
              ListTile(
                leading: Container(
                    height: 35,
                    width: 35,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/loading.gif',
                      image: staticUrl + 'Icons/' + key + '.png' ,
                    ),

                ),
// trailing: Visibility(
// visible: registerButtonStatus,
// child: Container(
// height: 30,
// child: RaisedButton(
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(20.0)),
// child: Text('Register'),
// onPressed: () {
// print(serviceList[key][0]);
// Navigator.pop(context);
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => Registration(key),
// ),
// );
// showMenuDrawer();
// },
// ),
// ),
// ),
                title: Text(serviceList[key][0]),
                onTap: () {
                  setState(() {
                    if (serviceList[key][2]
                        .toString()
                        .contains("0")) {
                      setState(() {
                        print(serviceList[key][2]);
                        registerButtonStatus = false;
                      });
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GMap(key, serviceList[key][0])),
                    );
                    print("\nSelected ${serviceList[key][0]}\n");
                  });
                },
              ),
            );
          } else {
            listOfTiles.add(
              ListTile(
                leading: Container(
                    height: 35,
                    width: 35,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/loading.gif',
                      image: staticUrl + 'Icons/' + key + '.png' ,
                    ),

                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black12,
                ),
                title: Text(serviceList[key][0]),
                onTap: () {
                  setState(() {
                    changeDrawer(key);
                  });
                },
              ),
            );
          }
        }
      });
      drawer = Drawer(
        child: SingleChildScrollView(
          child: Column(children: listOfTiles),
        ),
      );
    });
  }

  void addBackButtonToDrawer(String id) {
    listOfTiles.add(
      ListTile(
        leading: Icon(
          Icons.keyboard_backspace,
          color: Colors.blue,
        ),
        title: Text("back"),
        onTap: () {
          if (id == "0") {
            showMenuDrawer();
          } else {
            changeDrawer(serviceList[id][1]);
          }
        },
      ),
    );
  }

  showMenuDrawer() {
    setState(() {
      drawer = Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                appTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 27.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.blue,
              ),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.build,
                color: Colors.blue,
              ),
              title: Text('Services'),
              onTap: () {
                setState(() {
                  changeDrawer("0");
                });
              },
            ),
            ListTile(
              leading: Icon(
                Icons.clear,
                color: Colors.blue,
              ),
              title: Text('Cancel my registration'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceCancellation(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.highlight,
                color: Colors.blue,
              ),
              title: Text('Registration hint'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationHint(),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Future<bool> sendFeedback() async {
    var feedbackResponse = await post(
        'http://165.22.14.77:8080/Anwesh/Give/sendFeedback.jsp?Feedback=${feedbackController.text}');
    if (feedbackResponse.statusCode == 200) {
      showToastMessage(feedbackResponse.body.trim());
      return true;
    } else {
      showToastMessage("No internet connection.");
      return false;
    }
  }

  getFieldNamesFromApi() async {
    var url = "http://165.22.14.77:8080/Anwesh/Give/getServices.jsp";
    Response response = await get(url);
    Map mapData = json.decode(response.body);
    serviceList = mapData;
    serviceList.forEach((key, value) {
      parentServiceIdList.add(serviceList[key][1]);
      serviceIdList.add(key);
    });
    serviceList.forEach((key, value) {
      parentServiceIdList.add(serviceList[key][1]);
      serviceIdList.add(key);
    });
    for (int counter = 0; counter < serviceIdList.length; counter++) {
      if (!parentServiceIdList.contains(serviceIdList[counter])) {
        childServiceList.add(serviceIdList[counter]);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getFieldNamesFromApi();
    showMenuDrawer();
    locationFile.firstLocation();
    locationFile.loadMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: globalKey,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      drawer: drawer,
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: Stack(
          children: <Widget>[
            googlemap,
            Positioned(
              bottom: 20,
              child: FlatButton(
                textColor: Colors.black87,
                onPressed: () {
                  _showMyDialog();
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Icon(
                            Icons.feedback,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      TextSpan(
                          text: 'Feedback',
                          style: TextStyle(fontSize: 18, color: Colors.blue)),
                    ],
                  ),
                ),
                shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (globalKey.currentState.isDrawerOpen) {
      Navigator.pop(context); // closes the drawer if opened
      return Future.value(false); // won't exit the app
    } else {
      return (await showDialog(
        context: context,
        builder: (context) =>
        new AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to exit this App'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: new Text('Yes'),
            ),
          ],
        ),
      )) ?? false;
    }
  }


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15)),
// title: Text('Feedback', style: TextStyle(fontSize: 10),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 150, 0),
                    child: Text("Feedback",textAlign: TextAlign.left,)),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextField(
                      controller: feedbackController,
                      minLines: 5,
                      maxLines: 5,
                      autocorrect: true,
                      autofocus: true,
                      decoration: InputDecoration(
// hintText: 'Write your feedback here',
                        filled: true,
                        fillColor: Color(0xFFDBEDFF),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),

                Row(
                  children: <Widget>[
                    ButtonTheme(
                      minWidth: 1,
                      child: FlatButton(
//                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text('Cancel'),
                        onPressed: () {
                          feedbackController.text = '';
                          Navigator.of(context).pop();
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 1,
                      child: FlatButton(
                        child: Text('Clear'),
                        onPressed: () {
                          setState(() {
                            feedbackController.text = '';
                          });

                        },
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 1,
                      child: FlatButton(
                        child: Text('Submit'),
                        onPressed: () async {
                          if (feedbackController.text.isNotEmpty) {
                            if (await sendFeedback()) {
                              Navigator.of(context).pop();
                              feedbackController.text = '';
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}