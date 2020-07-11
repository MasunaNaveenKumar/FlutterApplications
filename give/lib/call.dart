import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

makePhoneCall(String number) async
{
//  const number = '9963383211'; //set the number here
  bool res = await FlutterPhoneDirectCaller.callNumber(number);
}