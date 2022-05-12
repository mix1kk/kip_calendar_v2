import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'Database.dart';
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
// class CurrentUser{
//  static String selectedUserName = 'user';
//  static String selectedUserPassword = '';
//  static String selectedUserTableNumber = '001';
//  static String selectedUserPosition = 'position';
//  static DateTime selectedUserDateOfBirth = DateTime(2022);
//  static DateTime selectedUserDateOfEmployment = DateTime(2022);
//  static String selectedUserScheduleName = '0';
//  static String selectedUserPhoneNumber = '8 987 654 32 10';
//  static String selectedUserRole = 'user';
//  static bool selectedUserIsExpanded = false;
// }

 class Variables{
   static double rowHeight = 40.0; // Высота строк
   static double firstColumnWidth = 60.0; //Ширина первого столбца с номерами недели

  static Map<int,String> numbersForWorkingDays=
  {1: 'Я',
   2: 'Н',
   6: 'К',
   9: 'ОТ',
   10: 'ОД',
   17:'ОЗ',
   19:'Б',
   26:'В',
  };
  static Schedules currentSchedule=Schedules('0',List.filled(56, 26),false);
  //todo: сделать selectedSchedule
  static void setPrefs (name)async{
   SharedPreferences prefs = await _prefs;
   await prefs.setString('name',name);
  }

  static Future <void> getPrefs ()async{//считывание сохраненных данных(имя пользователя, график)
   SharedPreferences prefs = await _prefs;
      Variables.selectedUser = (prefs.getString('name')==null)?Variables.currentUser:await Users.getUserByName(prefs.getString('name')!);
      currentSchedule = await Schedules.getSchedule(Variables.selectedUser.scheduleName);
    }

 static Users selectedUser = Users(//выбранный главным пользователь
      'user',
      '0',
      '001',
      'position',
      DateTime(2022),
      DateTime(2022),
      '0',
      'КИПиА',
      '8 987 654 32 10',
      'user',
      false);
 static Users currentUser = Users(
     'user',
     '0',
     '001',
     'position',
     DateTime(2022),
     DateTime(2022),
     '0',
     'КИПиА',
     '8 987 654 32 10',
     'user',
     false);


static Events initialEvent = Events(
   'userName',
   'eventName',
  DateTime.now(),
  DateTime.now(),
  DateTime.now(),
  'typeofEvent',
  'comment',
  false,
  false,
  false
      );
   static Events currentEvent = initialEvent;


 static DateTime clickedDay=DateTime.now();
 static  Map<DateTime,String> eventsDay=Map.fromIterables(//Инициализация переменной двумя листами
    List.generate(24, (index) => Variables.setZeroTime(Variables.clickedDay).add(Duration(hours: index))),
    List.filled(24,''));

 static setZeroTime(DateTime day){
DateTime beginningOfDay = DateTime(day.year,day.month,day.day,0,0);
return beginningOfDay;
}


}

class States{
 static bool showDayTypes = false;
 static bool isPulled = false;
 static bool isLastWeek = false;
 static List<bool> isNamePressed=List.filled(250, false);
 static List<bool> isSchedulePressed=List.filled(100, false);
 static List<bool> isEventPressed=List.filled(1000, false);
static String eventPressed='';

}
