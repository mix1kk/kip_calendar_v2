import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

import 'StatesAndVariables.dart';
import 'firestore.dart';


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
    }
    else {
      date = initDate;
    }
    return date;
  }
  static deleteAlertDialogUserScreen(BuildContext context,index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return
                AlertDialog(
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


  static saveAlertDialogUserScreen(BuildContext context,index) {
    bool isVisible = false;
    String password = '';
    String alertDialogTitle = 'Введите пароль';
    final TextEditingController passwordController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return
                AlertDialog(
                  title: Text(alertDialogTitle),
                  content:
                  TextFormField(
                    controller: passwordController,
                    decoration:  InputDecoration(
                      prefixIcon:
                      IconButton(
                        padding: const EdgeInsets.only(top:10.0),
                        onPressed: () {
                          setState(() {isVisible = !isVisible;});
                        },
                        icon: isVisible?const Icon(Icons.remove_red_eye_outlined):const Icon(Icons.remove_red_eye),
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
                        if (passwordController.text == Variables.currentUser.password) {
                          Variables.selectedUser = Variables.currentUser;
                          States.isNamePressed[index] =
                          !States.isNamePressed[index];
                          //сделано для обновления экрана
                          Variables.currentUser.isExpanded =
                          !Variables.currentUser.isExpanded;
                          Users.addUser(Variables.currentUser);
                          //сделано для обновления экрана
                          Navigator.of(context).pop();
                        }
                        else {
                          alertDialogTitle = 'Неверный пароль!';
                          passwordController.text='';
                          setState((){});
                        }
                      },
                    ),
                  ],
                );
            },
          );
        });
  }

  static selectAlertDialogUserScreen(BuildContext context,index) {
    bool isVisible = false;
    String password = '';
    String alertDialogTitle = 'Введите пароль';
    final TextEditingController passwordController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return
                AlertDialog(
                  title: Text(alertDialogTitle),
                  content:
                  TextFormField(
                    controller: passwordController,
                    decoration:  InputDecoration(
                      prefixIcon:
                        IconButton(
                          padding: const EdgeInsets.only(top:10.0),
                          onPressed: () {
                            setState(() {isVisible = !isVisible;});
                          },
                          icon: isVisible?const Icon(Icons.remove_red_eye_outlined):const Icon(Icons.remove_red_eye),
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
                        if (passwordController.text == Variables.currentUser.password) {
                          Variables.selectedUser = Variables.currentUser;
                          States.isNamePressed[index] =
                          !States.isNamePressed[index];
                          //сделано для обновления экрана
                          Variables.currentUser.isExpanded =
                          !Variables.currentUser.isExpanded;
                          Users.addUser(Variables.currentUser);
                          //сделано для обновления экрана
                          Navigator.of(context).pop();
                        }
                        else {
                          alertDialogTitle = 'Неверный пароль!';
                          passwordController.text='';
                          setState((){});
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
