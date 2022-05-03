import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/Users/Users.dart';
import 'package:kip_calendar_v2/Menu/Menu.dart';
import 'package:kip_calendar_v2/Events/Events.dart';
import 'package:kip_calendar_v2/styles.dart';
import 'widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'StatesAndVariables.dart';
import 'DayCalendar.dart';


void main() {
  initializeDateFormatting('ru', null);
  Intl.defaultLocale = 'ru';

  runApp(MaterialApp(
    initialRoute: '/calendar',
    routes: {

       '/users': (context) => UsersScreen(),
      // '/menu': (context) => MenuScreen(),
      // '/events': (context) => EventsScreen(),
      '/calendar': (context) => CalendarScreen(),
      '/calendarDay': (context) => DayCalendarScreen(),
    },
  ));
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
          title: const Text("Календарь"),
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
