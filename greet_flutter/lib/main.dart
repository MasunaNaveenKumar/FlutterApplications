import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MaterialApp(
  home: Greet(),
)
);

class Greet extends StatefulWidget {
  @override
  _GreetState createState() => _GreetState();
}

class _GreetState extends State<Greet> {

  String txt = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Greet Application'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(90.0),
        child: Center(
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
                TextField(
                  onChanged: (String str){
                  print(str);
                  txt = str;
                  },
                ),
               SizedBox(height: 10.0),
               Center(
                 child: RaisedButton(
                   onPressed: () {
                     setState(() {
                       Fluttertoast.showToast(
                           msg: "Hello $txt!",
                           toastLength: Toast.LENGTH_SHORT,
                           gravity: ToastGravity.CENTER,
                           timeInSecForIosWeb: 1,
                           backgroundColor: Colors.blue,
                           textColor: Colors.white,
                           fontSize: 16.0
                       );
                     });
                   },
                   child: Text("Say Hello"),
                 ),
               ),
             ]
          ),
        ),
      )
    );
  }
}

