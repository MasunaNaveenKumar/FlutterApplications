import 'package:flutter/material.dart';
import 'call.dart';
import 'globalvariables_and_functions.dart';

List<Widget> listOfDynamicWidgetsInBottomSheet = [];
void callingWidgets(List record)
{
  listOfDynamicWidgetsInBottomSheet.clear();
  bool forEachDone=true;

  for(int counter=7; counter < record.length; counter++)
  {
    listOfDynamicWidgetsInBottomSheet.add(
      Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.label_important),
            iconSize: 50.0,
          ),
          Text(fieldNamesList[counter] + ": " + record[counter].toString().replaceAll("null", "Not available")),
        ],
      ),
    );
  }
}

void showInfoBottomSheet(List record, BuildContext context)
{
  callingWidgets(record);

  double distanceFromCurrentLocation = double.parse(record[6]);
  showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                color: Colors.blueGrey[300],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          record[1],
                          style: TextStyle(
                            fontSize: 40.0,
                          ),
                        ),
//                        Text("4.7Km away from you."),
                        Text(distanceFromCurrentLocation.toStringAsFixed(2) + "Km away from you."),
                      ],
                    ),
                    SizedBox(width: 20.0,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.call),
                          iconSize: 50.0,
                          highlightColor: Colors.pink,
                          onPressed: () {
//                            showToast("Call icon clicked");
                            makePhoneCall(record[0]);
                          },
                        ),
                        Text("Call"),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 200,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.mail_outline),
                            iconSize: 50.0,
                          ),
                          Text(record[2],),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.location_city),
                            iconSize: 50.0,
                          ),
                          Flexible(
                            child: Text(record[3],
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      Column(
                          children: listOfDynamicWidgetsInBottomSheet
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
  );
}

























////import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';
//
//import 'globalvariables_and_functions.dart';
////import 'call.dart';
////
////void showInfoBottomSheet(Map record, BuildContext context)
////{
////  double distanceFromCurrentLocation = double.parse(record['Distance']);
////  showModalBottomSheet<void>(
////      context: context,
////      builder: (BuildContext context) {
////        return Container(
////          height: 300,
////          child: Column(
////            children: <Widget>[
////              Container(
////                height: 100,
////                color: Colors.blueGrey[300],
////                child: Row(
////                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
////                  children: <Widget>[
////                    Column(
////                      mainAxisAlignment: MainAxisAlignment.center,
////                      mainAxisSize: MainAxisSize.min,
////                      children: <Widget>[
////                        Text(
////                          record['UserName'],
////                          style: TextStyle(
////                            fontSize: 40.0,
////                          ),
////                        ),
//////                        Text("4.7Km away from you."),
////                        Text(distanceFromCurrentLocation.toStringAsFixed(2) + "Km away from you."),
////                      ],
////                    ),
////                    SizedBox(width: 20.0,),
////                    Column(
////                      mainAxisAlignment: MainAxisAlignment.center,
////                      mainAxisSize: MainAxisSize.min,
////                      children: <Widget>[
////                        IconButton(
////                          icon: Icon(Icons.call),
////                          iconSize: 50.0,
////                          highlightColor: Colors.pink,
////                          onPressed: () {
//////                            showToast("Call icon clicked");
////                            makePhoneCall(record['MobileNumber']);
////                          },
////                        ),
////                        Text("Call"),
////                      ],
////                    ),
////                  ],
////                ),
////              ),
////              Container(
////                height: 200,
////                color: Colors.white,
////                child: Column(
////                  crossAxisAlignment: CrossAxisAlignment.center,
////                  children: <Widget>[
////                    Row(
////                      children: <Widget>[
////                        IconButton(
////                          icon: Icon(Icons.mail_outline),
////                          iconSize: 50.0,
////                        ),
////                        Text(record['EmailId'],),
////                      ],
////                    ),
////                    Row(
////                      children: <Widget>[
////                        IconButton(
////                          icon: Icon(Icons.location_city),
////                          iconSize: 50.0,
////                        ),
////                        Text(record['UserAddress']),
////                      ],
////                    ),
////                  ],
////                ),
////              ),
////            ],
////          ),
////        );
////      }
////  );
////}
////
//
//import 'package:flutter/material.dart';
//import 'call.dart';
//
//List<Widget> listOfDynamicWidgetsInBottomSheet = [];
//void callingWidgets(Map record)
//{
//  listOfDynamicWidgetsInBottomSheet.clear();
//  bool forEachDone=true;
//  record.forEach((key, value) {
//    if(key == 'MobileNumber')
//    {
//      forEachDone=false;
//    }
//    if(forEachDone)
//    {
//      listOfDynamicWidgetsInBottomSheet.add(
//        SingleChildScrollView(
//          scrollDirection: Axis.horizontal,
//          child: Align(
//            alignment: Alignment.centerLeft,
//            child: Row(
//              children: <Widget>[
//                IconButton(
//                  icon: Icon(Icons.label_important),
//                  iconSize: 50.0,
//                ),
//                Text(key + ": " +value.toString()),
//              ],
//            ),
//          ),
//        ),
//      );
//    }
//  });
//}
//
//void showInfoBottomSheet(Map record, BuildContext context)
//{
//  callingWidgets(record);
//
//  double distanceFromCurrentLocation = double.parse(record['Distance']);
//  showModalBottomSheet<void>(
//      context: context,
//      builder: (BuildContext context) {
//        return Container(
//          height: 300,
//          child: Column(
//            children: <Widget>[
//              Container(
//                height: 100,
//                color: Colors.blueGrey[300],
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: <Widget>[
//                    Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      mainAxisSize: MainAxisSize.min,
//                      children: <Widget>[
//                        Text(
//                          record['UserName'],
//                          style: TextStyle(
//                            fontSize: 40.0,
//                          ),
//                        ),
////                        Text("4.7Km away from you."),
//                        Text(distanceFromCurrentLocation.toStringAsFixed(2) + "Km away from you."),
//                      ],
//                    ),
//                    SizedBox(width: 20.0,),
//                    Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      mainAxisSize: MainAxisSize.min,
//                      children: <Widget>[
//                        IconButton(
//                          icon: Icon(Icons.call),
//                          iconSize: 50.0,
//                          highlightColor: Colors.pink,
//                          onPressed: () {
////                            showToast("Call icon clicked");
//                            makePhoneCall(record['MobileNumber']);
//                          },
//                        ),
//                        Text("Call"),
//                      ],
//                    ),
//                  ],
//                ),
//              ),
//              Container(
//                height: 200,
//                color: Colors.white,
//                child: SingleChildScrollView(
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//                      Row(
//                        children: <Widget>[
//                          IconButton(
//                            icon: Icon(Icons.mail_outline),
//                            iconSize: 50.0,
//                          ),
//                          Text(record['EmailId'],),
//                        ],
//                      ),
//                      SingleChildScrollView(
//                        scrollDirection: Axis.horizontal,
//                        child: Row(
//                          children: <Widget>[
//                            IconButton(
//                              icon: Icon(Icons.location_city),
//                              iconSize: 50.0,
//                            ),
//                            Text(record['UserAddress'].toString()),
//                          ],
//                        ),
//                      ),
//                      Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: listOfDynamicWidgetsInBottomSheet
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ],
//          ),
//        );
//      }
//  );
//}
