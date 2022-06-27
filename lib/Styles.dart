import 'package:flutter/material.dart';
import 'Database.dart';

class ButtonStyles {
  static dayStyle(DateTime day,List<int>schedule, String callPlace) {
    //вычисление окрашивания дня недели по дате и имени выбранного пользователя
    var style = ButtonStyles.simpleDayButtonStyle;
    if ((day.year == DateTime.now().year) &&
        (day.month == DateTime.now().month) &&
        (day.day == DateTime.now().day)&&
        (callPlace=='main'))
    {
      style = ButtonStyles.currentDayButtonStyle;//проверка на текущий день и окрашивание его другим цветом
    }
    else {

      if (Schedules.getWorkingDay(day, schedule)==1)//работа в день
          {
      style = ButtonStyles.workingDayButtonStyle;
      }
      else
      if(Schedules.getWorkingDay(day, schedule)==2)//работа в ночь
          {style = ButtonStyles.workingNightButtonStyle;}
      else
      {
      style = ButtonStyles.simpleDayButtonStyle;
      }
      }

    return style;
  }
static BoxDecoration eventBoxDecoration = BoxDecoration(//Определение ивента и окрашивание в цвет
  borderRadius: const BorderRadius.all(Radius.circular(5)),
  color: Colors.orangeAccent,
  border: Border.all(color: Colors.white));
  static BoxDecoration simpleBoxDecoration = BoxDecoration(
    //  color: Colors.white,
    border: Border.all(color: Colors.white),
  );


  static ButtonStyle usersListButtonStyle = ButtonStyle(
      textStyle:
          MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 15)),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(1.0)));

  static ButtonStyle workingNightButtonStyle = ButtonStyle(
      elevation: MaterialStateProperty.all(0.0),
      textStyle:
      MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 15)),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.black45),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(0.0)));
  static ButtonStyle workingDayButtonStyle = ButtonStyle(
    elevation: MaterialStateProperty.all(0.0),
      textStyle:
          MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 15)),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.black45),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(0.0)));

  static ButtonStyle currentDayButtonStyle = ButtonStyle(
      elevation: MaterialStateProperty.all(0.0),
      textStyle:
          MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 15)),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(0.0)));

  static ButtonStyle headerButtonStyle = ButtonStyle(
      elevation: MaterialStateProperty.all(0.0),
      textStyle:
          MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 15)),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(0.0)));
  static ButtonStyle simpleDayButtonStyle = ButtonStyle(
      elevation: MaterialStateProperty.all(0.0),
      textStyle:
          MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 15)),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.black26),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(0.0)));
  static ButtonStyle fadedDayButtonStyle = ButtonStyle(
      elevation: MaterialStateProperty.all(0.0),
      textStyle:
          MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 12)),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(0.0)));
}
