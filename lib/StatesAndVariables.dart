
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'Database.dart';


final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
 class Variables{
   static List<int> schedule = List.filled(1460, 26);//для инициализации пользователя
   static double rowHeight = 40.0; // Высота строк
   static double firstColumnWidth = 60.0; //Ширина первого столбца с номерами недели
   static List<Events>allEvents=[];
  static Map<int,String> numbersForWorkingDays=
  {1: 'Я',
   2: 'Н',
   6: 'К',
   9: 'ОТ',
   10: 'ОД',
   11: 'У',
   16: 'ДО',
   17:'ОЗ',
   19:'Б',
   24: 'ПР',
   26:'В',
  };
  static  List<String> typesOfEvents = [
    'Событие',
    'Отпуск',
    'Дополнительный отпуск',
    'Учебный отпуск',
    'Больничный',
    'Прогул',
    'Отгул',
    'Изменение графика'
  ];
  static Schedules currentUserSchedule=Schedules('0',List.filled(56, 26),false);
  static Schedules selectedSchedule=Schedules('',List.filled(56, 26),false);
  static void setSelectedUserNamePrefs (username)async{
   SharedPreferences prefs = await _prefs;
   await prefs.setString('name',username);
  }
   static List<String> selectedUsers=[];
  static Future <void> getPrefs ()async{//считывание сохраненных данных(имя пользователя, график)
   SharedPreferences prefs = await _prefs;
      Variables.selectedUser = (prefs.getString('name')==null)?Variables.currentUser:await Users.getUserByName(prefs.getString('name')!);
      currentUserSchedule = await Schedules.getSchedule(Variables.selectedUser.scheduleName);
      allEvents = await Events.getAllEventsForUser([Variables.selectedUser.name]);
      selectedUsers.add(Variables.selectedUser.name);
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
      schedule,
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
     schedule,
     false);


static Events initialEvent = Events(
   ['userName'],
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


 static setZeroTime(DateTime day){
DateTime beginningOfDay = DateTime(day.year,day.month,day.day,0,0);
return beginningOfDay;
}


}

class States{
 static bool showDayTypes = true;
 static bool isPulled = false;
 static bool isLastWeek = false;
 static List<bool> isNamePressed=List.filled(250, false);
static String eventPressed='';
static DateTime startSelection =  DateTime(2022);//для начала выделения диапазона дат
 static DateTime endSelection =  DateTime(2022);//для конца выделения диапазона дат

}
