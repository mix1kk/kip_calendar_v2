import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

import 'StatesAndVariables.dart';
import 'Database.dart';
import 'Styles.dart';



class AlertDialogs {
  static Future selectDate(initDate, context) async {
    DateTime date = DateTime(2022);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(1920),
      lastDate: DateTime.now().add(const Duration(days: 1095)),
    );
    if (picked != null) {
      date = picked;
    } else {
      date = initDate;
    }
    return date;
  }

  static deleteAlertDialogUserScreen(BuildContext context, index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Удалить пользователя?'),
                // content: Text(),
                actions: [
                  TextButton(
                    child: const Text("Отмена"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Удалить"),
                    onPressed: () {
                      Users.deleteUser(Variables.currentUser.name);
                      Navigator.pushNamed(context, '/users');
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  static saveAlertDialogUserScreen(BuildContext context, index) {
    bool isVisible = false;
    String password = '';
    String alertDialogTitle = 'Введите пароль';
    final TextEditingController passwordController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(alertDialogTitle),
                content: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      padding: const EdgeInsets.only(top: 10.0),
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: isVisible
                          ? const Icon(Icons.remove_red_eye_outlined)
                          : const Icon(Icons.remove_red_eye),
                    ),
                    labelText: 'Пароль',
                  ),
                  obscureText: !isVisible,
                  obscuringCharacter: '*',
                ),
                actions: [
                  TextButton(
                    child: const Text("Отмена"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Выбрать"),
                    onPressed: () {
                      if (passwordController.text ==
                          Variables.currentUser.password) {
                        Variables.selectedUser = Variables.currentUser;
                        States.isNamePressed[index] =
                            !States.isNamePressed[index];
                        //сделано для обновления экрана
                        Variables.currentUser.isExpanded =
                            !Variables.currentUser.isExpanded;
                        Users.addUser(Variables.currentUser);
                        //сделано для обновления экрана
                        Navigator.of(context).pop();
                      } else {
                        alertDialogTitle = 'Неверный пароль!';
                        passwordController.text = '';
                        setState(() {});
                      }
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  static selectAlertDialogUserScreen(BuildContext context, index) {
    bool isVisible = false;
    //  String password = '';
    String alertDialogTitle = 'Введите пароль';
    final TextEditingController passwordController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(alertDialogTitle),
                content: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      padding: const EdgeInsets.only(top: 10.0),
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: isVisible
                          ? const Icon(Icons.remove_red_eye_outlined)
                          : const Icon(Icons.remove_red_eye),
                    ),
                    labelText: 'Пароль',
                  ),
                  obscureText: !isVisible,
                  obscuringCharacter: '*',
                ),
                actions: [
                  TextButton(
                    child: const Text("Отмена"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Выбрать"),
                    onPressed: () async {
                      if (passwordController.text ==
                          Variables.currentUser.password) {
                        Variables.setPrefs(Variables.currentUser.name);
                        Variables.selectedUser = Variables.currentUser;
                        States.isNamePressed[index] =
                            !States.isNamePressed[index];
                        //сделано для обновления экрана
                        Variables.currentUser.isExpanded =
                            !Variables.currentUser.isExpanded;
                        Users.addUser(Variables.currentUser);
                        Variables.currentSchedule = await Schedules.getSchedule(
                            Variables.selectedUser.scheduleName);
                        //сделано для обновления экрана
                        Navigator.of(context).pop();
                      } else {
                        alertDialogTitle = 'Неверный пароль!';
                        passwordController.text = '';
                        setState(() {});
                      }
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  static deleteAlertDialogSchedulesScreen(BuildContext context, index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title:
                    Text('Удалить график ${Variables.currentSchedule.name}?'),
                // content: Text(),
                actions: [
                  TextButton(
                    child: const Text("Отмена"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Удалить"),
                    onPressed: () async {
                      States.isSchedulePressed = List.filled(100, false);
                      await Schedules.deleteSchedule(
                          Variables.currentSchedule.name);
                      Variables.currentSchedule.name = '0';
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/schedules', (route) => false);
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  static Future addEventAlertDialog(context) async {
    final TextEditingController eventsUserNameController = TextEditingController();
    List<String> users = [];
    List<String> selectedUsers = [];
    bool userNameTapped = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Добавить новое событие?'),
                content: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Введите имя пользователя/ей',
                      ),
                      readOnly: true,
                      controller: eventsUserNameController,
                      onTap: () async {
                        users = await Users.getAllUsersNames();
                        userNameTapped = !userNameTapped;
                        setState(() {});
                      },
                    ),
                    SizedBox(
                      height: userNameTapped ? Variables.rowHeight * 10 : 0.0,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Row(
                                children: [
                                  SizedBox(
                                    width: Variables.firstColumnWidth / 2,
                                    child: ElevatedButton(
                                      style: ButtonStyles.headerButtonStyle,
                                      onPressed: () {},
                                      child: Text('${index + 1}'),
                                    ),
                                  ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width/2,
                                child: ElevatedButton(
                                    style:
                                        (selectedUsers.contains(users[index]))//цвет зависит от того, добавлен ли юзер в список
                                            ? ButtonStyles.headerButtonStyle
                                            : ButtonStyles.usersListButtonStyle,
                                    onPressed: () {
                                      if (selectedUsers//при нажатии закрашивает и добавляет в список, при повторном удаляет
                                          .contains(users[index])) {
                                        selectedUsers.remove(users[index]);
                                        eventsUserNameController.text = selectedUsers.toString();
                                      } else {
                                        selectedUsers.add(users[index]);
                                        eventsUserNameController.text = selectedUsers.toString();
                                      }
                                      setState(() {});
                                    },
                                    child: Text(users[index],
                                        style: const TextStyle(fontSize: 10.0)),
                                  ),
                              ),
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text("Отмена"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Добавить"),
                    onPressed: () async {
                      for (int i = 0; i < selectedUsers.length; i++) {
                        await Events.addEvent(selectedUsers[i], Variables.currentEvent);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            },
          );
        });
  }
}
