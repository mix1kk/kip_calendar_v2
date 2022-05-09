
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kip_calendar_v2/Users/Users.dart';
import 'Events/Events.dart';
import 'Schedules/Schedules.dart';
import 'Widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'StatesAndVariables.dart';
import 'DayCalendar.dart';


void main() async {
  initializeDateFormatting('ru', null);
  Intl.defaultLocale = 'ru';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Variables.getPrefs();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  static void menuNavigationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Выбор меню"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("На главную"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(
                    context,
                    '/calendar',
                  );
                },
              ),
              SimpleDialogOption(
                child: Text("Пользователи"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(
                    context,
                    '/users',
                  );
                },
              ),
              SimpleDialogOption(
                child: Text("Графики"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(
                    context,
                    '/schedules',
                  );
                },
              ),
              SimpleDialogOption(
                child: Text("События"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(
                    context,
                    '/events',
                  );
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/calendar',
      routes: {
        '/events': (context) =>  EventsScreen(),
        '/schedules': (context) =>  SchedulesScreen(),
        '/users': (context) => UsersScreen(),
        '/calendar': (context) => CalendarScreen(),
        '/calendarDay': (context) => DayCalendarScreen(),
      },
           theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     // home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {



  @override
  Widget build(BuildContext context) {
    // if (States.isPulled) {
    //   setState(() {});
    // }
    return RefreshIndicator(
      onRefresh:() {return Widgets.pullRefresh(context);},
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(icon: const Icon(Icons.update),
            onPressed: (){
              States.showDayTypes=!States.showDayTypes;
              setState(() {
              });
            },),
            IconButton(icon: const Icon(Icons.list),
              onPressed: (){
                MyApp.menuNavigationDialog(context);
              },)
          ],
          title:
          Column(
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Text('Календарь', style: TextStyle(fontSize: 20.0)) ,
              ),
              Container(
               // padding: const EdgeInsets.fromLTRB(50.0, 8.0, 0.0, 1.0),
                height: 20.0,
                width: MediaQuery.of(context).size.width - 20,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(Variables.selectedUser.name,style: const TextStyle(fontSize: 12.0)),
                )
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Widgets.rowCalendarMonthScreen(
                //Заголовок на основном экране с названиями дней недели
                'Неделя',
                ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'],context,'main'),
            Widgets.mainBodyCalendarMonthScreen(DateTime(2022),context),
          ],
        ),
      ),
    );
  }
}
// todo: баг: смотри начало следующего года, скрывается последняя неделя предыдущего, при сворачивании прошедших месяцев скрываются месяцы для каждого года
//todo : добавить сортировку пользователей по параметрам