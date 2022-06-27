import 'package:flutter/material.dart';
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
 //   String password = '';
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
                        Variables.setSelectedUserNamePrefs(Variables.currentUser.name);
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
                Text('Удалить график ${Variables.selectedSchedule.name}?'),
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
                     // States.isSchedulePressed = List.filled(100, false);
                      await Schedules.deleteSchedule(
                          Variables.selectedSchedule.name);
                      Variables.selectedSchedule.name = '';
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

  static deleteEventsScreen(BuildContext context, userName, id) {
    //всплывающий диалог при удалении события
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title:
                Text('Удалить событие ${Variables.currentEvent.event}?'),
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
                      await Events.deleteEvent(id);
                      States.eventPressed = '';
                      Variables.allEvents.clear();
                      Variables.allEvents=await Events.getAllEventsForUser(Variables.selectedUsers);
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/events', (route) => false);
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  static Future addEventAlertDialog(context) async {
    final TextEditingController startDateEventController = TextEditingController();
    final TextEditingController endDateEventController = TextEditingController();
    final TextEditingController dateOfNotificationEventController = TextEditingController();
    final TextEditingController eventsUserNameController = TextEditingController();
    startDateEventController.text =
        DateFormat.yMd().format(Variables.currentEvent.startDate);
    dateOfNotificationEventController.text = DateFormat.yMd()
        .format(Variables.currentEvent.dateOfNotification);
    endDateEventController.text = DateFormat.yMd()
        .format(Variables.currentEvent.endDate);

    eventsUserNameController.text = Variables.selectedUser.name;
    List<String> users = [];
    List<String> selectedUsers = [Variables.selectedUser.name];
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
                        labelText: 'Выберите имя пользователя/ей',
                      ),
                      readOnly: true,
                      controller: eventsUserNameController,
                      onTap: () async {
                        users = await Users.getAllUsersNames();
                        Variables.currentEvent.userName = selectedUsers;
                        userNameTapped = !userNameTapped;
                        setState(() {});
                      },
                    ),
                    SizedBox( //выбор пользователей для создания события
                      height: userNameTapped ? MediaQuery
                          .of(context)
                          .size
                          .height/2 : 0.0,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
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
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 2,
                                    child: ElevatedButton(
                                      style:
                                      (selectedUsers.contains(
                                          users[index])) //цвет зависит от того, добавлен ли юзер в список
                                          ? ButtonStyles.headerButtonStyle
                                          : ButtonStyles.usersListButtonStyle,
                                      onPressed: () {
                                        if (selectedUsers //при нажатии закрашивает и добавляет в список, при повторном удаляет
                                            .contains(users[index])) {
                                          selectedUsers.remove(users[index]);
                                          eventsUserNameController.text =
                                              selectedUsers.toString();
                                        } else {
                                          selectedUsers.add(users[index]);
                                          eventsUserNameController.text =
                                              selectedUsers.toString();
                                        }
                                        setState(() {});
                                      },
                                      child: Text(users[index],
                                          style: const TextStyle(
                                              fontSize: 10.0)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    SizedBox( //Кнопки в выборе пользователей для события
                      height: userNameTapped ? Variables.rowHeight : 0.0,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                              style: ButtonStyles.headerButtonStyle,
                              onPressed: () {
                                if (selectedUsers.length==users.length) {
                                  selectedUsers.clear();
                                }
                                else {
                                  selectedUsers.clear();
                                  selectedUsers.addAll(users);
                                }
                                setState(() {});
                              },
                              icon: const Icon(Icons.group_add),
                              label: const Text('Выбрать всех   ')),
                          ElevatedButton.icon(
                              style: ButtonStyles.headerButtonStyle,
                              onPressed: () {
                                eventsUserNameController.text =
                                    selectedUsers.toString();
                                userNameTapped = !userNameTapped;
                                Variables.currentEvent.userName = selectedUsers;
                                setState(() {});
                              },
                              icon: const Icon(Icons.done),
                              label: const Text('Ок   ')),
                        ],
                      ),
                    ),
                    Container( //Данные события
                      height: userNameTapped ? 0.0 : Variables.rowHeight * 9,
                      padding: const EdgeInsets.all(2.0),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Column(
                        children: [
                          TextFormField(
                            readOnly: Variables.selectedUser.role != 'admin',
                            decoration: const InputDecoration(
                              labelText: 'Название события',
                            ),
                            initialValue: Variables.currentEvent.event,
                            onChanged: (value) {
                              Variables.currentEvent.event = value;
                            },
                          ),
                          TextFormField(
                            controller: startDateEventController,
                            readOnly: true,
                            onTap: () async {
                              if (Variables.selectedUser.role == 'admin') {
                                Variables.currentEvent.startDate =
                                await AlertDialogs.selectDate(
                                    Variables.currentEvent.startDate, context);
                                startDateEventController.text =
                                    DateFormat.yMd().format(
                                        Variables.currentEvent.startDate);
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: 'Дата начала события',
                            ),
                          ),
                          TextFormField(
                            controller: endDateEventController,
                            readOnly: true,
                            onTap: () async {
                              if (Variables.selectedUser.role == 'admin') {
                                Variables.currentEvent.endDate =
                                await AlertDialogs.selectDate(
                                    Variables.currentEvent.endDate, context);
                                endDateEventController.text = DateFormat.yMd()
                                    .format(Variables.currentEvent.endDate);
                                //    FocusManager.instance.primaryFocus?.unfocus();
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: 'Дата окончания события',
                            ),
                          ),

                          TextFormField(
                            controller: dateOfNotificationEventController,
                            readOnly: true,
                            onTap: () async {
                              if (Variables.selectedUser.role == 'admin') {
                                Variables.currentEvent.dateOfNotification =
                                await AlertDialogs.selectDate(
                                    Variables.currentEvent.dateOfNotification,
                                    context);
                                dateOfNotificationEventController.text =
                                    DateFormat.yMd()
                                        .format(Variables.currentEvent
                                        .dateOfNotification);
                                //    FocusManager.instance.primaryFocus?.unfocus();
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: 'Дата напоминания',
                            ),
                          ),
                          TextFormField(
                            readOnly: Variables.selectedUser.role != 'admin',
                            decoration: const InputDecoration(
                              labelText: 'Тип события',
                            ),
                            initialValue: Variables.currentEvent.typeOfEvent,
                            onChanged: (value) {
                              Variables.currentEvent.typeOfEvent = value;
                            },
                          ),
                          TextFormField(
                            readOnly: Variables.selectedUser.role != 'admin',
                            decoration: const InputDecoration(
                              labelText: 'Комментарий',
                            ),
                            initialValue: Variables.currentEvent.comment,
                            onChanged: (value) {
                              Variables.currentEvent.comment = value;
                            },
                          ),
                          //todo: сделать флаг "задание выполнено"
                        ],
                      ),
                    ),
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

                      if(!userNameTapped) {
                        await Events.addEvent(
                           Variables.currentEvent);
                        Variables.allEvents.clear();
                        Variables.allEvents=await Events.getAllEventsForUser(Variables.selectedUsers);
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

  static Future selectUsersAlertDialog(context,link) async {

    List<String> users = await Users.getAllUsersNames();
    List<String> selectedUsers = [Variables.selectedUser.name];
 //   bool userNameTapped = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Выберите пользователей'),
                content:
                    Column(
                      children: [
                    SizedBox( //выбор пользователей для создания события
                      height: MediaQuery
                          .of(context)
                          .size
                          .height/2 ,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
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
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 2,
                                    child: ElevatedButton(
                                      style:
                                      (selectedUsers.contains(
                                          users[index])) //цвет зависит от того, добавлен ли юзер в список
                                          ? ButtonStyles.headerButtonStyle
                                          : ButtonStyles.usersListButtonStyle,
                                      onPressed: () {
                                        if (selectedUsers //при нажатии закрашивает и добавляет в список, при повторном удаляет
                                            .contains(users[index])) {
                                          selectedUsers.remove(users[index]);
                                        } else {
                                          selectedUsers.add(users[index]);
                                        }
                                        setState(() {});
                                      },
                                      child: Text(users[index],
                                          style: const TextStyle(
                                              fontSize: 10.0)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    SizedBox( //Кнопки в выборе пользователей для события
                      height:  Variables.rowHeight,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child:
                          ElevatedButton.icon(
                              style: ButtonStyles.headerButtonStyle,
                              onPressed: () {
                                if (selectedUsers.length==users.length) {
                                  selectedUsers.clear();
                                }
                                else {
                                  selectedUsers.clear();
                                  selectedUsers.addAll(users);
                                }
                                setState(() {});
                              },
                              icon: const Icon(Icons.group_add),
                              label: const Text('Выбрать всех   ')),
                          // ElevatedButton.icon(
                          //     style: ButtonStyles.headerButtonStyle,
                          //     onPressed: () {
                          //       userNameTapped = !userNameTapped;
                          //       setState(() {});
                          //     },
                          //     icon: const Icon(Icons.done),
                          //     label: const Text('Ок   ')),

                    ),
                      ]),
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
                        if (selectedUsers.isNotEmpty) {
                          Variables.selectedUsers=selectedUsers;
                          Variables.allEvents = await Events.getAllEventsForUser(Variables.selectedUsers);
                          Navigator.of(context).pop();
                        }
                        else {
                          Variables.selectedUsers =[Variables.selectedUser.name];
                          Navigator.of(context).pop();
                        }
                   // await
                        Navigator.pushNamed(
                            context,
                            link);

                    },
                  ),
                ],
              );
            },
          );
        });
  }
}
