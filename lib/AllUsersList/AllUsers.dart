import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kip_calendar_v2/StatesAndVariables.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../AlertDialogs.dart';
import '../Database.dart';
import '../Styles.dart';
import '../main.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({Key? key, required this.users}) : super(key: key);
  final List<Users> users;

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  late LinkedScrollControllerGroup _controllers;

  // late ScrollController controller;
//  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    // controller = _controllers.addAndGet();
    //controller.offset=
  }

  static ButtonStyle getButtonStyle(
      int index, List<int> userSchedule, Users user) {
    DateTime day = DateTime(2022).add(Duration(days: index));

    ButtonStyle style = ButtonStyles.fadedDayButtonStyle;
    {
      style = ButtonStyles.dayStyle(
          // раскрашивание дней в соответствии с графиком
          day,
          userSchedule,
          '/allUsers');

      for (int i = 0; i < Variables.allEvents.length; i++) {
        //определение ивента в текущий день для окрашивания рамки в цвет ивента
        if ((day.year == DateTime.now().year) && (day.month == DateTime.now().month) && (day.day == DateTime.now().day)){
          style = ButtonStyles.currentDayButtonStyle;
        }
        else {
        if ((Variables.setZeroTime(day).compareTo(
                    Variables.setZeroTime(Variables.allEvents[i].startDate)) >=
                0) &&
            (Variables.setZeroTime(day).compareTo(
                    Variables.setZeroTime(Variables.allEvents[i].endDate)) <=
                0) &&
            (Variables.allEvents[i].userName.contains(user.name))) {
          if (Variables.allEvents[i].typeOfEvent == 'Больничный') {
            style = ButtonStyles.illnessButtonStyle;
          } else {
            if ((Variables.allEvents[i].typeOfEvent == 'Отпуск') ||
                (Variables.allEvents[i].typeOfEvent ==
                    'Дополнительный отпуск') ||
                (Variables.allEvents[i].typeOfEvent == 'Учебный отпуск')) {
              style = ButtonStyles.vacationButtonStyle;
            } else {
              if ((Variables.allEvents[i].typeOfEvent == 'Прогул') ||
                  (Variables.allEvents[i].typeOfEvent == 'Отгул')) {
                style = ButtonStyles.otgulButtonStyle;
              } else {
                style = ButtonStyles.activeEventButtonStyle;
              }
            }
          }
        }
      }
      }
    }

    return style;
  }

  void jumpToDate(DateTime dateTime) {
    //промотка списка на конкретную величину, перенести в календарь
    double shift = (dateTime.difference(DateTime(2022)).inDays - 3) *
        Variables.rowHeight;
    _controllers.jumpTo(shift);

    // scrollController.jumpTo(scrollController.initialScrollOffset+Variables.rowHeight * shift);
    /* controller.animateTo(
      controller.initialScrollOffset+Variables.rowHeight * shift,
      duration: const Duration(seconds: 3),
      curve: Curves.fastOutSlowIn,
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.update),
            onPressed: () {
              jumpToDate(DateTime.now());
              // setState(() {});
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
              child: Text('Все пользователи', style: TextStyle(fontSize: 20.0)),
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
                    child: (Variables.selectedUsers.length > 1)
                        ? const Text('[  . . .  ]')
                        : Text(Variables.selectedUsers.toString(),
                            style: const TextStyle(fontSize: 12.0)),
                    onPressed: () async {
                      await AlertDialogs.selectUsersAlertDialog(
                          context, '/allUsers');
                    },
                  ),
                )),
          ],
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            ///верхняя шапка
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              Container(
                ///Первый столбец с именами
                padding: const EdgeInsets.all(2),
                width: Variables.rowHeight * 3,
                height: Variables.rowHeight,
                child: ElevatedButton(
                  style: ButtonStyles.headerButtonStyle,
                  child: //Text('${_controllers.offset}'),
                      const Text('Ф.И.О.'),
                  onPressed: () async {
                    await AlertDialogs.selectUsersAlertDialog(
                        context, '/allUsers');
                  },
                ),
              ),
              SizedBox(
                ///остальная часть с днями недели
                width:
                    MediaQuery.of(context).size.width - Variables.rowHeight * 3,
                height: Variables.rowHeight,
                child: ListView.builder(
                  key: const ObjectKey(Text('Ф.И.О.')),
                  //ключ нужен для добавления контроллеров скролла в группу
                  primary: false,
                  padding: const EdgeInsets.all(2),
                  controller: //controller,
                      _controllers.addAndGet(),
                  //добавление контроллеров скролла в группу для совместного скролла всех строк
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      // одна ячейка с днем
                      padding: const EdgeInsets.all(2),
                      width: Variables.rowHeight,
                      height: Variables.rowHeight,
                      child: ElevatedButton(
                        style: ButtonStyles.headerButtonStyle,
                        // базовая раскраска по графику
                        child:
                            // Column(
                            //   children: [
                            //     Text(
                            //         DateFormat.y().format(DateTime(2022)
                            //             .add(Duration(days: index))).toString(),style: const TextStyle(fontSize: 8)),
                            //     Text(
                            //         DateFormat.MMMM().format(DateTime(2022)
                            //             .add(Duration(days: index))).toString(),style: const TextStyle(fontSize: 8)),

                            Text(
                                DateFormat.E()
                                    .format(DateTime(2022)
                                        .add(Duration(days: index)))
                                    .toString(),
                                style: const TextStyle(fontSize: 8)),
                        // ],
                        // ),
                        onPressed: () {},
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),

          // Expanded(
          //
          //     child:
          Expanded(
            // height: Variables.rowHeight*10,
            child: ListView.builder(
                itemCount: Variables.allUsers.length,
                padding: const EdgeInsets.all(0),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int rowIndex) {
                  List<int> userSchedule = List.filled(56, 26);
                  for (int i = 0; i < Variables.allSchedules.length; i++) {
                    if (Variables.allSchedules[i].name ==
                        Variables.allUsers[rowIndex].scheduleName) {
                      //для каждого пользователя свой график
                      userSchedule = Variables.allSchedules[i].schedule;
                    }
                  }
                  List<String> _initials = Variables.allUsers[rowIndex].name
                      .split(' '); //разделяет фио по словам

                  return Row(
                    children: [
                      Container(
                        ///Первый столбец с именами
                        padding: const EdgeInsets.all(2),
                        width: Variables.rowHeight * 3,
                        height: (Variables.selectedUsers
                                .contains(Variables.allUsers[rowIndex].name))
                            ? Variables.rowHeight
                            : 0.0,
                        child: ElevatedButton(
                          style: ButtonStyles.usersListButtonStyle,
                          child: Text(_initials[0] +
                              ' ' +
                              _initials[1][0] +
                              '. ' +
                              _initials[2][0] +
                              '.'),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(
                        ///остальная часть с днями
                        width: MediaQuery.of(context).size.width -
                            Variables.rowHeight * 3,
                        height: (Variables.selectedUsers
                                .contains(Variables.allUsers[rowIndex].name))
                            ? Variables.rowHeight
                            : 0.0,
                        child: ListView.builder(
                          key: ObjectKey(Variables.allUsers[rowIndex].name),
                          //ключ нужен для добавления контроллеров скролла в группу
                          primary: false,
                          padding: const EdgeInsets.all(2),
                          controller: _controllers.addAndGet(),
                          //добавление контроллеров скролла в группу для совместного скролла всех строк
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int columnIndex) {
                            return Container(
                              // одна ячейка с днем

                              padding: const EdgeInsets.all(2),
                              width: Variables.rowHeight,
                              height: Variables.rowHeight,
                              child: ElevatedButton(
                                style: getButtonStyle(columnIndex,userSchedule,Variables.allUsers[rowIndex]),

                                /// ButtonStyles.dayStyle(
                                //     DateTime(2022).add(Duration(days: index)),
                                //     userSchedule,
                                //     '/allUsers'),
                                // базовая раскраска по графику
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  child: ElevatedButton(
                                    style: ButtonStyles.fadedDayButtonStyle,
                                    onPressed: () {},
                                    child: ElevatedButton(
                                      style: ButtonStyles.dayStyle(
                                          DateTime(2022)
                                              .add(Duration(days: columnIndex)),
                                          userSchedule,
                                          '/allUsers'),
                                      child: Text(
                                          /*data['schedule'][index].toString()*/
                                          DateTime(2022)
                                              .add(Duration(days: columnIndex))
                                              .day
                                              .toString()),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );

                }),
          )
          // ),
        ],
      ),
    );
  }
}
