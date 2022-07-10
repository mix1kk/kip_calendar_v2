import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/AlertDialogs.dart';
import 'package:kip_calendar_v2/StatesAndVariables.dart';
import 'package:kip_calendar_v2/Database.dart';
import 'package:kip_calendar_v2/Styles.dart';
import 'package:intl/intl.dart';

import '../../Events/Events.dart';
import '../../Widgets.dart';
//
// final TextEditingController dateOfBirthController = TextEditingController();
// final TextEditingController dateOfEmploymentController = TextEditingController();
final TextEditingController scheduleNameController = TextEditingController();
// final TextEditingController startDateEventController = TextEditingController();
// final TextEditingController endDateEventController = TextEditingController();
// final TextEditingController dateOfNotificationEventController = TextEditingController();


class SchedulesWidgets {
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


  static Widget schedulesScreen(context) {
    // final Stream<QuerySnapshot> _schedulesStream =
    //     FirebaseFirestore.instance.collection('schedules').snapshots();
    //основная таблица  на экране UsersScreen
    return Expanded(
      // child: RefreshIndicator(
      //   onRefresh: pullRefresh,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('schedules').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            int number = 0;
            if (snapshot.hasError) {
              return const Text('Что-то пошло не так');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                number++;
                Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
                return Column(children: [
                  SizedBox(
                    height: Variables.rowHeight * 2,
                    child: schedulesMainScreenName(context, number, data),
                    //заголовок пользователя в списке пользователей
                  ),
                  SizedBox(
                    height: Variables.selectedSchedule.name==data['name']
                        ? Variables.rowHeight * 12
                        : 0.0,
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
            height: Variables.rowHeight * 2,
            width: Variables.firstColumnWidth,
            child: ElevatedButton(
              style: ButtonStyles.headerButtonStyle,
              onPressed: () {},
              child: Text('$index'),
            )),
        Container(
            padding: const EdgeInsets.all(2.0),
            height: Variables.rowHeight * 2,
            width:
            MediaQuery.of(context).size.width - Variables.firstColumnWidth,
            child: ElevatedButton(
              style: (Variables.selectedSchedule.name == data['name'])
                  ? ButtonStyles.headerButtonStyle
                  : ButtonStyles.usersListButtonStyle,
              onPressed: () {
                if (Variables.selectedSchedule.name==data['name']) {
                  Variables.selectedSchedule.name='';
                } else {
                  Variables.selectedSchedule = Schedules(data['name'],
                      data['schedule'].cast<int>(), !data['isExpanded']);
                }
                Schedules.addSchedule(
                  //сделано для обновления экрана
                    data['name'],
                    data['schedule'].cast<int>(),
                    !data['isExpanded']);
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
              Variables.selectedSchedule.name = value;
            },
          ),

          Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: schedulesMainScreenDataSample(
                    context, Variables.selectedSchedule.schedule),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () {
                    if (Variables.selectedUser.role == 'admin') {
                      AlertDialogs.deleteAlertDialogSchedulesScreen(
                          context, index);
                      //todo: сделать подтверждение удаления графика работы
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Удалить   ')),
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () async {
                    if (Variables.selectedUser.role == 'admin') {
                      await Schedules.addSchedule(
                          Variables.selectedSchedule.name,
                          Variables.selectedSchedule.schedule,
                          !Variables.selectedSchedule.isExpanded);
                      Navigator.pushNamed(context, '/schedules');
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Сохранить   ')),
              //todo: всплывающее окно с подтверждением сохранения
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () {
                    Variables.currentUser.scheduleName =
                        Variables.selectedSchedule.name;
                    Variables.currentUserSchedule=Variables.selectedSchedule;
                    scheduleNameController.text =
                        Variables.currentUserSchedule.name;
                    // States.isSchedulePressed = List.filled(100, false);
                    Navigator.pushNamed(context, '/users');
                  },
                  icon: const Icon(Icons.add_task),
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
        /*Widgets.*/rowCalendarMonthScreen(getNumberOfWeek(currentDay).toString(),
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
            if (Variables.currentUserSchedule.schedule[number] == 1) {
              Variables.currentUserSchedule.schedule[number] = 2;
            } else if (Variables.currentUserSchedule.schedule[number] == 2) {
              Variables.currentUserSchedule.schedule[number] = 26;
            } else if (Variables.currentUserSchedule.schedule[number] == 26) {
              Variables.currentUserSchedule.schedule[number] = 1;
            }
            style = ButtonStyles.dayStyle(day,Variables.currentUserSchedule.schedule, 'schedules');
            setState(() {});
          }
        //        dialogOnMainScreen();
      );
    });
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
    BoxDecoration boxDecoration = ButtonStyles.simpleBoxDecoration;
    // bool isEvent = false;
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

            for (int i=0;i<Variables.allEvents.length;i++) {//определение ивента в текущий день и окрашивание в цвет ивента

              if((Variables.setZeroTime (week[day]).compareTo(Variables.setZeroTime (Variables.allEvents[i].startDate))>=0)&&
                  (Variables.setZeroTime (week[day]).compareTo(Variables.setZeroTime (Variables.allEvents[i].endDate))<=0))
              {boxDecoration = ButtonStyles.eventBoxDecoration;}
            }


            style = ButtonStyles.dayStyle(week[day],Variables.currentUserSchedule.schedule,
                callPlace); // раскрашивание дней в соответствии с графиком
          }
        } else {
          if (week[day].month != week[6].month && callPlace == 'main') {
            //отрисовка затемненных дней предыдущего месяца в первой неделе текущего месяца, если вызвано с главного экрана
            style = ButtonStyles.fadedDayButtonStyle;
          } else {

            for (int i=0;i<Variables.allEvents.length;i++) {
              if((Variables.setZeroTime (week[day]).compareTo(Variables.setZeroTime (Variables.allEvents[i].startDate))>=0)&&
                  (Variables.setZeroTime (week[day]).compareTo(Variables.setZeroTime (Variables.allEvents[i].endDate))<=0))
              {boxDecoration = ButtonStyles.eventBoxDecoration;}//определение ивента в текущий день для окрашивания рамки в цвет ивента
            }


            style = ButtonStyles.dayStyle(week[day],Variables.currentUserSchedule.schedule,
                callPlace); // раскрашивание дней в соответствии с графиком
          }
        }
      }

      widgets.add(
        Container(
          padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
          decoration: boxDecoration,
          width:
          (MediaQuery.of(context).size.width - Variables.firstColumnWidth) /
              7,
          height: Variables.rowHeight,
          child: (callPlace == 'main')
              ? dayCalendarMonthScreen(week[day], style, context)
              : SchedulesWidgets.dayCalendarScheduleScreen(week[day], style, context),
        ),
      );
      boxDecoration = ButtonStyles.simpleBoxDecoration;
    }
    States.isLastWeek = false;
    return widgets;
  }

  static Widget dayCalendarMonthScreen(dynamic day, style, context) {
    // List<Events> listEvents;
    BoxDecoration boxDecoration = ButtonStyles.unselectedInnerBoxDecoration;
    String dayNumberByTK = '';
    if (day is DateTime && style != ButtonStyles.fadedDayButtonStyle) {
      dayNumberByTK =
          Schedules.getWorkingDay(day, Variables.currentUserSchedule.schedule)
              .toString(); //Номер дня по ТК
//Обозначение дня по ТК
    }
    if (day is DateTime && Variables.setZeroTime (day).compareTo(Variables.setZeroTime (States.startSelection))>=0 &&
        Variables.setZeroTime (day).compareTo(Variables.setZeroTime (States.endSelection))<=0)
    {
      boxDecoration = ButtonStyles.selectedInnerBoxDecoration;
    }
    else {boxDecoration = ButtonStyles.unselectedInnerBoxDecoration;}

    return
      Container( // внутренний контейнер для исключения смешивания цвета внешнего контейнера и кнопки
          decoration:  boxDecoration,
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
                ),
              ],
            ),
            onLongPress: () {},
            onPressed: (){
              if (States.startSelection == DateTime(2022)) {
                States.startSelection = day;
                States.endSelection = day;
              }
              else {
                if( day == States.startSelection){
                  States.startSelection = DateTime(2022);
                  States.endSelection = DateTime(2022);
                }
                else{
                  if( States.startSelection != States.endSelection) {
                    States.startSelection = DateTime(2022);
                    States.endSelection = DateTime(2022);
                  }
                  else{
                    States.endSelection=day;
                  }

                }

              }
//todo: доделать выбор диапазона
            },
          )
      )
    ;
  }
}
