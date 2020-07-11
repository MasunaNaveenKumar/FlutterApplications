import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:mobile_number/mobile_number.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ServiceCancellation extends StatefulWidget {
  @override
  _ServiceCancellationState createState() => _ServiceCancellationState();
}

class _ServiceCancellationState extends State<ServiceCancellation> {
  List<Widget> listOfWidgets = [];
  TextEditingController txtMobileNumber = new TextEditingController();
  Map<String,bool> services = {};
  final _formKey = GlobalKey<FormState>();
  var list;
  var message;
  void disableServices() async
  {
    var dataToServer = "";
    int counter=0;
    list.forEach((str){
      if(services[str]==true)
      {
        if(counter==0)
        {
          dataToServer = str;
        }
        else
        {
          dataToServer = dataToServer+"/"+str;
        }
        counter++;
      }
    });
    dataToServer = dataToServer+"/"+txtMobileNumber.text;
    print(dataToServer);
    print(counter);
    if(counter != 0){
      setState(() {
        listOfWidgets.clear();
        listOfWidgets.add(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Disabling services...")
              ],
            )
        );
      });
      Response response = await get("http://165.22.14.77:8080/LakshmaReddy/DisableServices.jsp?dataFromClientSide="+dataToServer);
      setState(() {
        if(int.parse(response.body) == counter)
        {
          message="Successfully disabled";
        }
        else
        {
          message = "Error occured. Please try again.";
        }
        showToast();
        Navigator.pop(context);
      });}
    else
    {
      setState(() {
        message="No services selected to disable";
        showToast();
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTextBoxAndButton();
  }
  void getServicesToDisable() async
  {
    Response response = await get(
        "http://165.22.14.77:8080/LakshmaReddy/GetServicesToDisable.jsp?MobileNumber=" +
            txtMobileNumber.text);
    print(response.body);
    list = json.decode(response.body);
    print(list);
    bool _valueCheck = false;
    setState(() {
      listOfWidgets.clear();
      list.forEach((service){
        services[service] = false;
        setState(() {
          listOfWidgets.add(
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Center(
                      child: CheckboxListTile(
                        title: Text(service),
                        value: services[service],
                        onChanged: (bool value) {
                          setState(() {
                            services[service] = value;
                          });
                        },
                      ),
                    );
                  })
          );
        });
      });
      listOfWidgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text("Submit"),
                onPressed: (){
                  disableServices();
                },
              ),
              RaisedButton(
                child: Text("Cancel"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          )

      );
    });
  }

  void validatePhoneNumber() async
  {
    Response response = await get("http://165.22.14.77:8080/LakshmaReddy/ValidateWhileDisable.jsp?MobileNumber="+txtMobileNumber.text);
    if(response.body.contains("InValid"))
    {
      message="Not a valid user";
      print(message);
      showToast();
      Navigator.pop(context);
    }
    else
    {
      print("Valid user");
      getServicesToDisable();
    }
  }
  void loadTextBoxAndButton()
  {
    listOfWidgets.addAll([
      Container(
        width: 200,
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: txtMobileNumber,
            decoration: InputDecoration(labelText: 'Mobile number'),
            keyboardType: TextInputType.phone,
            autofocus: true,
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
          ),
        )
      ),
      RaisedButton(
        child: Text("Submit"),
        onPressed: ()
        {
          if(_formKey.currentState.validate())
            {
              checkDeviceMobileNumber();
            }

        },
      )
    ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cancel my registration"),
      ),
      body: Center(
        child: Column(
            children: listOfWidgets
        ),
      ),
    );
  }

  void checkDeviceMobileNumber() async
  {
    final List<SimCard> simCards = await MobileNumber.getSimCards;
    var flag = 0;
    for(var element in simCards)
    {
      if(element.number.contains(txtMobileNumber.text))
      {
        validatePhoneNumber();
        flag=1;
        print("Mobile number which you entered is in the current device");
        break;
      }
    }
    if(flag==0)
    {
      message="Entered mobile number is not in device.";
      showToast();
      Navigator.pop(context);
    }
  }
  void showToast()
  {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
    );
  }

}