import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/Users/Users.dart';
import 'package:kip_calendar_v2/Menu/Menu.dart';
import 'package:kip_calendar_v2/Events/Events.dart';
import 'package:kip_calendar_v2/widgets.dart';


class ButtonStyles{
  static ButtonStyle usersListButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 15)),
      backgroundColor:
      MaterialStateProperty.all<Color>(Colors.white),
      foregroundColor:
      MaterialStateProperty.all<Color>(Colors.black),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(1.0)));

  static ButtonStyle dayEventsButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 15)),
      backgroundColor:
      MaterialStateProperty.all<Color>(Colors.white),
      foregroundColor:
      MaterialStateProperty.all<Color>(Colors.black),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(0.0)));


  static ButtonStyle workingDayButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 15)),
      backgroundColor:
      MaterialStateProperty.all<Color>(Colors.black26),
      foregroundColor:
      MaterialStateProperty.all<Color>(Colors.white),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(0.0)));

  static ButtonStyle currentDayButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 15)),
      backgroundColor:
      MaterialStateProperty.all<Color>(Colors.blueGrey),
      foregroundColor:
      MaterialStateProperty.all<Color>(Colors.black),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(0.0)));

 static ButtonStyle headerButtonStyle = ButtonStyle(
     textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 15)),
    backgroundColor:
    MaterialStateProperty.all<Color>(Colors.blueGrey),
    foregroundColor:
    MaterialStateProperty.all<Color>(Colors.white),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.all(0.0)));
 static ButtonStyle simpleDayButtonStyle = ButtonStyle(
     textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 15)),
     backgroundColor:
     MaterialStateProperty.all<Color>(Colors.white24),
     foregroundColor:
     MaterialStateProperty.all<Color>(Colors.white),
     padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
         const EdgeInsets.all(0.0)));
 static ButtonStyle fadedDayButtonStyle = ButtonStyle(
   textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 12)),
      elevation: MaterialStateProperty.all(0.0),
     backgroundColor:
     MaterialStateProperty.all<Color>(Colors.white),
     foregroundColor:
     MaterialStateProperty.all<Color>(Colors.grey),
     padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
         const EdgeInsets.all(0.0)));

}