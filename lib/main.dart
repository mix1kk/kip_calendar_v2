import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/Users/Users.dart';
import 'AlertDialogs.dart';
import 'AllUsersList/AllUsers.dart';
import 'Database.dart';
import 'Events/Events.dart';
import 'Schedules/Schedules.dart';
import 'Schedules/Widgets/SchedulesWidgets.dart';
import 'Styles.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'StatesAndVariables.dart';

void main() async {
  initializeDateFormatting('ru', null);
  Intl.defaultLocale = 'ru';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Variables.getPrefs();
  // Variables.allSchedules = await Schedules.getAllSchedules();

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
                child: const Text("Все пользователи"),
                onPressed: () async{

                 //  List <Users> users = await Users.getAllUsers();
                  Navigator.of(context).pop();
                  Navigator.pushNamed(
                    context,
                    '/allUsers',arguments: <List<Users>>{Variables.allUsers}
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
        '/events': (context) => EventsScreen(
            stream: FirebaseFirestore.instance
                .collection('events')
                .where('userName', arrayContainsAny: Variables.selectedUsers)
                .snapshots(),
            isDateSorted: false,
            date: DateTime.now()),
        '/schedules': (context) => const SchedulesScreen(),
        '/users': (context) => const UsersScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/allUsers': (context) =>  const AllUsersScreen(users: [],),
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

  final ScrollController controller = ScrollController();

   void scrollDown() {//промотка списка на конкретную величину, перенести в календарь
     double shift = DateTime.now().difference(DateTime(2022)).inDays/7+6;
     controller.jumpTo(controller.initialScrollOffset+Variables.rowHeight * shift);
   /* controller.animateTo(
      controller.initialScrollOffset+Variables.rowHeight * shift,
      duration: const Duration(seconds: 3),
      curve: Curves.fastOutSlowIn,
    );*/
  }

  static getNumberOfWeek(DateTime day) {
    //возвращает номер недели введенного дня
    final startOfYear = DateTime(day.year);
    final firstMonday = startOfYear.weekday;
    final daysInFirstWeek = 8 - firstMonday;
    final diff = day.difference(startOfYear);
    var weeks = ((diff.inDays - daysInFirstWeek) / 7).ceil();
    if (daysInFirstWeek < 3) {
      weeks = weeks + 1;
    }
    return weeks;
  }

  static List<DateTime> getWeekDays(DateTime day) {
    //рассчет и выдача массива дат на текущую неделю
    DateTime firstDayOfWeek = day.subtract(Duration(days: day.weekday - 1));
    List<DateTime> week =
        List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));
    return week;
  }

  static Future<void> pullRefresh(context) async {
    States.isPulled = !States.isPulled;
    Navigator.pushNamed(context, '/calendar');
  }

  Widget mainBodyCalendarMonthScreen(DateTime day, context) {

    //основная таблица  на экране CalendarMonthScreen
    return Expanded(
      child: ListView.builder(controller: controller,itemBuilder: (context, index) {

        //скрытие прошедших месяцев
        DateTime lastDayOfWeek = day.add(Duration(
            days: 7 - day.weekday)); //вычисление даты последнего дня в неделе
        DateTime currentDay = lastDayOfWeek.add(Duration(days: index * 7));
        if (currentDay.day < 7) {
          States.isLastWeek = true;
        }
        if (States.isPulled) {
          Variables.rowHeight = 40.0;
        } else {
          if (((currentDay.month) < DateTime.now().month) &&
              (currentDay.year == DateTime.now().year)) {
            Variables.rowHeight = 0.0;
          } else {
            Variables.rowHeight = 40.0;
          }
        }
        //скрытие прошедших месяцев
        return Column (children: [
          SizedBox(
            //Для отрисовки последней недели предыдущего месяца с затемненными днями
            height: (currentDay.day < 7) ? Variables.rowHeight : 0.0,
            child: rowCalendarMonthScreen(
                getNumberOfWeek(currentDay).toString(),
                getWeekDays(currentDay),
                context,
                'main'),
          ),
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  color: Colors.grey),
              width: double.infinity,
              height: (currentDay.day < 8) ? Variables.rowHeight / 2 : 0.0,
              child: Center(
                child: //Название месяца и год в начале каждого месяца
                    Text(DateFormat.yMMMM().format(currentDay).toUpperCase()),
              )),
          SizedBox(
            height: Variables.rowHeight,
            child: rowCalendarMonthScreen(
                getNumberOfWeek(currentDay).toString(),
                getWeekDays(currentDay),
                context,
                'main'),
            //построение основной таблицы строка за строкой
          ),
        ]);
      }),
      // ),
    );
  }

  Widget rowCalendarMonthScreen(
      //Строка на экране CalendarMonthScreen
      String nameFirstColumn,
      List<dynamic> week,
      context,
      String
          callPlace) //String callPlace - указать место, откуда произошел вызов функции для разного отображения в разных местах
  {
    return SizedBox(
      height: Variables.rowHeight + 5,
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(3.0),
          width: Variables.firstColumnWidth,
          height: Variables.rowHeight,
          child: ElevatedButton(
            style: ButtonStyles.headerButtonStyle,
            onPressed: () {},
            child: Text(nameFirstColumn, style: const TextStyle(fontSize: 12)),
          ),
        ),
        Row(
          children: weekCalendarMonthScreen(week, context, callPlace),
        ),
      ]),
    );
  }

  List<Widget> weekCalendarMonthScreen(
      List<dynamic> week, context, String callPlace) {
    //  BoxDecoration boxDecoration = ButtonStyles.simpleBoxDecoration;
    // bool isEvent = false;
    //7 дней недели в строке на экране CalendarMonthScreen
    List<Widget> widgets = [];
    var style = ButtonStyles
        .simpleDayButtonStyle; //инициализация переменной style - она отвечает за цвет рамки в соответствии с событиями
    var secondStyle = ButtonStyles
        .simpleDayButtonStyle; //инициализация переменной secondStyle- она отвечает за цвет дней в соответствии с графиком
    for (int day = 0; day < 7; day++) {
      if (week[0] is! String) {
        if (States.isLastWeek) {
          //проверка является ли текущая неделя последней в месяце
          if (week[day].month != week[0].month && callPlace == 'main') {
            //отрисовка затемненных дней следующего месяца в последней неделе текущего месяца, если вызвано с главного экрана
            style = ButtonStyles.fadedDayButtonStyle;
            secondStyle = style;
          } else {
            /// раскрашивание дней в соответствии с графиком
            secondStyle = ButtonStyles.dayStyle(
                week[day], Variables.currentUserSchedule.schedule, callPlace);
            style = secondStyle;
            for (int i = 0; i < Variables.allEvents.length; i++) {
              ///определение ивента в текущий день и окрашивание рамки в цвет ивента

              if ((Variables.setZeroTime(week[day]).compareTo(
                          Variables.setZeroTime(
                              Variables.allEvents[i].startDate)) >=
                      0) &&
                  (Variables.setZeroTime(week[day]).compareTo(
                          Variables.setZeroTime(
                              Variables.allEvents[i].endDate)) <=
                      0)) {
                if (Variables.allEvents[i].typeOfEvent == 'Больничный') {
                  style = ButtonStyles.illnessButtonStyle;
                } else {
                  if ((Variables.allEvents[i].typeOfEvent == 'Отпуск') ||
                      (Variables.allEvents[i].typeOfEvent ==
                          'Дополнительный отпуск') ||
                      (Variables.allEvents[i].typeOfEvent ==
                          'Учебный отпуск')) {
                    style = ButtonStyles.vacationButtonStyle;

                  } else {
                    if ((Variables.allEvents[i].typeOfEvent == 'Прогул') ||
                        (Variables.allEvents[i].typeOfEvent == 'Отгул')) {
                      style = ButtonStyles.otgulButtonStyle;
                    } else {
                      style = ButtonStyles.activeEventButtonStyle;
                      // boxDecoration = ButtonStyles.eventBoxDecoration;
                    }
                  }
                }
              }
            } //определение ивента в текущий день и окрашивание рамки в цвет ивента

          }
        } else {
          if (week[day].month != week[6].month && callPlace == 'main') {
            //отрисовка затемненных дней предыдущего месяца в первой неделе текущего месяца, если вызвано с главного экрана
            style = ButtonStyles.fadedDayButtonStyle;
            secondStyle = style;
          } else {
            style = ButtonStyles.dayStyle(
                // раскрашивание дней в соответствии с графиком
                week[day],
                Variables.currentUserSchedule.schedule,
                callPlace);
            secondStyle = ButtonStyles.dayStyle(
                week[day],
                Variables.currentUserSchedule.schedule,
                callPlace); // раскрашивание дней в соответствии с графиком

            for (int i = 0; i < Variables.allEvents.length; i++) {
              //определение ивента в текущий день для окрашивания рамки в цвет ивента
              if ((Variables.setZeroTime(week[day]).compareTo(
                          Variables.setZeroTime(
                              Variables.allEvents[i].startDate)) >=
                      0) &&
                  (Variables.setZeroTime(week[day]).compareTo(
                          Variables.setZeroTime(
                              Variables.allEvents[i].endDate)) <=
                      0)) {
                if (Variables.allEvents[i].typeOfEvent == 'Больничный') {
                  style = ButtonStyles.illnessButtonStyle;
                } else {
                  if ((Variables.allEvents[i].typeOfEvent == 'Отпуск') ||
                      (Variables.allEvents[i].typeOfEvent ==
                          'Дополнительный отпуск') ||
                      (Variables.allEvents[i].typeOfEvent ==
                          'Учебный отпуск')) {
                    style = ButtonStyles.vacationButtonStyle;

                  } else {
                    if ((Variables.allEvents[i].typeOfEvent == 'Прогул') ||
                        (Variables.allEvents[i].typeOfEvent == 'Отгул')) {
                      style = ButtonStyles.otgulButtonStyle;
                    } else {
                      style = ButtonStyles.activeEventButtonStyle;
                      // boxDecoration = ButtonStyles.eventBoxDecoration;
                    }
                  }
                }
              } //*определение ивента в текущий день для окрашивания рамки в цвет ивента
            }
          }
        }
      }

      widgets.add(
        Container(
          padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
          // decoration: boxDecoration,
          width:
              (MediaQuery.of(context).size.width - Variables.firstColumnWidth) /
                  7,
          height: Variables.rowHeight,
          child: (callPlace == 'main')
              ? dayCalendarMonthScreen(week[day], style, secondStyle, context)
              : SchedulesWidgets.dayCalendarScheduleScreen(
                  week[day], style, context),
        ),
      );
      //   boxDecoration = ButtonStyles.simpleBoxDecoration;
    }
    States.isLastWeek = false;
    return widgets;
  }

  Widget dayCalendarMonthScreen(dynamic day, style, secondStyle, context) {
    BoxDecoration boxDecoration = ButtonStyles.unselectedInnerBoxDecoration;
    // String dayNumberByTK = '';
    if (day is DateTime && style != ButtonStyles.fadedDayButtonStyle) {
      /* dayNumberByTK =
          Schedules.getWorkingDay(day, Variables.currentUserSchedule.schedule)
              .toString(); */ //Номер дня по ТК
//Обозначение дня по ТК
    }
    if (day is DateTime &&
        Variables.setZeroTime(day)
                .compareTo(Variables.setZeroTime(States.startSelection)) >=
            0 &&
        Variables.setZeroTime(day)
                .compareTo(Variables.setZeroTime(States.endSelection)) <=
            0 &&
        style != ButtonStyles.fadedDayButtonStyle) {
      boxDecoration = ButtonStyles
          .selectedInnerBoxDecoration; //Здесь задается обрамление выделенного диапазона дат
    } else {
      boxDecoration = ButtonStyles.unselectedInnerBoxDecoration;
    }

    return Container(
        // внутренний контейнер для исключения смешивания цвета внешнего контейнера и кнопки
        decoration: boxDecoration,
        child: ElevatedButton(
          style: (day
                  is String) //Если передали значение String, значит отрисовываем шапку, иначе это основная таблица
              ? ButtonStyles.headerButtonStyle
              : style,
          child: Container(
            padding: States.showDayTypes
                ? const EdgeInsets.all(4.0)
                : const EdgeInsets.all(0.0),
            child: ElevatedButton(
              //для задания фона чтобы исключить смешивание цветов
              style: (day
                      is String) //Если передали значение String, значит отрисовываем шапку, иначе это основная таблица
                  ? ButtonStyles.headerButtonStyle
                  : ButtonStyles.fadedDayButtonStyle,
              child: ElevatedButton(
                style: (day
                        is String) //Если передали значение String, значит отрисовываем шапку, иначе это основная таблица
                    ? ButtonStyles.headerButtonStyle
                    : secondStyle,
                child: Text((day is String) ? day : DateFormat.d().format(day)),
                onPressed: () {
                  //выбор и выделение диапазона дат
                  if (States.startSelection == DateTime(2022)) {
                    States.startSelection = day;
                    States.endSelection = day;
                  } else {
                    if (day == States.startSelection) {
                      States.startSelection = DateTime(2022);
                      States.endSelection = DateTime(2022);
                    } else {
                      if (States.startSelection != States.endSelection) {
                        States.startSelection = DateTime(2022);
                        States.endSelection = DateTime(2022);
                      } else {
                        States.endSelection = day;
                      }
                      if (Variables.setZeroTime(day).compareTo(
                              Variables.setZeroTime(States.startSelection)) <
                          0) {
                        States.endSelection = States.startSelection;
                        States.startSelection = day;
                      }
                    }
                  }
                  setState(() {});
                },
              ),
              onPressed: () {},
            ),
          ),
          /* Column(
            children: [
              Expanded(
                child: Align(
                  alignment: ((day is! String) && States.showDayTypes)
                      ? Alignment.bottomCenter
                      : Alignment.center,
                  child: Text(
                    (day is String) ? day : DateFormat.d().format(day),
                  ),
                ),
              ),
              SizedBox(
                  height: ((day is! String) && States.showDayTypes) ? 13 : 0,
                  child: ElevatedButton(//кнопка для исключения смешивания цветов, задает белый фон в нижней части даты
                    style:
                    ButtonStyles.fadedDayButtonStyle,
                    child: DecoratedBox(
                      decoration:  BoxDecoration(
                        border:(day is! String && States.showDayTypes)? const Border(
                          top: BorderSide(color: Colors.white, width: 2),
                        ):null
                      ),
                      child: ElevatedButton(
                        style: secondStyle,
                        child: Text(
                          dayNumberByTK, //Номер дня по ТК
                          style: const TextStyle(fontSize: 9),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    onPressed: () {},
                  )),
            ],
          ),*/
          onLongPress: () {
            if (Variables.selectedUser.role == 'admin') {
              // var stream= FirebaseFirestore.instance
              //     .collection('events')
              //     .snapshots();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventsScreen(
                          stream: FirebaseFirestore.instance
                              .collection('events')
                              .where('userName',
                              arrayContainsAny: Variables.selectedUsers)
                              .snapshots(),
                          isDateSorted: true,
                          date: day)));
              //todo: возможно сделать формирование потока на основе выбранных критериев
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventsScreen(
                          stream: FirebaseFirestore.instance
                              .collection('events')
                              .where('userName',
                                  arrayContainsAny: Variables.selectedUsers)
                              .snapshots(),
                          isDateSorted: true,
                          date: day)));
            }
            //todo считывание всех ивентов для данного пользователя в кликнутую дату
          },
          onPressed: () {
            /* //выбор диапазона дат
            if (States.startSelection == DateTime(2022)) {
              States.startSelection = day;
              States.endSelection = day;
            } else {
              if (day == States.startSelection) {
                States.startSelection = DateTime(2022);
                States.endSelection = DateTime(2022);
              } else {
                if (States.startSelection != States.endSelection) {
                  States.startSelection = DateTime(2022);
                  States.endSelection = DateTime(2022);
                } else {
                  States.endSelection = day;
                }
                if (Variables.setZeroTime(day).compareTo(
                        Variables.setZeroTime(States.startSelection)) <
                    0) {
                  States.endSelection = States.startSelection;
                  States.startSelection = day;
                }
              }
            }
            setState(() {});*/
          },
        ));
  }

  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      onRefresh: () {
        return /*Widgets.*/ pullRefresh(context);
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.anchor_sharp),
              onPressed: () {
                scrollDown();
                // setState(() {
                // });
              },
            ),
            IconButton(
              icon: const Icon(Icons.update),
              onPressed: () {
                States.showDayTypes = !States.showDayTypes;
                setState(() {});
              },
            ),
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: () {
                MyApp.menuNavigationDialog(context);
              },
            )
          ],
          title: Column(
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Text('Календарь', style: TextStyle(fontSize: 20.0)),
              ),
              SizedBox(
                  height: 20.0,
                  width: MediaQuery.of(context).size.width - 20,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: Text(Variables.selectedUsers.toString(),
                          style: const TextStyle(fontSize: 12.0)),
                      onPressed: () async {
                        await AlertDialogs.selectUsersAlertDialog(
                            context, '/calendar');
                      },
                    ),
                  )),
            ],
          ),
        ),
        body: Column(
          children: [
            /*Widgets.*/ rowCalendarMonthScreen(
                //Заголовок на основном экране с названиями дней недели
                'Неделя',
                ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'],
                context,
                'main'),
            /*Widgets.*/ mainBodyCalendarMonthScreen(DateTime(2022), context),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await AlertDialogs.addEventAlertDialog(context, '/calendar');
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
