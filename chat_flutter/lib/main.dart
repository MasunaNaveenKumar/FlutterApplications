import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import 'package:chatflutter/chat_window.dart';

void main() => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String userName;
  final userNameController = TextEditingController();

  String password;
  final passwordController = TextEditingController();

  String toastMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Room"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: userNameController,
              decoration: InputDecoration(
                  hintText: "Enter User name",
                  labelText: "User Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: "Enter Password",
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    getlogin();
                  },
                  child: Text("Login"),
                ),
                SizedBox(width: 10.0),
                RaisedButton(
                  onPressed: () {
                    getRegister();
                  },
                  child: Text("Register"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getlogin() async
  {
    userName = userNameController.text;
    password = passwordController.text;
    Response response = await get("http://165.22.14.77:8080/Naveen/24mayWebChat/login.jsp?uName=" + userName + "&pswd=" + password);
    print(response.body);
    if(response.body.contains("Login success")){
      print("Navigate to chat window");

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatWindow(username: userName)),
      );
    }
    else{
      toastMessage = "Incorrect Username or Password";
      displayToast();
    }
  }

  void getRegister() async
  {
    userName = userNameController.text;
    password = passwordController.text;
    Response response = await get("http://165.22.14.77:8080/Naveen/24mayWebChat/register.jsp?UserName="+userName+"&Password="+password);
    print(response.body);
    if(response.body.contains("Registered successfully")){
      toastMessage = "Successfully Registered please login.";
      displayToast();
    }
  }

  void displayToast()
  {
    Fluttertoast.showToast(
        msg: toastMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
