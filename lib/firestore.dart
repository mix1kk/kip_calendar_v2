import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'StatesAndVariables.dart';



// class AddUser extends StatelessWidget {
//   final String fullName;
//   final String company;
//   final int age;
//
//   AddUser(this.fullName, this.company, this.age);
//
//   @override
//   Widget build(BuildContext context) {
//     // Create a CollectionReference called users that references the firestore collection
//     CollectionReference users = FirebaseFirestore.instance.collection('users');
//
//     Future<void> addUser() {
//       // Call the user's CollectionReference to add a new user
//       return users
//           .add({
//         'full_name': fullName, // John Doe
//         'company': company, // Stokes and Sons
//         'age': age // 42
//       })
//           .then((value) => print("User Added"))
//           .catchError((error) => print("Failed to add user: $error"));
//     }
//
//     return TextButton(
//       onPressed: addUser,
//       child: Text(
//         "Add User",
//       ),
//     );
//   }
// }


//

//
// class Schedule {
//   final int number;
//   final String name;
//   final List<int> schedule;
//   List<String> allEvents = [];
//
//   Schedule(this.number, this.name, this.schedule);
//
//   static addSchedule(String scheduleName, List<int> scheduleList) async {
//     await FirebaseFirestore.instance
//         .collection('schedules')
//         .doc(scheduleName)
//         .get()
//         .then((DocumentSnapshot documentSnapshot) {
//       FirebaseFirestore.instance.collection('schedules').doc(scheduleName).set({
//         'name': scheduleName,
//         'schedule': scheduleList,
//       });
//     });
//     // );
//   }
//
//   static getSchedule(String scheduleName) async {
//     //чтение из базы данных
//     List schedule = [];
//     await FirebaseFirestore.instance
//         .collection('schedules')
//         .doc(scheduleName)
//         .get()
//         .then((DocumentSnapshot documentSnapshot) {
//       schedule = documentSnapshot.get('schedule');
//     });
//     return schedule.map((s) => s as int).toList();
//   }
//
//   static deleteSchedule(String scheduleName) async {
//     //чтение из базы данных
//     await FirebaseFirestore.instance
//         .collection('schedules')
//         .doc(scheduleName)
//         .delete();
//     allSchedulesList = await Schedule.getAllSchedulesNames();
//     scheduleName = '0';
//     // _selectedSchedule=scheduleName;
//   }
//
//   static getScheduleName(int scheduleNumber) async {
//     //чтение из базы данных
//     String scheduleName = '';
//     await FirebaseFirestore.instance
//         .collection('schedules')
//         .doc('$scheduleNumber')
//         .get()
//         .then((DocumentSnapshot documentSnapshot) {
//       scheduleName = documentSnapshot.get('name').toString();
//     });
//     return scheduleName;
//   }
//
//   static getAllSchedulesNames() async {
//     //чтение из базы данных
//     List<String> scheduleName = [];
//     await FirebaseFirestore.instance
//         .collection('schedules')
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((doc) {
//         scheduleName.add(doc.get('name'));
//       });
//     });
//     return scheduleName;
//   }
//
//   static getWorkingDay(DateTime currentDay) {
//     List<int> schedule = scheduleList;
//     Duration difference = currentDay.difference(initialDate);
//     return schedule[difference.inDays %
//         56]; // 26 - выходной, 1 - рабочий в день, 2 - рабочий в ночь
//   }
// }


// final String name = 'user';
// final String password = '';
// final String tableNumber = '001';
// final String position = 'position';
// final DateTime dateOfBirth = DateTime(2022);
// final DateTime dateOfEmployment = DateTime(2022);
// final String scheduleName = '0';
// final String phoneNumber = '8 987 654 32 10';
// final String role = 'user';
// final bool isExpanded = false;
// Users initialUser = Users(
//     'user',
//     '0',
//     '001',
//     'position',
//     DateTime(2022),
//     DateTime(2022),
//     '0',
//     'КИПиА',
//     '8 987 654 32 10',
//     'user',
//     false);

class Users {
   String name;
   String password;
   String tableNumber;
   String position;
   DateTime dateOfBirth;
   DateTime dateOfEmployment;
   String scheduleName;
   String unit;
   String phoneNumber;
   String role;
   bool isExpanded;

  Users(this.name,
      this.password,
      this.tableNumber,
      this.position,
      this.dateOfBirth,
      this.dateOfEmployment,
      this.scheduleName,
      this.unit,
      this.phoneNumber,
      this.role,
      this.isExpanded);



  static addUser(
      Users user
      )
  async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.name)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      FirebaseFirestore.instance.collection('users').doc(user.name).set({
        'name': user.name,
        'password': user.password,
        'tableNumber': user.tableNumber,
        'position': user.position,
        'dateOfBirth': user.dateOfBirth,
        'dateOfEmployment': user.dateOfEmployment,
        'scheduleName': user.scheduleName,
        'unit': user.unit,
        'phoneNumber': user.phoneNumber,
        'role': user.role,
        'isExpanded': user.isExpanded
      });
    });
    // );
  }

  static Future getUserByName(String Name) async {
    Users user=Variables.currentUser;
    //чтение из базы данных
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Name)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
       user=Users(
      documentSnapshot.get('name'),
      documentSnapshot.get('password'),
      documentSnapshot.get('tableNumber'),
      documentSnapshot.get('position'),
      documentSnapshot.get('dateOfBirth').toDate(),
      documentSnapshot.get('dateOfEmployment').toDate(),
      documentSnapshot.get('scheduleName'),
        documentSnapshot.get('unit'),
        documentSnapshot.get('phoneNumber'),
        documentSnapshot.get('role'),
        documentSnapshot.get('isExpanded')
      );
    });
      return user;
  }

  // static getAllUsersNames() async {
  //   //чтение из базы данных
  //   List<String> userNames = [];
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       userNames.add(doc.get('name'));
  //     });
  //   });
  //   return userNames;
  // }

  static deleteUser(String userName) async {
    //чтение из базы данных
    await FirebaseFirestore.instance.collection('users').doc(userName).delete();
    // _selectedSchedule=scheduleName;
  }
}

// class Events {
//   static String event = '';
//   static DateTime startDate = DateTime.now();
//   static DateTime endDate = DateTime.now();
//   static DateTime dateOfNotification = DateTime.now();
//   static String typeOfEvent = '';
//   static String comment = '';
//   static bool isDone = false;
//
//   static Future addEvent(
//       String name,
//       String event,
//       DateTime startDate,
//       DateTime endDate,
//       DateTime dateOfNotification,
//       String typeOfEvent,
//       String comment,
//       bool isDone,
//       ) async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(name)
//         .collection('events')
//         .doc()
//         .get()
//         .then((DocumentSnapshot documentSnapshot) {
//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(name)
//           .collection('events')
//           .doc()
//           .set({
//         'event': event,
//         'startDate': startDate,
//         'endDate': endDate,
//         'dateOfNotification': dateOfNotification,
//         'typeOfEvent': typeOfEvent,
//         'comment': comment,
//         'isDone': isDone,
//       });
//     });
//     //await getAllEvents([name]);
//   }
//
//   static Future getEvent(String name, String eventId) async {
//     //чтение из базы данных
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(name)
//         .collection('events')
//         .doc(eventId)
//         .get()
//         .then((DocumentSnapshot documentSnapshot) {
//       event = documentSnapshot.get('event');
//       startDate = documentSnapshot.get('startDate').toDate();
//       endDate = documentSnapshot.get('endDate').toDate();
//       dateOfNotification = documentSnapshot.get('dateOfNotification').toDate();
//       typeOfEvent = documentSnapshot.get('typeOfEvent');
//       comment = documentSnapshot.get('comment');
//       isDone = documentSnapshot.get('isDone');
//       eventComment_controller.text = Events.comment;
//       event_controller.text=Events.event;
//     });
//
//     return name;
//   }
//
//   static Future getAllEventsToDate(DateTime date, List<String> names) async {
//     //чтение из базы данных
//     Map<String, String> allEventsToDate = {};
//     for (int i = 0; i < names.length; i++) {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(names[i])
//           .collection('events')
//           .get()
//           .then((QuerySnapshot querySnapshot) {
//         querySnapshot.docs.forEach((doc) {
//           if ((date.compareTo(doc.get('startDate').toDate()) >= 0) &&
//               (date.compareTo(doc.get('endDate').toDate()) <= 0)) {
//             //проверка входит ли кликнутая дата в диапазон дат события
//             allEventsToDate.putIfAbsent(doc.id, () => doc.get('event'));
//           }
//         });
//       });
//     }
//     return allEventsToDate;
//     // return name;
//   }
//
//   static Future getAllEvents(List<String> names) async {
//     //чтение из базы данных
//     allEventsStartDates.clear();
//     allEventsEndDates.clear();
//     for (int i = 0; i < names.length; i++) {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(names[i])
//           .collection('events')
//           .get()
//           .then((QuerySnapshot querySnapshot) {
//         querySnapshot.docs.forEach((doc) {
//           allEvents.add(doc.get('event'));
//           allEventsStartDates.add(doc.get('startDate').toDate());
//           allEventsEndDates.add(doc.get('endDate').toDate());
//         });
//       });
//     }
//   }
//
//   static Future deleteEvent(String userName, String id) async {
//     //удаление события из базы данных
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userName)
//         .collection('events')
//         .doc(id)
//         .delete();
//     await getAllEvents([userName]);
//
//   }
// }
