import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'firestore.dart';
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
  static void setPrefs (name)async{
   SharedPreferences prefs = await _prefs;
   await prefs.setString('name',name);
  }

  static Future <void> getPrefs ()async{
   SharedPreferences prefs = await _prefs;
      Variables.selectedUser = (prefs.getString('name')==null)?Variables.currentUser:await Users.getUserByName(prefs.getString('name')!);
    }
  // Users initialUser = Users(
  //     'user',
  //     '0',
  //     '001',
  //     'position',
  //     DateTime(2022),
  //     DateTime(2022),
  //     '0',
  //     'КИПиА',
  //     '8 987 654 32 10',
  //     'user',
  //     false);
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

}
class Model
{
 StreamController _streamController = StreamController<int>();

 Stream<dynamic> get counterUpdates => _streamController.stream;


}