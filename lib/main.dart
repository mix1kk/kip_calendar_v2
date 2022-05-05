
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kip_calendar_v2/Users/Users.dart';
import 'widgets.dart';
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

 // static Model model = Model();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/calendar',
      routes: {

        '/users': (context) => UsersScreen(),
        '/calendar': (context) => CalendarScreen(),
        '/calendarDay': (context) => DayCalendarScreen(),
      },
           theme: new ThemeData(
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
      onRefresh: Widgets.pullRefresh,
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
                Navigator.pushNamed(context, '/users');
                setState(() {

                });
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
                ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'],context),
            Widgets.mainBodyCalendarMonthScreen(DateTime(2022),context),
          ],
        ),
      ),
    );
  }
}
