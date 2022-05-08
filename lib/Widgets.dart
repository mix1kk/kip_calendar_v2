import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/AlertDialogs.dart';
import 'StatesAndVariables.dart';
import 'Database.dart';
import 'Styles.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:firebase_core/firebase_core.dart';
final TextEditingController dateOfBirthController = TextEditingController();
final TextEditingController dateOfEmploymentController =
    TextEditingController();
final TextEditingController scheduleNameController = TextEditingController();

double rowHeight = 40.0; // Высота строк
double firstColumnWidth = 60.0; //Ширина первого столбца с номерами недели

class Widgets {
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
    // await Future.delayed(const Duration(seconds: 1));
    States.isPulled = !States.isPulled;
    Navigator.pushNamed(context, '/calendar');
  }

  static Widget mainBodyCalendarMonthScreen(DateTime day, context) {
    //основная таблица  на экране CalendarMonthScreen
    return Expanded(
      // child: RefreshIndicator(
      //   onRefresh: pullRefresh,
      child: ListView.builder(itemBuilder: (context, index) {
        //скрытие прошедших месяцев
        DateTime lastDayOfWeek = day.add(Duration(
            days: 7 - day.weekday)); //вычисление даты последнего дня в неделе
        DateTime currentDay = lastDayOfWeek.add(Duration(days: index * 7));
        if (currentDay.day < 7) {
          States.isLastWeek = true;
        }

        if (States.isPulled) {
          rowHeight = 40.0;
        } else {
          if ((currentDay.month) < DateTime.now().month) {
            rowHeight = 0.0;
          } else {
            rowHeight = 40.0;
          }
        }
        //скрытие прошедших месяцев
        return Column(children: [
          SizedBox(
            //Для отрисовки последней недели предыдущего месяца с затемненными днями
            height: (currentDay.day < 7) ? rowHeight : 0.0,
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
              height: (currentDay.day < 8) ? 25 : 0.0,
              child: Center(
                child: //Название месяца и год в начале каждого месяца
                    Text(DateFormat.yMMMM().format(currentDay).toUpperCase()),
              )),
          SizedBox(
            height: rowHeight,
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

  static Widget rowCalendarMonthScreen(
      //Строка на экране CalendarMonthScreen
      String nameFirstColumn,
      List<dynamic> week,
      context,
      String
          callPlace) //String callPlace - указать место, откуда произошел вызов функции для разного отображения в разных местах
  {
    return SizedBox(
      height: rowHeight + 5,
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(3.0),
          width: firstColumnWidth,
          height: rowHeight,
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

  static List<Widget> weekCalendarMonthScreen(
      List<dynamic> week, context, String callPlace) {
    //7 дней недели в строке на экране CalendarMonthScreen
    List<Widget> widgets = [];
    var style =
        ButtonStyles.simpleDayButtonStyle; //инициализация переменной style
    for (int day = 0; day < 7; day++) {
      if (week[0] is! String) {
        if (States.isLastWeek) {
          //проверка является ли текущая неделя последней в месяце
          if (week[day].month != week[0].month && callPlace == 'main') {
            //отрисовка затемненных дней следующего месяца в последней неделе текущего месяца, если вызвано с главного экрана
            style = ButtonStyles.fadedDayButtonStyle;
          } else {
            style = ButtonStyles.dayStyle(week[day],
                callPlace); // раскрашивание дней в соответствии с графиком
          }
        } else {
          if (week[day].month != week[6].month && callPlace == 'main') {
            //отрисовка затемненных дней предыдущего месяца в первой неделе текущего месяца, если вызвано с главного экрана
            style = ButtonStyles.fadedDayButtonStyle;
          } else {
            style = ButtonStyles.dayStyle(week[day],
                callPlace); // раскрашивание дней в соответствии с графиком
          }
        }
      }
      widgets.add(
        Container(
          padding: const EdgeInsets.fromLTRB(2.0, 1.0, 2.0, 3.0),
          width: (MediaQuery.of(context).size.width - firstColumnWidth) / 7,
          height: rowHeight,
          child: (callPlace == 'main')
              ? dayCalendarMonthScreen(week[day], style, context)
              : dayCalendarScheduleScreen(week[day], style, context),
        ),
      );
    }
    States.isLastWeek = false;
    return widgets;
  }

  static Widget dayCalendarMonthScreen(dynamic day, style, context) {
    String dayNumberByTK = '';
    String dayLetterByTK = '';
    if (day is DateTime && style != ButtonStyles.fadedDayButtonStyle) {
      dayNumberByTK =
          Schedules.getWorkingDay(day, Variables.currentSchedule.schedule)
              .toString(); //Номер дня по ТК
      dayLetterByTK = Variables.numbersForWorkingDays[Schedules.getWorkingDay(
                  day, Variables.currentSchedule.schedule)] ==
              null
          ? ''
          : Variables.numbersForWorkingDays[Schedules.getWorkingDay(
              day, Variables.currentSchedule.schedule)]!;
//Обозначение дня по ТК
    }
    return ElevatedButton(
      style: (day
              is String) //Если передали значение String, значит отрисовываем шапку, иначе это основная таблица
          ? ButtonStyles.headerButtonStyle
          : style,
      child: Column(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  dayNumberByTK, //Номер дня по ТК
                  style: const TextStyle(fontSize: 9),
                ),
                Text(
                  dayLetterByTK, //Обозначение дня по ТК
                  style: const TextStyle(fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
      //todo Выбор цвета кнопки в зависимости от наличия событий в эту дату
      onPressed: () {
        if (day is! String) {
          Navigator.pushNamed(context, '/calendarDay');
        }
        //todo считывание всех ивентов для данного пользователя в кликнутую дату
        //        dialogOnMainScreen();
      },
    );
  }

  static Widget mainBodyCalendarDayScreen(DateTime day, context) {
    //основная таблица  на экране CalendarDayScreen
    return Expanded(
      // child: RefreshIndicator(
      //   onRefresh: pullRefresh,
      child: ListView.builder(
          itemCount: 12,
          itemBuilder: (context, index) {
            return Column(children: [
              SizedBox(
                height: rowHeight,
                child:
                    rowCalendarDayScreen(Variables.eventsDay, context, index),
                //построение основной таблицы строка за строкой
              ),
            ]);
          }),
      // ),
    );
  }

  static Widget rowCalendarDayScreen(
      //Строка на экране CalendarDayScreen
      Map<DateTime, String> eventsDay,
      context,
      index) {
    String time1 = ('${eventsDay.keys.elementAt(index).hour} '
        ':'
        ' ${eventsDay.keys.elementAt(index).minute}');
    String time2 = ('${eventsDay.keys.elementAt(index + 12).hour} '
        ':'
        ' ${eventsDay.keys.elementAt(index + 12).minute}');
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          padding: const EdgeInsets.all(0.0),
          height: rowHeight,
          width: MediaQuery.of(context).size.width / 2,
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(3.0),
              width: firstColumnWidth,
              child: ElevatedButton(
                style: ButtonStyles.headerButtonStyle,
                onPressed: () {},
                child: Text(time1, style: const TextStyle(fontSize: 12)),
              ),
            ),
            SizedBox(
              width:
                  MediaQuery.of(context).size.width / 2 - firstColumnWidth - 2,
              child: ElevatedButton(
                style: ButtonStyles.dayEventsButtonStyle,
                onPressed: () {
                  //добавить событие
                },
                child: Text(eventsDay.values.elementAt(index)),
              ),
            ),
          ]),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          padding: const EdgeInsets.all(0.0),
          height: rowHeight,
          width: MediaQuery.of(context).size.width / 2,
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(3.0),
              width: firstColumnWidth,
              child: ElevatedButton(
                style: ButtonStyles.headerButtonStyle,
                onPressed: () {},
                child: Text(time2, style: const TextStyle(fontSize: 12)),
              ),
            ),
            SizedBox(
              width:
                  MediaQuery.of(context).size.width / 2 - firstColumnWidth - 2,
              child: ElevatedButton(
                style: ButtonStyles.dayEventsButtonStyle,
                onPressed: () {
                  //добавить событие
                },
                child: Text(eventsDay.values.elementAt(index + 12)),
              ),
            ),
          ]),
        )
      ],
    );
  }

  static Widget usersScreen(DateTime day, context) {
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').snapshots();
    //основная таблица  на экране UsersScreen
    return Expanded(
      // child: RefreshIndicator(
      //   onRefresh: pullRefresh,
      child: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            int number = 0;
            if (snapshot.hasError) {
              return const Text('Что-то пошло не так');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
              //const Text("Loading");
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                number++;
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Column(children: [
                  SizedBox(
                    height: rowHeight * 2,
                    child: usersMainScreenName(context, number, data),
                    //заголовок пользователя в списке пользователей
                  ),
                  SizedBox(
                    height: States.isNamePressed[number] ? rowHeight * 17 : 0.0,
                    child: usersMainScreenData(context, number, data),
                    //данные пользователя в списке пользователей
                  ),
                ]);
              }).toList(),
            );
          }),
    );
  }

  static Widget usersMainScreenName(context, int index, data) {
    return Row(
      children: [
        Container(
            padding: const EdgeInsets.all(2.0),
            height: rowHeight * 2,
            width: firstColumnWidth,
            child: ElevatedButton(
              style: ButtonStyles.headerButtonStyle,
              onPressed: () {},
              child: Text('$index'),
            )),
        Container(
            padding: const EdgeInsets.all(2.0),
            height: rowHeight * 2,
            width: MediaQuery.of(context).size.width - firstColumnWidth,
            child: ElevatedButton(
              style: (Variables.selectedUser.name == data['name'])
                  ? ButtonStyles.headerButtonStyle
                  : ButtonStyles.usersListButtonStyle,
              onPressed: () {
                Variables.currentUser = Users(
                  data['name'],
                  data['password'],
                  data['tableNumber'],
                  data['position'],
                  data['dateOfBirth'].toDate(),
                  data['dateOfEmployment'].toDate(),
                  data['scheduleName'],
                  data['unit'],
                  data['phoneNumber'],
                  data['role'],
                  !data['isExpanded'],
                );
                dateOfBirthController.text =
                    DateFormat.yMd().format(Variables.currentUser.dateOfBirth);
                dateOfEmploymentController.text = DateFormat.yMd()
                    .format(Variables.currentUser.dateOfEmployment);
                scheduleNameController.text = data['scheduleName'];
                Variables.setPrefs(data['name']);

                if (States.isNamePressed[index]) {
                  States.isNamePressed = List.filled(250, false);
                } else {
                  States.isNamePressed = List.filled(250, false);
                  States.isNamePressed[index] = !States.isNamePressed[index];
                }
                Users.addUser(//сделано для обновления экрана
                    Variables.currentUser);
              },
              child: ListTile(
                title: Text(data['name']),
                subtitle: Text(data['position']),
              ),
            )),
      ],
    );
  }

  static Widget usersMainScreenData(context, index, Map<String, dynamic> data) {
    //полные данные пользователей
    return Container(
      padding: const EdgeInsets.all(2.0),
      // height: States.isNamePressed[number] ? rowHeight * 15 : 0.0,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'ФИО',
            ),
            readOnly: Variables.selectedUser.role != 'admin',
            initialValue: data['name'],
            onChanged: (value) {
              Variables.currentUser.name = value;
            },
          ),
          TextFormField(
            readOnly: Variables.selectedUser.role != 'admin',
            decoration: const InputDecoration(
              labelText: 'Пароль',
            ),
            obscureText: Variables.selectedUser.role != 'admin',
            obscuringCharacter: '*',
            initialValue: data['password'],
            onChanged: (value) {
              Variables.currentUser.password = value;
            },
          ),
          TextFormField(
            readOnly: Variables.selectedUser.role != 'admin',
            decoration: const InputDecoration(
              labelText: 'Табельный номер',
            ),
            initialValue: data['tableNumber'],
            onChanged: (value) {
              Variables.currentUser.tableNumber = value;
            },
          ),
          TextFormField(
            readOnly: Variables.selectedUser.role != 'admin',
            decoration: const InputDecoration(
              labelText: 'Должность',
            ),
            initialValue: data['position'],
            onChanged: (value) {
              Variables.currentUser.position = value;
            },
          ),
          TextFormField(
            controller: dateOfBirthController,
            readOnly: true,
            //Variables.selectedUser.role != 'admin',
            onTap: () async {
              if (Variables.selectedUser.role == 'admin') {
                Variables.currentUser.dateOfBirth =
                    await AlertDialogs.selectDate(
                        Variables.currentUser.dateOfBirth, context);
                dateOfBirthController.text =
                    DateFormat.yMd().format(Variables.currentUser.dateOfBirth);
              }
            },
            decoration: const InputDecoration(
              labelText: 'Дата рождения',
            ),
            // initialValue: DateFormat.yMd()
            //     .format(data['dateOfBirth'].toDate())
            //     .toString(),
          ),
          TextFormField(
            controller: dateOfEmploymentController,
            readOnly: true,
            //Variables.selectedUser.role != 'admin',
            onTap: () async {
              if (Variables.selectedUser.role == 'admin') {
                Variables.currentUser.dateOfEmployment =
                    await AlertDialogs.selectDate(
                        Variables.currentUser.dateOfEmployment, context);
                dateOfEmploymentController.text = DateFormat.yMd()
                    .format(Variables.currentUser.dateOfEmployment);
                //    FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            decoration: const InputDecoration(
              labelText: 'Дата трудоустройства',
            ),
            // initialValue: DateFormat.yMd()
            //     .format(data['dateOfEmployment'].toDate())
            //     .toString(),
          ),
          TextFormField(
            readOnly: true,
            controller: scheduleNameController,
            decoration: const InputDecoration(
              labelText: 'График',
            ),
            //initialValue: data['scheduleName'],
            //  initialValue: Variables.currentUser.scheduleName,
            onTap: () {
              if (Variables.selectedUser.role == 'admin') {
                Navigator.pushNamed(context, '/schedules');
              }
            },
            // onChanged: (value) {
            //   Variables.currentUser.scheduleName = value;
            // },
          ),
          TextFormField(
            readOnly: Variables.selectedUser.role != 'admin',
            decoration: const InputDecoration(
              labelText: 'Подразделение',
            ),
            initialValue: data['unit'],
            onChanged: (value) {
              Variables.currentUser.unit = value;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            readOnly: !((Variables.selectedUser.role == 'admin') |
                (Variables.selectedUser.name == Variables.currentUser.name)),
            decoration: const InputDecoration(
              labelText: 'Номер телефона',
            ),
            initialValue: data['phoneNumber'],
            onChanged: (value) {
              Variables.currentUser.phoneNumber = value;
            },
          ),
          TextFormField(
            readOnly: Variables.selectedUser.role != 'admin',
            decoration: const InputDecoration(
              labelText: 'Уровень доступа',
            ),
            initialValue: data['role'],
            onChanged: (value) {
              Variables.currentUser.role = value;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () {
                    if (Variables.selectedUser.role == 'admin') {
                      AlertDialogs.deleteAlertDialogUserScreen(context, index);
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Удалить   ')),
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () {
                    if (Variables.selectedUser.role == 'admin') {
                      //если админ, то сохраняем все поля пользователя, если не админ, то только номер телефона
                      Users.addUser(Variables.currentUser);
                    } else {
                      Users.addUser(Users(
                        data['name'],
                        data['password'],
                        data['tableNumber'],
                        data['position'],
                        data['dateOfBirth'].toDate(),
                        data['dateOfEmployment'].toDate(),
                        data['scheduleName'],
                        data['unit'],
                        Variables.currentUser.phoneNumber,
                        data['role'],
                        !data['isExpanded'],
                      ));
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Сохранить   ')),
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () async {
                    AlertDialogs.selectAlertDialogUserScreen(context, index);
                  },
                  icon: const Icon(Icons.adjust),
                  label: const Text('Выбрать   ')),
            ],
          )
        ],
      ),
    );
  }

  static Widget schedulesScreen(context) {
    final Stream<QuerySnapshot> _schedulesStream =
        FirebaseFirestore.instance.collection('schedules').snapshots();
    //основная таблица  на экране UsersScreen
    return Expanded(
      // child: RefreshIndicator(
      //   onRefresh: pullRefresh,
      child: StreamBuilder<QuerySnapshot>(
          stream: _schedulesStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            int number = 0;
            if (snapshot.hasError) {
              return const Text('Что-то пошло не так');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
              //const Text("Loading");
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                number++;
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Column(children: [
                  SizedBox(
                    height: rowHeight * 2,
                    child: schedulesMainScreenName(context, number, data),
                    //заголовок пользователя в списке пользователей
                  ),
                  SizedBox(
                    height:
                        States.isSchedulePressed[number] ? rowHeight * 12 : 0.0,
                    child: schedulesMainScreenData(context, number, data),
                    //данные пользователя в списке пользователей
                  ),
                ]);
              }).toList(),
            );
          }),
    );
  }

  static Widget schedulesMainScreenName(context, int index, data) {
    return Row(
      children: [
        Container(
            padding: const EdgeInsets.all(2.0),
            height: rowHeight * 2,
            width: firstColumnWidth,
            child: ElevatedButton(
              style: ButtonStyles.headerButtonStyle,
              onPressed: () {},
              child: Text('$index'),
            )),
        Container(
            padding: const EdgeInsets.all(2.0),
            height: rowHeight * 2,
            width: MediaQuery.of(context).size.width - firstColumnWidth,
            child: ElevatedButton(
              style: (Variables.currentSchedule.name == data['name'])
                  ? ButtonStyles.headerButtonStyle
                  : ButtonStyles.usersListButtonStyle,
              onPressed: () {
                Variables.currentSchedule = Schedules(data['name'],
                    data['schedule'].cast<int>(), !data['isExpanded']);

                // Variables.setPrefs(data['name']);

                if (States.isSchedulePressed[index]) {
                  States.isSchedulePressed = List.filled(100, false);
                } else {
                  States.isSchedulePressed = List.filled(100, false);
                  States.isSchedulePressed[index] =
                      !States.isSchedulePressed[index];
                }
                Schedules.addSchedule(
                    //сделано для обновления экрана
                    Variables.currentSchedule.name,
                    Variables.currentSchedule.schedule,
                    Variables.currentSchedule.isExpanded);
              },
              child: ListTile(
                title: Text(data['name']),
              ),
            )),
      ],
    );
  }

  static Widget schedulesMainScreenData(
      context, index, Map<String, dynamic> data) {
    //полные данные пользователей
    return Container(
      padding: const EdgeInsets.all(0.0),
      // height: States.isNamePressed[number] ? rowHeight * 15 : 0.0,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Название графика',
            ),
            readOnly: Variables.selectedUser.role != 'admin',
            initialValue: data['name'],
            onChanged: (value) {
              Variables.currentSchedule.name = value;
            },
          ),

          Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: schedulesMainScreenDataSample(
                    context, Variables.currentSchedule.schedule),
              )),
          //todo schedule
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () {
                    if (Variables.selectedUser.role == 'admin') {
                      AlertDialogs.deleteAlertDialogSchedulesScreen(
                          context, index);
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Удалить   ')),
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () async {
                    if (Variables.selectedUser.role == 'admin') {
                      await Schedules.addSchedule(
                          Variables.currentSchedule.name,
                          Variables.currentSchedule.schedule,
                          !Variables.currentSchedule.isExpanded);
                      Variables.currentSchedule.name = '0';
                      States.isSchedulePressed = List.filled(100, false);
                      Navigator.pushNamed(context, '/schedules');
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Сохранить   ')),
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () {
                    Variables.currentUser.scheduleName =
                        Variables.currentSchedule.name;
                    scheduleNameController.text =
                        Variables.currentSchedule.name;
                    States.isSchedulePressed = List.filled(100, false);
                    Navigator.pushNamed(context, '/users');
                  },
                  icon: const Icon(Icons.adjust),
                  label: const Text('Выбрать   ')),
            ],
          )
        ],
      ),
    );
  }

  static List<Widget> schedulesMainScreenDataSample(
      context, List<int> schedule) {
    //отрисовка 8 недель на экране графиков для отображения графика
    List<Widget> weekWidgets = [];
    DateTime currentDay = DateTime.now();
    for (int week = 0; week < 8; week++) {
      currentDay = currentDay.add(Duration(days: 7 * week));
      weekWidgets.add(
        rowCalendarMonthScreen(getNumberOfWeek(currentDay).toString(),
            getWeekDays(currentDay), context, 'schedules'),
      );
      currentDay = DateTime.now();
    }
    return weekWidgets;
  }

  static Widget dayCalendarScheduleScreen(day, style, context) {
    return StatefulBuilder(builder: (context, setState) {
      return ElevatedButton(
          style: style,
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    DateFormat.d().format(day),
                  ),
                ),
              ),
              SizedBox(
                height: 13,
                child: Text(
                  DateFormat.MMM().format(day),
                  style: const TextStyle(fontSize: 9),
                ),
              ),
            ],
          ),
          onPressed: () {
            int number = day
                    .difference(
                        DateTime(2022).subtract(const Duration(days: 5)))
                    .inDays %
                56; //какой по счету день из 56 занимает текущий обрабатываемый
            if (Variables.currentSchedule.schedule[number] == 1) {
              Variables.currentSchedule.schedule[number] = 2;
            } else if (Variables.currentSchedule.schedule[number] == 2) {
              Variables.currentSchedule.schedule[number] = 26;
            } else if (Variables.currentSchedule.schedule[number] == 26) {
              Variables.currentSchedule.schedule[number] = 1;
            }
            style = ButtonStyles.dayStyle(day, 'schedules');
            setState(() {});
          }
          //        dialogOnMainScreen();
          );
    });
  }
}
