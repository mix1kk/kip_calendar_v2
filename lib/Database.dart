import 'dart:async';
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
    Schedules schedule = Variables.currentUserSchedule;
    await FirebaseFirestore.instance
        .collection('schedules')
        .doc(scheduleName)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      schedule = Schedules(
          documentSnapshot.get('name'),
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
  static getAllSchedules() async {//чтение всех графиков работы и выдача их в виде мап (имя:график)
    List <Schedules> schedules = [];
    await FirebaseFirestore.instance
        .collection('schedules')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Schedules schedule = Schedules(
            doc.get('name'),
            doc.get('schedule').cast<int>(),
            doc.get('isExpanded')
        );
        schedules.add(schedule);
      });
    });
    return schedules;
  }

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
  List<int> schedule;
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
      this.schedule,
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
        'schedule': user.schedule,
        'isExpanded': user.isExpanded
      });
    });
    // );
  }

  static Future getUserByName(String name) async {
    Users user = Variables.currentUser;
    //чтение из базы данных
    await FirebaseFirestore.instance
        .collection('users')
        .doc(name)
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
          documentSnapshot.get('schedule').cast<int>(),
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
  static Future getAllUsers() async {
    //чтение из базы данных
    List<Users> users= [];
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        Users user = Users(
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
        documentSnapshot.get('schedule').cast<int>(),
        documentSnapshot.get('isExpanded')
        );
        users.add(user);
      });
    });
    return users;
  }

  static deleteUser(String userName) async {
    //чтение из базы данных
    await FirebaseFirestore.instance.collection('users').doc(userName).delete();
    // _selectedSchedule=scheduleName;
  }
  static addToUserSchedule (int numberForSchedule , Events event)
  async {
    int difference = event.endDate.difference(event.startDate).inDays;
    for (int i = 0; i < event.userName.length; i++)  {
      Users user = await getUserByName(event.userName[i]);

      for (int j =0; j<difference+1; j++) {
        user.schedule[event.startDate.difference(DateTime(2022)).inDays+j] = numberForSchedule;
      }
      await addUser(user);
        }
  }

  static updateAllEventsForUser (Users user)
  async {
    for (int a =0; a<user.schedule.length; a++) {
      user.schedule[a]=26;
    }

    List <Events> allEventsForUser = await Events.getAllEventsForUser([user.name]);
      for (int i =0; i<allEventsForUser.length; i++) {
        int difference = allEventsForUser[i].endDate.difference(allEventsForUser[i].startDate).inDays;
        for (int j =0; j<difference+1; j++) {
          user.schedule[allEventsForUser[i].startDate.difference(DateTime(2022)).inDays+j] = await Events.checkForTypeOfEvent(allEventsForUser[i]);
        }

      }
      await addUser(user);

  }
}



class Events {
  List<String> userName;
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

// static checkForTypeOfEvent(Events event) async{
//   if (event.typeOfEvent=='Больничный')  {
//     await Users.addToUserSchedule(19,event);
//   }
//   if (event.typeOfEvent=='Отпуск')  {
//     await Users.addToUserSchedule(9,event);
//   }
//   if (event.typeOfEvent=='Дополнительный отпуск')  {
//     await Users.addToUserSchedule(10,event);
//   }
//   if (event.typeOfEvent=='Учебный отпуск')  {
//     await Users.addToUserSchedule(11,event);
//   }
//   if (event.typeOfEvent=='Отгул')  {
//     await Users.addToUserSchedule(16,event);
//   }
//   if (event.typeOfEvent=='Прогул')  {
//     await Users.addToUserSchedule(24,event);
//   }
// }
  static Future<int> checkForTypeOfEvent(Events event) async{
    if (event.typeOfEvent=='Больничный')  {
      return 19;
    }
    else {
      if (event.typeOfEvent == 'Отпуск') {
        return 9;
      }
      else {
        if (event.typeOfEvent == 'Дополнительный отпуск') {
          return 10;
        }
        else {
          if (event.typeOfEvent == 'Учебный отпуск') {
            return 11;
          }
          else {
            if (event.typeOfEvent == 'Отгул') {
              return 16;
            }
            else {
              if (event.typeOfEvent == 'Прогул') {
                return 24;
              }
              else {
                return 26;
              }
            }
          }
        }
      }
    }
  }
    static Future addEvent(
      Events newEvent
      ) async {
    for (int i=0;i<newEvent.userName.length;i++) {
      Users.updateAllEventsForUser(await Users.getUserByName(newEvent.userName[i]));
      //  await checkForTypeOfEvent(newEvent);
    }
          await FirebaseFirestore.instance
              .collection('events')
              .doc()
              .set({
            'userName':newEvent.userName,
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
  static Future updateEvent(
      Events newEvent,id
      ) async {
    for (int i=0;i<newEvent.userName.length;i++) {
      Users.updateAllEventsForUser(await Users.getUserByName(newEvent.userName[i]));
      //  await checkForTypeOfEvent(newEvent);
    }
    // await checkForTypeOfEvent(newEvent);
      await FirebaseFirestore.instance
          .collection('events')
          .doc(id)
          .update({
        'userName': newEvent.userName,
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



static  Events getEventFromSnapshot(DocumentSnapshot document)  {
    //чтение из базы данных
  List<dynamic> use =
  document.get('userName');
  List<String> users = use.map((e)=>e.toString()).toList();
  Events event = Events(
      users,
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

  static  getEventsToDate(List<Events> events, DateTime day)  {
    List<Events> listEvents=[];
    for(int i=0;i<events.length; i++) {
      if(day.millisecondsSinceEpoch>=Variables.allEvents[i].startDate.millisecondsSinceEpoch&&
          day.millisecondsSinceEpoch<=Variables.allEvents[i].endDate.millisecondsSinceEpoch){
        listEvents.add(events[i]);
      }
    }
    return listEvents;
  }

  static Future getAllEventsForUser(List<String> names) async {
    //чтение из базы данных
    List<Events> allEvents = [];
    for (int i = 0; i < names.length; i++) {
      await FirebaseFirestore.instance
          .collection('events')
          .where('userName',arrayContains: names[i])
          .orderBy('startDate')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
            allEvents.add(getEventFromSnapshot(doc));
        });
      });
    }

    return allEvents;
    // return name;
  }

  static Future getAllEvents() async {
    //чтение из базы данных
 List<Events> list=[];
      await FirebaseFirestore.instance
          .collection('events')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          list.add(getEventFromSnapshot(doc));
        });
      });
      return list;
  }

  static Future deleteEvent(String id) async {
    //удаление события из базы данных
     await FirebaseFirestore.instance
        .collection('events')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot)  async {
           Events event = getEventFromSnapshot(documentSnapshot);
           for (int i=0;i<event.userName.length;i++) {
             Users.updateAllEventsForUser(await Users.getUserByName(event.userName[i]));
       //  await checkForTypeOfEvent(newEvent);
     }
           // if (event.typeOfEvent!='Событие')  {
           //    Users.addToUserSchedule(26,event);
           // }
    });

    await FirebaseFirestore.instance
        .collection('events')
        .doc(id)
        .delete();
     Variables.allEvents = await Events.getAllEventsForUser(
         Variables.selectedUsers);
  }

}
