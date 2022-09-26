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

  void jumpToDate() {
    //промотка списка на конкретную величину, перенести в календарь
    double shift = (DateTime.now().difference(DateTime(2022)).inDays - 3) *
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
                jumpToDate();
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
                      child: (Variables.selectedUsers.length > 1)?const Text('[  . . .  ]'):Text(Variables.selectedUsers.toString(),
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
        body:
            Column(
              children: [
                SingleChildScrollView(///верхняя шапка
                  scrollDirection: Axis.horizontal,
                  child:
                  Row(children: [
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
                      width: MediaQuery.of(context).size.width -
                          Variables.rowHeight * 3,
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
                              style: ButtonStyles.headerButtonStyle,// базовая раскраска по графику
                              child: Column(
                                children: [
                                  Text(
                                      DateFormat.y().format(DateTime(2022)
                                          .add(Duration(days: index))).toString(),style: const TextStyle(fontSize: 8)),
                                  Text(
                                      DateFormat.MMMM().format(DateTime(2022)
                                          .add(Duration(days: index))).toString(),style: const TextStyle(fontSize: 8)),

                                  Text(
                                      DateFormat.E().format(DateTime(2022)
                                          .add(Duration(days: index))).toString(),style: const TextStyle(fontSize: 8)),
                                ],
                              ),
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
              child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Что-то пошло не так');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView(
                        children:
                            snapshot.data!.docs.map((DocumentSnapshot document) {

                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      List<int> userSchedule = List.filled(56, 26);

                      for (int i = 0; i < Variables.allSchedules.length; i++) {
                        if (Variables.allSchedules[i].name == data['scheduleName']) {//для каждого пользователя свой график
                          userSchedule = Variables.allSchedules[i].schedule;
                        }
                      }
                      List<String> _initials =
                          data['name'].split(' '); //разделяет фио по словам

                      return Row(children: [
                        Container(
                          ///Первый столбец с именами
                          padding: const EdgeInsets.all(2),
                          width: Variables.rowHeight * 3,
                          height: (Variables.selectedUsers.contains(data['name']))?Variables.rowHeight:0.0,
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
                          height: (Variables.selectedUsers.contains(data['name']))?Variables.rowHeight:0.0,
                          child: ListView.builder(
                            key: ObjectKey(data['name']),
                            //ключ нужен для добавления контроллеров скролла в группу
                            primary: false,
                            padding: const EdgeInsets.all(2),
                            controller: _controllers.addAndGet(),
                            //добавление контроллеров скролла в группу для совместного скролла всех строк
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                // одна ячейка с днем
                                padding: const EdgeInsets.all(2),
                                width: Variables.rowHeight,
                                height: Variables.rowHeight,
                                child: ElevatedButton(
                                  style: ButtonStyles.dayStyle(
                                      DateTime(2022).add(Duration(days: index)),
                                      userSchedule,
                                      '/allUsers'),// базовая раскраска по графику
                                  child: Text(
                                      /*data['schedule'][index].toString()*/
                                      DateTime(2022)
                                          .add(Duration(days: index))
                                          .day
                                          .toString()),
                                  onPressed: () {},
                                ),
                              );
                            },
                          ),
                        ),
                      ]);
                    }).toList());
                  }),
            )
        // ),

              ],
            ),
        );
  }
}
