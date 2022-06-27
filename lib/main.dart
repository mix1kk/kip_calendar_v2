
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/Users/Users.dart';
import 'AlertDialogs.dart';
import 'Events/Events.dart';
import 'Schedules/Schedules.dart';
import 'Widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'StatesAndVariables.dart';


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
            title: const Text("Выбор меню"),
            children: <Widget>[
              SimpleDialogOption(
                child: const Text("На главную"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(
                    context,
                    '/calendar',
                  );
                },
              ),
              SimpleDialogOption(
                child: const Text("Пользователи"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(
                    context,
                    '/users',
                  );
                },
              ),
              SimpleDialogOption(
                child: const Text("Графики"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(
                    context,
                    '/schedules',
                  );
                },
              ),
              SimpleDialogOption(
                child: const Text("События"),
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
        '/events': (context) =>  EventsScreen(stream: FirebaseFirestore.instance
            .collection('events').where('userName',arrayContainsAny: Variables.selectedUsers)
            .snapshots(),/*stream name: [Variables.selectedUser.name]*/),
        '/schedules': (context) =>  const SchedulesScreen(),
        '/users': (context) => const UsersScreen(),
        '/calendar': (context) => const CalendarScreen(),
      },
           theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
              SizedBox(
                height: 20.0,
                width: MediaQuery.of(context).size.width - 20,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(EdgeInsets.zero) ),
                    child:
                   Text(Variables.selectedUsers.toString(),style: const TextStyle(fontSize: 12.0)),
                    onPressed: ()async {
                      await AlertDialogs.selectUsersAlertDialog(context,'/calendar');
                    },
                  ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await AlertDialogs.addEventAlertDialog(context);
            setState(() {});
          },
          child: const Icon(Icons.add_outlined),
        ),
      ),
    );
  }
}
// todo: баг: смотри начало следующего года, скрывается последняя неделя предыдущего, при сворачивании прошедших месяцев скрываются месяцы для каждого года
//todo : добавить сортировку пользователей по параметрам
//todo: вылетает ошибка при попытке загрузки несуществующего графика
//todo: сделать в каждом пользователе отдельный массив изменений в графике работы
//todo: сделать отображение и сортировку событий
