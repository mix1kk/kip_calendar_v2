import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/AlertDialogs.dart';
import 'Schedules/Widgets/SchedulesWidgets.dart';
import 'StatesAndVariables.dart';
import 'Database.dart';
import 'Styles.dart';
import 'package:intl/intl.dart';

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
          Variables.rowHeight = 40.0;
        } else {
          if ((currentDay.month) < DateTime.now().month) {
            Variables.rowHeight = 0.0;
          } else {
            Variables.rowHeight = 40.0;
          }
        }
        //скрытие прошедших месяцев
        return Column(children: [
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
              height: (currentDay.day < 8) ? 25 : 0.0,
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

  static Widget rowCalendarMonthScreen(
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

  static List<Widget> weekCalendarMonthScreen(
      List<dynamic> week, context, String callPlace) {
    bool isEvent = false;
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

            for (int i=0;i<Variables.allEvents.length;i++) {
              if(week[day].millisecondsSinceEpoch>=Variables.allEvents[i].startDate.millisecondsSinceEpoch&&
                  week[day].millisecondsSinceEpoch<=Variables.allEvents[i].endDate.millisecondsSinceEpoch)
              {isEvent=true;}//определение ивента в текущий день и окрашивание в цвет ивента
            }


            style = ButtonStyles.dayStyle(week[day],Variables.currentSchedule.schedule,
                callPlace); // раскрашивание дней в соответствии с графиком
          }
        } else {
          if (week[day].month != week[6].month && callPlace == 'main') {
            //отрисовка затемненных дней предыдущего месяца в первой неделе текущего месяца, если вызвано с главного экрана
            style = ButtonStyles.fadedDayButtonStyle;
          } else {

            for (int i=0;i<Variables.allEvents.length;i++) {
              if(week[day].millisecondsSinceEpoch>=Variables.allEvents[i].startDate.millisecondsSinceEpoch&&
                  week[day].millisecondsSinceEpoch<=Variables.allEvents[i].endDate.millisecondsSinceEpoch)
              {isEvent=true;}//определение ивента в текущий день для окрашивания рамки в цвет ивента
            }


            style = ButtonStyles.dayStyle(week[day],Variables.currentSchedule.schedule,
                callPlace); // раскрашивание дней в соответствии с графиком
          }
        }
      }

      widgets.add(
        Container(
          padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
          decoration: isEvent?  BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.orangeAccent,
              border: Border.all(color: Colors.white)
          ):  BoxDecoration(
          //  color: Colors.white,
             border: Border.all(color: Colors.white),
          ),
          width:
              (MediaQuery.of(context).size.width - Variables.firstColumnWidth) /
                  7,
          height: Variables.rowHeight,
          child: (callPlace == 'main')
              ? dayCalendarMonthScreen(week[day], style, context)
              : SchedulesWidgets.dayCalendarScheduleScreen(week[day], style, context),
        ),
      );
      isEvent=false;
    }
    States.isLastWeek = false;
    return widgets;
  }

  static Widget dayCalendarMonthScreen(dynamic day, style, context) {
   // List<Events> listEvents;
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
    return
      Container( // внутренний контейнер для исключения смешивания цвета внешнего контейнера и кнопки
        decoration:   BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5))
        ),
        child:
      ElevatedButton(
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
            child: ElevatedButton(
            style: ButtonStyles.fadedDayButtonStyle,
              child:
            Text(
                  dayNumberByTK, //Номер дня по ТК
                  style: const TextStyle(fontSize: 9),
                ),
              onPressed: (){},
            )
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Text(
            //       dayNumberByTK, //Номер дня по ТК
            //       style: const TextStyle(fontSize: 9),
            //     ),
            //     Text(
            //       dayLetterByTK, //Обозначение дня по ТК
            //       style: const TextStyle(fontSize: 9),
            //     ),
            //   ],
            // ),
          ),
        ],
      ),
      //todo Выбор цвета кнопки в зависимости от наличия событий в эту дату
      onPressed: () async{
        // if (day is! String) {
        //   listEvents=await Events.getAllEventsToDate(day, [Variables.selectedUser.name]);
        //   Navigator.pushNamed(context, '/calendarDay');
        // }
        //todo считывание всех ивентов для данного пользователя в кликнутую дату
        //        dialogOnMainScreen();
      },
    )
      )
    ;
  }
}
