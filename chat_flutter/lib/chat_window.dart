import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:async'; // for timer
import 'package:fluttertoast/fluttertoast.dart';

class ChatWindow extends StatefulWidget {
  final String username;
  ChatWindow({Key key, this.username}) : super(key: key);

  @override
  _ChatWindowState createState() => _ChatWindowState(username);
}

class _ChatWindowState extends State<ChatWindow> {
  String username;
  _ChatWindowState(String username) {
    this.username = username;
  }

  Timer timer;
  TextEditingController activeUsersController = TextEditingController();
  TextEditingController chatPanelController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) async {
      var activeusers = await http.read(
          "http://165.22.14.77:8080/Naveen/24mayWebChat/active_users.jsp?");
      var messages = await http.read(
          "http://165.22.14.77:8080/Naveen/24mayWebChat/show_messages.jsp?usrName=$username");
      setState(() {
        activeUsersController.text = activeusers.replaceAll("<br>","").trim();
        chatPanelController.text = messages.trim();
      });

      print("\n\n\n\n In init method\n\n\n\n");
    });
  }

  sendMessage() async {
    var sendStatus = await http.read("http://165.22.14.77:8080/Naveen/24mayWebChat/send_message.jsp?sName=$username&mSent=" + messageController.text);
    if (sendStatus.contains("Message sent successfully")) {
      setState(() {
        messageController.text = '';
      });
    } else {
      Fluttertoast.showToast(
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
          msg: "Message not sent",
          gravity: ToastGravity.BOTTOM);
    }
  }

  logout() async {
    var logoutResponse = await http.read("http://165.22.14.77:8080/Naveen/24mayWebChat/sign_out.jsp?uNam=$username");
    if(logoutResponse.contains("Logged out successfully")){
      Fluttertoast.showToast(
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          msg: "Successfully Logged out",
          gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Window"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                "Active users",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                    color: Colors.green,
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  width: 270,
                  height: 60,
                  child: SingleChildScrollView(
                      child: Text(
                        activeUsersController.text,
                        style: TextStyle(color: Colors.green),
                      ))),
              Text(
                "Messages",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.brown,
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  width: 270,
                  height: 200,
                  child: SingleChildScrollView(
                      child: Text(
                        chatPanelController.text,
                        style: TextStyle(color: Colors.brown),
                      ))),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: "Enter your message",
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              RaisedButton(
                onPressed: () {
                  sendMessage();
                },
                child: Text("Send Message"),
              ),
              SizedBox(height: 10.0),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    logout();
                    Navigator.pop(context);
                  });
                },
                child: Text("Sign out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
