import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/Widgets.dart';
import 'package:kip_calendar_v2/StatesAndVariables.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

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
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.update),
              onPressed: () {
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
                child:
                    Text('Все пользователи', style: TextStyle(fontSize: 20.0)),
              ),
              Container(
                  // padding: const EdgeInsets.fromLTRB(50.0, 8.0, 0.0, 1.0),
                  height: 20.0,
                  width: MediaQuery.of(context).size.width - 20,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(Variables.selectedUser.name,
                        style: const TextStyle(fontSize: 12.0)),
                  )),
            ],
          ),
          // const Text("Пользователи"),
        ),
        body:

            // Expanded(
            //
            //     child:
            StreamBuilder<QuerySnapshot>(
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
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Row(children: [
                      Container(///Первый столбец с именами
                        padding: const EdgeInsets.all(2),
                        width: Variables.rowHeight*5,
                        height: Variables.rowHeight,
                        child: ElevatedButton(
                          style: ButtonStyles.usersListButtonStyle,
                          child: Text(data['name']),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(///остальная часть с днями
                        width: MediaQuery.of(context).size.width - Variables.rowHeight*5,
                        height: Variables.rowHeight,
                        child: ListView.builder(
                          key: ObjectKey(data['name']),
                          //ключ нужен для добавления контроллеров скролла в группу
                          primary: false,
                          padding: const EdgeInsets.all(2),
                          controller: _controllers.addAndGet(),
                          //добавление контроллеров скролла в группу для совместного скролла всех строк
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(// одна ячейка с днем
                              padding: const EdgeInsets.all(2),
                                width: Variables.rowHeight,
                                height: Variables.rowHeight,
                                child: ElevatedButton(
                              style: ButtonStyles.simpleDayButtonStyle,
                              child: Text(
                                  /*data['schedule'][index].toString()*/
                                  DateTime(2022)
                                      .add(Duration(days: index))
                                      .day
                                      .toString()),
                              onPressed: () {},
                            ),);
                          },
                        ),
                      ),
                    ]);
                  }).toList());
                })
        // ),
        );
  }
}
