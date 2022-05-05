import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/alertDialogs.dart';
import 'StatesAndVariables.dart';
import 'firestore.dart';
import 'styles.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_core/firebase_core.dart';

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

  static Future<void> pullRefresh() async {
    // await Future.delayed(const Duration(seconds: 1));
    States.isPulled = !States.isPulled;
    // Navigator.pushNamed(context, '/calendarDay');
  }

  static Widget mainBodyCalendarMonthScreen(DateTime day, context) {
    //основная таблица  на экране CalendarMonthScreen
    return Expanded(
      // child: RefreshIndicator(
      //   onRefresh: pullRefresh,
      child: ListView.builder(itemBuilder: (context, index) {
        DateTime lastDayOfWeek = day.add(Duration(days: 7 - day.weekday));
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
        return Column(children: [
          SizedBox(
            //Для отрисовки последней недели предыдущего месяца с затемненными днями
            height: (currentDay.day < 7) ? rowHeight : 0.0,
            child: rowCalendarMonthScreen(
                getNumberOfWeek(currentDay).toString(),
                getWeekDays(currentDay),
                context),
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
                context),
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
      context) {
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
          children: weekCalendarMonthScreen(week, context),
        ),
      ]),
    );
  }

  static List<Widget> weekCalendarMonthScreen(List<dynamic> week, context) {
    //7 дней недели в строке на экране CalendarMonthScreen
    List<Widget> widgets = [];
    var style =
        ButtonStyles.simpleDayButtonStyle; //инициализация переменной style
    for (int day = 0; day < 7; day++) {
      if (week[0] is! String) {
        if (States.isLastWeek) {
          //проверка является ли текущая неделя последней в месяце
          if (week[day].month != week[0].month) {
            //отрисовка дней следующего месяца в последней неделе текущего месяца
            style = ButtonStyles.fadedDayButtonStyle;
          } else {
            ((week[day].year == DateTime.now().year) &&
                    (week[day].month == DateTime.now().month) &&
                    (week[day].day == DateTime.now().day))
                ? //проверка на текущий день и окрашивание его другим цветом
                style = ButtonStyles.currentDayButtonStyle
                : style = ButtonStyles.simpleDayButtonStyle;
          }
        } else {
          if (week[day].month != week[6].month) {
            //отрисовка дней предыдущего месяца в первой неделе текущего месяца
            style = ButtonStyles.fadedDayButtonStyle;
          } else {
            ((week[day].year == DateTime.now().year) &&
                    (week[day].month == DateTime.now().month) &&
                    (week[day].day == DateTime.now().day))
                ? //проверка на текущий день и окрашивание его другим цветом
                style = ButtonStyles.currentDayButtonStyle
                : style = ButtonStyles.simpleDayButtonStyle;
          }
        }
      }
      widgets.add(
        Container(
          padding: const EdgeInsets.fromLTRB(2.0, 1.0, 2.0, 3.0),
          width: (MediaQuery.of(context).size.width - firstColumnWidth) / 7,
          // (MediaQuery.of(context).size.width - firstItemRowWidth) / 7,
          height: rowHeight,
          child: dayCalendarMonthScreen(week[day], style, context),
        ),
      );
    }
    States.isLastWeek = false;
    return widgets;
  }

  static Widget dayCalendarMonthScreen(dynamic day, style, context) {
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
                const Text(
                  '02',
                  style: TextStyle(fontSize: 9),
                ),
                const Text(
                  'B2',
                  style: TextStyle(fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
      //Выбор цвета кнопки в зависимости от наличия событий в эту дату
      onPressed: () {
        Navigator.pushNamed(context, '/calendarDay');
        //считывание всех ивентов для данного пользователя в кликнутую дату
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

                Variables.setPrefs(data['name']);

                if (States.isNamePressed[index])
                  {
                    States.isNamePressed=List.filled(250, false);
                  }
                else{
                  States.isNamePressed=List.filled(250, false);
                  States.isNamePressed[index]=!States.isNamePressed[index];
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

  static Widget usersMainScreenData(context, index, Map<String, dynamic> data) {//полные данные пользователей
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
            onChanged: (value){
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
            onChanged: (value){
              Variables.currentUser.password = value;
            },
          ),
          TextFormField(
            readOnly: Variables.selectedUser.role != 'admin',
            decoration: const InputDecoration(
              labelText: 'Табельный номер',
            ),
            initialValue: data['tableNumber'],
            onChanged: (value){
              Variables.currentUser.tableNumber = value;
            },
          ),
          TextFormField(
            readOnly: Variables.selectedUser.role != 'admin',
            decoration: const InputDecoration(
              labelText: 'Должность',
            ),
            initialValue: data['position'],
            onChanged: (value){
              Variables.currentUser.position = value;
            },
          ),
          TextFormField(
            readOnly: true,
            //Variables.selectedUser.role != 'admin',
            onTap: () async {
              Variables.currentUser.dateOfBirth = await AlertDialogs.selectDate(Variables.currentUser.dateOfBirth, context);
            },
            decoration: const InputDecoration(
              labelText: 'Дата рождения',
            ),
            initialValue: DateFormat.yMd()
                .format(data['dateOfBirth'].toDate())
                .toString(),
          ),
          TextFormField(
            readOnly: true,
            //Variables.selectedUser.role != 'admin',
            onTap:() async {
              Variables.currentUser.dateOfEmployment = await AlertDialogs.selectDate(Variables.currentUser.dateOfEmployment, context);
          //    FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: const InputDecoration(
              labelText: 'Дата трудоустройства',
            ),
            initialValue: DateFormat.yMd()
                .format(data['dateOfEmployment'].toDate())
                .toString(),
          ),
          TextFormField(
            readOnly: Variables.selectedUser.role != 'admin',
            decoration: const InputDecoration(
              labelText: 'График',
            ),
            initialValue: data['scheduleName'],
            onChanged: (value){
              Variables.currentUser.scheduleName = value;
            },
          ),
          TextFormField(
            readOnly: Variables.selectedUser.role != 'admin',
            decoration: const InputDecoration(
              labelText: 'Подразделение',
            ),
            initialValue: data['unit'],
            onChanged: (value){
              Variables.currentUser.unit = value;
            },
          ),
          TextFormField(
            readOnly: false,
            decoration: const InputDecoration(
              labelText: 'Номер телефона',
            ),
            initialValue: data['phoneNumber'],
            onChanged: (value){
              Variables.currentUser.phoneNumber = value;
            },
          ),
          TextFormField(
            readOnly: Variables.selectedUser.role != 'admin',

            decoration: const InputDecoration(
              labelText: 'Уровень доступа',
            ),
            initialValue: data['role'],
            onChanged: (value){
              Variables.currentUser.role = value;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () {
                    Users.deleteUser(Variables.currentUser.name);
                    Navigator.pushNamed(context, '/users');
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Удалить   ')),
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () {
           //    showDialog(
           // context: context,
           //  builder: (BuildContext context) {
           //    return AlertDialog(
           //    content:

               Users.addUser(Variables.currentUser);

               Navigator.pushNamed(context, '/users');
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Сохранить   ')),
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () {
                    Variables.selectedUser = Variables.currentUser;
                    States.isNamePressed[index] = !States.isNamePressed[index];
                    //сделано для обновления экрана
                    Variables.currentUser.isExpanded =
                        !Variables.currentUser.isExpanded;
                    Users.addUser(Variables.currentUser);
                    //сделано для обновления экрана
                  },
                  icon: const Icon(Icons.adjust),
                  label: const Text('Выбрать   ')),
            ],
          )
        ],
      ),
    );
  }
}
