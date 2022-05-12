import 'dart:async';

import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'StatesAndVariables.dart';


class Schedules {
  String name;
  List<int> schedule;
  bool isExpanded;

  Schedules(this.name, this.schedule, this.isExpanded);

  static addSchedule(String scheduleName, List<int> scheduleList,
      bool isExpanded) async {
    await FirebaseFirestore.instance
        .collection('schedules')
        .doc(scheduleName)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      FirebaseFirestore.instance.collection('schedules').doc(scheduleName).set({
        'name': scheduleName,
        'schedule': scheduleList,
        'isExpanded': isExpanded,
      });
    });
    // );
  }

  static getSchedule(String scheduleName) async {
    //чтение из базы данных
    Schedules schedule = Variables.currentSchedule;
    await FirebaseFirestore.instance
        .collection('schedules')
        .doc(scheduleName)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      //List <dynamic> list = documentSnapshot.get('schedule');
      schedule = Schedules(
          documentSnapshot.get('name'),
          //list.cast<int>(),
          documentSnapshot.get('schedule').cast<int>(),
          documentSnapshot.get('isExpanded')
      );
    });
    return schedule;
  }

  static deleteSchedule(String scheduleName) async {
    //чтение из базы данных
    await FirebaseFirestore.instance
        .collection('schedules')
        .doc(scheduleName)
        .delete();
  }

  // static getScheduleName(int scheduleNumber) async {
  //   //чтение из базы данных
  //   String scheduleName = '';
  //   await FirebaseFirestore.instance
  //       .collection('schedules')
  //       .doc('$scheduleNumber')
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     scheduleName = documentSnapshot.get('name').toString();
  //   });
  //   return scheduleName;
  // }
  //
  // static getAllSchedulesNames() async {
  //   //чтение из базы данных
  //   List<String> scheduleName = [];
  //   await FirebaseFirestore.instance
  //       .collection('schedules')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       scheduleName.add(doc.get('name'));
  //     });
  //   });
  //   return scheduleName;
  // }

  static getWorkingDay(DateTime currentDay, List<int> schedule) {
    Duration difference = currentDay.difference(
        DateTime(2022).subtract(const Duration(days: 5)));
    return schedule[difference.inDays %
        56]; // 26 - выходной, 1 - рабочий в день, 2 - рабочий в ночь
  }
}


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


  static addUser(Users user) async {
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
    Users user = Variables.currentUser;
    //чтение из базы данных
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Name)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      user = Users(
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

  static Future getAllUsersNames() async {
    //чтение из базы данных
    List<String> userNames = [];
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        userNames.add(doc.get('name'));
      });
    });
    return userNames;
  }

  static deleteUser(String userName) async {
    //чтение из базы данных
    await FirebaseFirestore.instance.collection('users').doc(userName).delete();
    // _selectedSchedule=scheduleName;
  }
}

class Events {
  String userName;
  String event;
  DateTime startDate;
  DateTime endDate;
  DateTime dateOfNotification;
  String typeOfEvent;
  String comment;
  bool isDone;
  bool isVisible;
  bool isExpanded;

  Events(
      this.userName,
      this.event,
      this.startDate,
      this.endDate,
      this.dateOfNotification,
      this.typeOfEvent,
      this.comment,
      this.isDone,
      this.isVisible,
      this.isExpanded);

 //
 // static  Stream<QuerySnapshot> getUsers() {
 //    return FirebaseFirestore.instance.collection('users').snapshots();
 //  }
 // static Stream<QuerySnapshot> getEvents(username) {
 //    return FirebaseFirestore.instance.collection('users').doc(username).collection('events').snapshots();
 //  }



    static Future addEvent(
      List<String> userNames,
      Events newEvent
      ) async {
      for (int i = 0; i < userNames.length; i++) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userNames[i])
              .collection('events')
              .doc()
              .set({
            'userName':userNames[i],
            //'userName': newEvent.userName,
            'event': newEvent.event,
            'startDate': newEvent.startDate,
            'endDate': newEvent.endDate,
            'dateOfNotification': newEvent.dateOfNotification,
            'typeOfEvent': newEvent.typeOfEvent,
            'comment': newEvent.comment,
            'isDone': newEvent.isDone,
            'isVisible': newEvent.isVisible,
            'isExpanded' : newEvent.isExpanded
          });
      }
  }
  static Future updateEvent(
      userName,
      Events newEvent,id
      ) async {

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userName)
          .collection('events')
          .doc(id)
          .update({
        'userName':userName,
        'event': newEvent.event,
        'startDate': newEvent.startDate,
        'endDate': newEvent.endDate,
        'dateOfNotification': newEvent.dateOfNotification,
        'typeOfEvent': newEvent.typeOfEvent,
        'comment': newEvent.comment,
        'isDone': newEvent.isDone,
        'isVisible': newEvent.isVisible,
        'isExpanded' : newEvent.isExpanded
      });

  }



 //
 // static  Stream <QuerySnapshot> eventsStream() async* {
 //   List<String> userList = await Users.getAllUsersNames();
 //        for (var i = 0 ; i< userList.length; i++) {
 //           QuerySnapshot querySnapshot = await FirebaseFirestore.instance
 //          .collectionGroup('events')
 //          .get();
 //            yield querySnapshot;
 //         }
 //  }
static  Events getEventFromSnapshot(DocumentSnapshot document)  {
    //чтение из базы данных
  Events event = Events(
  document.get('userName'),
  document.get('event'),
  document.get('startDate').toDate(),
  document.get('endDate').toDate(),
  document.get('dateOfNotification').toDate(),
  document.get('typeOfEvent'),
  document.get('comment'),
  document.get('isDone'),
  document.get('isVisible'),
  document.get('isExpanded'));
    return event;
  }

  // static Future getEvent(String userName, String eventId) async {
  //   //чтение из базы данных
  //   Events event=Variables.initialEvent;
  //        await FirebaseFirestore.instance
  //       // .collection('users')
  //       // .doc(userName)
  //       // .collection('events')
  //       // .doc(eventId)
  //       .collectionGroup('events').
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     event.event = documentSnapshot.get('event');
  //     event.startDate = documentSnapshot.get('startDate').toDate();
  //     event.endDate = documentSnapshot.get('endDate').toDate();
  //     event.dateOfNotification = documentSnapshot.get('dateOfNotification').toDate();
  //     event.typeOfEvent = documentSnapshot.get('typeOfEvent');
  //     event.comment = documentSnapshot.get('comment');
  //     event.isDone = documentSnapshot.get('isDone');
  //   });
  //   return event;
  // }
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
  static Future deleteEvent(String userName, String id) async {
    //удаление события из базы данных
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userName)
        .collection('events')
        .doc(id)
        .delete();

  }
  static Future deleteAllEvents() async {
    List<String> userList =  await Users.getAllUsersNames();
    //удаление события из базы данных
    for (int i = 0; i < userList.length; i++) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userList[i])
          .collection('events')
          .get()
         .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
           FirebaseFirestore.instance
              .collection('users')
              .doc(userList[i])
              .collection('events')
               .doc(doc.id)
               .delete();
        });

        });
         }


  }
}
