import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/Users/Users.dart';
import 'package:kip_calendar_v2/Menu/Menu.dart';
import 'package:kip_calendar_v2/Events/Events.dart';
import 'StatesAndVariables.dart';
import 'styles.dart';
import 'dart:ui';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

// import 'package:firebase_core/firebase_core.dart';

double rowHeight = 40.0; // Высота строк
double firstColumnWidth = 60.0; //Ширина первого столбца с номерами недели

class Widgets {
  final Function update;

  Widgets(this.update);

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
    //основная таблица  на экране UsersScreen
    return Expanded(
      // child: RefreshIndicator(
      //   onRefresh: pullRefresh,
      child: ListView.builder(itemBuilder: (context, index) {
        return Column(children: [
          SizedBox(
            height: rowHeight * 2,
            child: usersMainScreenName(context, index),
            //построение основной таблицы строка за строкой
          ),
          SizedBox(
            height: States.isNamePressed?rowHeight * 10:0.0,
            child: usersMainScreenData(context, index),
            //построение основной таблицы строка за строкой
          ),
        ]);
      }),
      // ),
    );
  }

  static Widget usersMainScreenName(context, index) {
    return Row(
      children: [
        Container(
            padding: const EdgeInsets.all(2.0),
            height: rowHeight * 2,
            width: firstColumnWidth,
            child: ElevatedButton(
              style: ButtonStyles.headerButtonStyle,
              onPressed: () {},
              child: Text('${index + 1}'),
            )),
        Container(
            padding: const EdgeInsets.all(2.0),
            height: rowHeight * 2,
            width: MediaQuery.of(context).size.width - firstColumnWidth,
            child: ElevatedButton(
              style: ButtonStyles.usersListButtonStyle,
              onPressed: () {
                States.isNamePressed=!States.isNamePressed;

              },
              child: const Text('Байкин Михаил Сергеевич'),
            )),
      ],
    );
  }

  static Widget usersMainScreenData(context, index) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      height:rowHeight*10,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2.0),
            height: rowHeight,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              style: ButtonStyles.usersListButtonStyle,
              onPressed: () {},
              child: const Text('Байкин Михаил Сергеевич'),
            ),
          ),
        ],
      ),
    );
  }
}
