import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/AlertDialogs.dart';
import 'package:kip_calendar_v2/StatesAndVariables.dart';
import 'package:kip_calendar_v2/Database.dart';
import 'package:kip_calendar_v2/Styles.dart';
import 'package:intl/intl.dart';

final TextEditingController dateOfBirthController = TextEditingController();
final TextEditingController dateOfEmploymentController = TextEditingController();
final TextEditingController scheduleNameController = TextEditingController();


class UsersWidgets {


  // static getNumberOfWeek(DateTime day) {
  //   //возвращает номер недели введенного дня
  //   final startOfYear = DateTime(day.year);
  //   final firstMonday = startOfYear.weekday;
  //   final daysInFirstWeek = 8 - firstMonday;
  //   final diff = day.difference(startOfYear);
  //   var weeks = ((diff.inDays - daysInFirstWeek) / 7).ceil();
  //   if (daysInFirstWeek < 3) {
  //     weeks = weeks + 1;
  //   }
  //   return weeks;
  // }

  // static List<DateTime> getWeekDays(DateTime day) {
  //   //рассчет и выдача массива дат на текущую неделю
  //   DateTime firstDayOfWeek = day.subtract(Duration(days: day.weekday - 1));
  //   List<DateTime> week =
  //   List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));
  //   return week;
  // }


  static Widget usersScreen( context) {



    final Stream<QuerySnapshot> _usersStream =
    FirebaseFirestore.instance.collection('users').snapshots();
    //основная таблица  на экране UsersScreen
    return Expanded(
      // child: RefreshIndicator(
      //   onRefresh: pullRefresh,
      child: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            int number = 0;
            if (snapshot.hasError) {
              return const Text('Что-то пошло не так');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
              //const Text("Loading");
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                number++;
                Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
                return Column(children: [
                  SizedBox(
                    height: Variables.rowHeight * 2,
                    child: usersMainScreenName(context, number, data),
                    //заголовок пользователя в списке пользователей
                  ),
                  SizedBox(
                    height: States.isNamePressed[number]
                        ? Variables.rowHeight * 17
                        : 0.0,
                    child: usersMainScreenData(context, number, data),
                    //данные пользователя в списке пользователей
                  ),
                ]);
              }).toList(),
            );
          }),
    );
  }

  static Widget usersMainScreenName(context, int index, data) {
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
              style: (Variables.selectedUser.name == data['name'])
                  ? ButtonStyles.headerButtonStyle
                  : ButtonStyles.usersListButtonStyle,
              onPressed: () {
                Variables.currentUser = Users(
                  data['name'],
                  data['password'],
                  data['tableNumber'],
                  data['position'],
                  data['dateOfBirth'].toDate(),
                  data['dateOfEmployment'].toDate(),
                  data['scheduleName'],
                  data['unit'],
                  data['phoneNumber'],
                  data['role'],
                  data['schedule'].cast<int>(),
                  !data['isExpanded'],
                );
                dateOfBirthController.text =
                    DateFormat.yMd().format(Variables.currentUser.dateOfBirth);
                dateOfEmploymentController.text = DateFormat.yMd()
                    .format(Variables.currentUser.dateOfEmployment);
                scheduleNameController.text = data['scheduleName'];

                if (States.isNamePressed[index]) {
                  States.isNamePressed = List.filled(250, false);
                } else {
                  States.isNamePressed = List.filled(250, false);
                  States.isNamePressed[index] = !States.isNamePressed[index];
                }
                Users.addUser(//сделано для обновления экрана
                    Variables.currentUser);
              },
              child: ListTile(
                title: Text(data['name']),
                subtitle: Text(data['position']),
              ),
            )),
      ],
    );
  }

  static Widget usersMainScreenData(context, index, Map<String, dynamic> data) {
    //полные данные пользователей
    return Container(
      padding: const EdgeInsets.all(2.0),
      // height: States.isNamePressed[number] ? rowHeight * 15 : 0.0,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'ФИО',
            ),
            readOnly: Variables.selectedUser.role != 'admin',
            initialValue: data['name'],
            onChanged: (value) {
              Variables.currentUser.name = value;
            },
          ),
          TextFormField(
            readOnly: Variables.selectedUser.role != 'admin',
            decoration: const InputDecoration(
              labelText: 'Пароль',
            ),
            obscureText: Variables.selectedUser.role != 'admin',
            obscuringCharacter: '*',
            initialValue: data['password'],
            onChanged: (value) {
              Variables.currentUser.password = value;
            },
          ),
          TextFormField(
            readOnly: Variables.selectedUser.role != 'admin',
            decoration: const InputDecoration(
              labelText: 'Табельный номер',
            ),
            initialValue: data['tableNumber'],
            onChanged: (value) {
              Variables.currentUser.tableNumber = value;
            },
          ),
          TextFormField(
            readOnly: Variables.selectedUser.role != 'admin',
            decoration: const InputDecoration(
              labelText: 'Должность',
            ),
            initialValue: data['position'],
            onChanged: (value) {
              Variables.currentUser.position = value;
            },
          ),
          TextFormField(
            controller: dateOfBirthController,
            readOnly: true,
            //Variables.selectedUser.role != 'admin',
            onTap: () async {
              if (Variables.selectedUser.role == 'admin') {
                Variables.currentUser.dateOfBirth =
                await AlertDialogs.selectDate(
                    Variables.currentUser.dateOfBirth, context);
                dateOfBirthController.text =
                    DateFormat.yMd().format(Variables.currentUser.dateOfBirth);
              }
            },
            decoration: const InputDecoration(
              labelText: 'Дата рождения',
            ),
          ),
          TextFormField(
            controller: dateOfEmploymentController,
            readOnly: true,
            onTap: () async {
              if (Variables.selectedUser.role == 'admin') {
                Variables.currentUser.dateOfEmployment =
                await AlertDialogs.selectDate(
                    Variables.currentUser.dateOfEmployment, context);
                dateOfEmploymentController.text = DateFormat.yMd()
                    .format(Variables.currentUser.dateOfEmployment);
              }
            },
            decoration: const InputDecoration(
              labelText: 'Дата трудоустройства',
            ),
          ),
          TextFormField(
            readOnly: true,
            controller: scheduleNameController,
            decoration: const InputDecoration(
              labelText: 'График',
            ),
            onTap: () {
              if (Variables.selectedUser.role == 'admin') {
                Navigator.pushNamed(context, '/schedules');
              }
            },
            // onChanged: (value) {
            //   Variables.currentUser.scheduleName = value;
            // },
          ),
          TextFormField(
            readOnly: Variables.selectedUser.role != 'admin',
            decoration: const InputDecoration(
              labelText: 'Подразделение',
            ),
            initialValue: data['unit'],
            onChanged: (value) {
              Variables.currentUser.unit = value;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            readOnly: !((Variables.selectedUser.role == 'admin') |
            (Variables.selectedUser.name == Variables.currentUser.name)),
            decoration: const InputDecoration(
              labelText: 'Номер телефона',
            ),
            initialValue: data['phoneNumber'],
            onChanged: (value) {
              Variables.currentUser.phoneNumber = value;
            },
          ),
          TextFormField(
            readOnly: Variables.selectedUser.role != 'admin',
            decoration: const InputDecoration(
              labelText: 'Уровень доступа',
            ),
            initialValue: data['role'],
            onChanged: (value) {
              Variables.currentUser.role = value;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () {
                    if (Variables.selectedUser.role == 'admin') {
                      AlertDialogs.deleteAlertDialogUserScreen(context, index);
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Удалить   ')),
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () {
                    if (Variables.selectedUser.role == 'admin') {
                      //если админ, то сохраняем все поля пользователя, если не админ, то только номер телефона
                      Users.addUser(Variables.currentUser);
                    } else {
                      Users.addUser(Users(
                        data['name'],
                        data['password'],
                        data['tableNumber'],
                        data['position'],
                        data['dateOfBirth'].toDate(),
                        data['dateOfEmployment'].toDate(),
                        data['scheduleName'],
                        data['unit'],
                        Variables.currentUser.phoneNumber,
                        data['role'],
                        data['schedule'],
                        !data['isExpanded'],
                      ));
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Сохранить   ')),
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () async {
                    AlertDialogs.selectAlertDialogUserScreen(context, index);
                  },
                  icon: const Icon(Icons.adjust),
                  label: const Text('Выбрать   ')),
            ],
          )
        ],
      ),
    );
  }



}
