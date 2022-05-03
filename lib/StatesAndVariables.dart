

import 'dart:async';

// class Refresh{
//  Sink<List<bool>> get refresh => _refreshUserController.sink;
// final _refreshUserController = StreamController<List<bool>>();
// }


 class Variables{
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
 static bool isNamePressed=false;
 // static Future Stream<bool> userListState() async{
 //
 //  return ;
 // }

 // States(this.isPulled,this.isLastWeek);
}