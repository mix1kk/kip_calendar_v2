import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/AlertDialogs.dart';
import 'package:kip_calendar_v2/StatesAndVariables.dart';
import 'package:kip_calendar_v2/Database.dart';
import 'package:kip_calendar_v2/Styles.dart';
import 'package:intl/intl.dart';

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
              style: (Variables.currentSchedule.name == data['name'])
                  ? ButtonStyles.headerButtonStyle
                  : ButtonStyles.usersListButtonStyle,
              onPressed: () {
                if (Variables.selectedSchedule.name==data['name']) {
                  Variables.selectedSchedule.name='';
                } else {
                  // Variables.selectedSchedule.name=data['name'];
                  Variables.selectedSchedule = Schedules(data['name'],
                      data['schedule'].cast<int>(), !data['isExpanded']);
                }
                print(Variables.selectedSchedule.name);
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
                          Variables.selectedSchedule.name,
                          Variables.selectedSchedule.schedule,
                          !Variables.selectedSchedule.isExpanded);
                      //   Variables.currentSchedule.name = '0';
                      //  States.isSchedulePressed = List.filled(100, false);
                      Navigator.pushNamed(context, '/schedules');
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Сохранить   ')),
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () {
                    Variables.currentUser.scheduleName =
                        Variables.selectedSchedule.name;
                    Variables.currentSchedule=Variables.selectedSchedule;
                    scheduleNameController.text =
                        Variables.currentSchedule.name;
                    // States.isSchedulePressed = List.filled(100, false);
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
        Widgets.rowCalendarMonthScreen(getNumberOfWeek(currentDay).toString(),
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
            style = ButtonStyles.dayStyle(day,Variables.currentSchedule.schedule, 'schedules');
            setState(() {});
          }
        //        dialogOnMainScreen();
      );
    });
  }



//   static Widget eventsScreen(context,List<String> name) {
//     Stream <QuerySnapshot> stream = FirebaseFirestore.instance
//         .collection('events')//.where('userName',arrayContainsAny: name)
//         .snapshots();
//
//     //основная таблица  на экране Events
//     return Expanded(
//       child: StreamBuilder<QuerySnapshot>(
//           stream: stream,
//
//           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> events) {
//
//             if (events.hasError) {
//               return const Text('Что-то пошло не так');
//             }
//
//             if (events.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//               //const Text("Loading");
//             }
//               return ListView.builder(
//                 itemCount: events.data!.docs.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Column(children: [
//                     eventsMainScreenName(
//                         context,
//                         index,
//                         events.data!.docs[index],
//                     ),
//                     SizedBox(
//                       height:
//                       (events.data!.docs[index].id == States.eventPressed )? Variables.rowHeight * 11 : 0.0,
//                       child: eventsMainScreenData(context,
//                       events.data!.docs[index],),
//                     ),
//                   ]);
//                 });
//             })
//     );
//   }
//
//
//
//   static Widget eventsMainScreenName(context, int index, DocumentSnapshot event) {//построение списка с названиями событий для всех пользователей
//       Events newEvent = Events.getEventFromSnapshot(event);
//     return Row(
//       children: [
//         Container(
//             padding: const EdgeInsets.all(2.0),
//             height: Variables.rowHeight * 2,
//             width: Variables.firstColumnWidth,
//             child: ElevatedButton(
//               style: ButtonStyles.headerButtonStyle,
//               onPressed: () {},
//               child: Text('${index + 1}'),
//             )),
//         Container(
//             padding: const EdgeInsets.all(2.0),
//             height: Variables.rowHeight * 2,
//             width:
//                 MediaQuery.of(context).size.width - Variables.firstColumnWidth,
//             child: ElevatedButton(
//               style: (event.id == States.eventPressed)?ButtonStyles.headerButtonStyle:ButtonStyles.usersListButtonStyle,
//               onPressed: () async{
//                 if (event.id == States.eventPressed)
//                  { States.eventPressed='';
//                  Variables.currentEvent = Variables.initialEvent;
//                 }
//                 else {
//                   States.eventPressed=event.id;
//                   Variables.currentEvent = newEvent;
//                   startDateEventController.text =
//                       DateFormat.yMd().format(Variables.currentEvent.startDate);
//                   dateOfNotificationEventController.text = DateFormat.yMd()
//                       .format(Variables.currentEvent.dateOfNotification);
//                   endDateEventController.text = DateFormat.yMd()
//                       .format(Variables.currentEvent.endDate);
//                 }//для окрашивания выбранного ивента
//                 newEvent.isExpanded = !newEvent.isExpanded;//для обновления экрана
//                  await Events.updateEvent(newEvent,event.id);//для обновления экрана
//               },
//               child: ListTile(
//                 title: Text(newEvent.event),
//                 subtitle: Text(newEvent.userName.toString()),
//               ),
//             )),
//       ],
//     );
//   }
//   static Widget eventsMainScreenData(context, DocumentSnapshot event) {
//     //полные данные пользователей
//     return Container(
//       padding: const EdgeInsets.all(2.0),
//       width: MediaQuery.of(context).size.width,
//       child: Column(
//         children: [
//           TextFormField(
//             readOnly: Variables.selectedUser.role != 'admin',
//             decoration: const InputDecoration(
//               labelText: 'Название события',
//             ),
//             initialValue: Variables.currentEvent.event,
//             onChanged: (value) {
//               Variables.currentEvent.event = value;
//             },
//           ),
//           TextFormField(
//             controller: startDateEventController,
//             readOnly: true,
//             onTap: () async {
//               if (Variables.selectedUser.role == 'admin') {
//                 Variables.currentEvent.startDate =
//                 await AlertDialogs.selectDate(
//                     Variables.currentEvent.startDate, context);
//                 startDateEventController.text =
//                     DateFormat.yMd().format(Variables.currentEvent.startDate);
//               }
//             },
//             decoration: const InputDecoration(
//               labelText: 'Дата начала события',
//             ),
//           ),
//           TextFormField(
//             controller: endDateEventController,
//             readOnly: true,
//             onTap: () async {
//               if (Variables.selectedUser.role == 'admin') {
//                 Variables.currentEvent.endDate =
//                 await AlertDialogs.selectDate(
//                     Variables.currentEvent.endDate, context);
//                 endDateEventController.text = DateFormat.yMd()
//                     .format(Variables.currentEvent.endDate);
//                 //    FocusManager.instance.primaryFocus?.unfocus();
//               }
//             },
//             decoration: const InputDecoration(
//               labelText: 'Дата окончания события',
//             ),
//           ),
//
//           TextFormField(
//             controller: dateOfNotificationEventController,
//             readOnly: true,
//             onTap: () async {
//               if (Variables.selectedUser.role == 'admin') {
//                 Variables.currentEvent.dateOfNotification =
//                 await AlertDialogs.selectDate(
//                     Variables.currentEvent.dateOfNotification, context);
//                 dateOfNotificationEventController.text = DateFormat.yMd()
//                     .format(Variables.currentEvent.dateOfNotification);
//                 //    FocusManager.instance.primaryFocus?.unfocus();
//               }
//             },
//             decoration: const InputDecoration(
//               labelText: 'Дата напоминания',
//             ),
//           ),
//           TextFormField(
//             readOnly: Variables.selectedUser.role != 'admin',
//             decoration: const InputDecoration(
//               labelText: 'Тип события',
//             ),
//             initialValue: Variables.currentEvent.typeOfEvent,
//             onChanged: (value) {
//               Variables.currentEvent.typeOfEvent = value;
//             },
//           ),
//           TextFormField(
//             readOnly: Variables.selectedUser.role != 'admin',
//             decoration: const InputDecoration(
//               labelText: 'Комментарий',
//             ),
//             initialValue: Variables.currentEvent.comment,
//             onChanged: (value) {
//               Variables.currentEvent.comment = value;
//             },
//           ),
//           //todo: сделать флаг "задание выполнено"
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ElevatedButton.icon(
//                   style: ButtonStyles.headerButtonStyle,
//                   onPressed: () async{
//                     if (Variables.selectedUser.role == 'admin') {
//                       await AlertDialogs.deleteEventsScreen(context, Variables.currentEvent.userName,event.id);
//                       Variables.allEvents.clear();
//                       Variables.allEvents=await Events.getAllEventsForUser([Variables.selectedUser.name]);
//                     //  Events.deleteEvent(Variables.currentEvent.userName, event.id);
// //todo:добавить уведомление о недостаточности прав , если не админ
//                     }
//                   },
//                   icon: const Icon(Icons.delete),
//                   label: const Text('Удалить   ')),
//               ElevatedButton.icon(
//                   style: ButtonStyles.headerButtonStyle,
//                   onPressed: () async{
//                     if (Variables.selectedUser.role == 'admin') {
//                       States.eventPressed='';
//                       Variables.currentEvent.isExpanded=!Variables.currentEvent.isExpanded;
//                       await Events.updateEvent(Variables.currentEvent,event.id);
//                       Variables.allEvents.clear();
//                       Variables.allEvents=await Events.getAllEventsForUser([Variables.selectedUser.name]);
//
//                       // Variables.currentEvent.isExpanded=!Variables.currentEvent.isExpanded;
//                       // await Events.updateEvent(Variables.currentEvent,event.id);
//                     }
//
//                   },
//                   icon: const Icon(Icons.save),
//                   label: const Text('Сохранить   ')),
//             ],
//           )
//         ],
//       ),
//     );
//   }
}
