import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';



class AlertDialogs {

static  Future selectDate(initDate,context) async {
    DateTime date = DateTime(2022);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(1920),
      lastDate: DateTime.now().add(const Duration(days: 1095)),
    );
    if (picked != null) {
      date = initDate;
    }
    return date;
  }

//
//  Widget selectAlertDialog(){
//     return
// }
//

}







class dialogs extends StatefulWidget {
  @override
  _dialogsState createState() => _dialogsState();
}

class _dialogsState extends State<dialogs> {

  // List<bool> isClicked = List.filled(allIventsMap.length,
  //     false); //массив для отображения раскрытия события и закрытия всех остальных
  //

  Future selectDate(initDate) async {
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
    return date;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
//
//   Widget eventBody(index, bool isClicked) {
//     return SizedBox(
//       height: isClicked ? 300.0 : 0.0,
//       child: Column(
//         children: [
//           TextFormField(
//               decoration: const InputDecoration(
//                 isDense: true,
//                 contentPadding: EdgeInsets.all(2.0),
//                 border: OutlineInputBorder(),
//               ),
//               controller: event_controller,
//               onChanged: (String value) {
//                 // event_controller.text =value;
//
//                 Events.event = value;
//               },
//               textAlign: TextAlign.center),
//           const Text('Название события', style: TextStyle(fontSize: 10)),
//           Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Column(
//                   children: [
//                     SizedBox(
//                       height: 30,
//                       child: TextButton(
//                         style: TextButton.styleFrom(
//                           minimumSize: const Size(80, 0),
//                           padding:
//                           const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
//                         ),
//                         onPressed: () async {
//
//                           (isClicked)?Events.startDate = await selectDate(clickedDate):
//                           Events.startDate = await selectDate(Events.startDate);
//                           setState(() {});
//                         },
//                         child: Text(
//                           DateFormat.yMd().format((isClicked)?clickedDate:Events.startDate).toString(),
//                         ),
//                       ),
//                     ),
//                     const Text(
//                       'Дата начала',
//                       style: TextStyle(
//                         fontSize: 10,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     SizedBox(
//                       height: 30,
//                       child: TextButton(
//                         style: TextButton.styleFrom(
//                           minimumSize: const Size(80, 0),
//                           padding:
//                           const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
//                         ),
//                         onPressed: () async {
//                           (isClicked)?Events.endDate = await selectDate(clickedDate):
//                           Events.endDate = await selectDate(Events.endDate);
//                           setState(() {});
//                         },
//                         child: Text(
//                           DateFormat.yMd().format((isClicked)?clickedDate:Events.endDate).toString(),
//                         ),
//                       ),
//                     ),
//                     const Text('Дата окончания',
//                         style: TextStyle(fontSize: 10)),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     SizedBox(
//                       height: 30,
//                       child: TextButton(
//                         onPressed: () async {
//                           Events.dateOfNotification =
//                           await selectDate(Events.startDate);
//                           setState(() {});
//                         },
//                         style: TextButton.styleFrom(
//                           minimumSize: const Size(80, 0),
//                           padding:
//                           const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
//                         ),
//                         child: Text(
//                           DateFormat.yMd()
//                               .format(Events.dateOfNotification)
//                               .toString(),
//                         ),
//                       ),
//                     ),
//                     const Text('Напомнить', style: TextStyle(fontSize: 10)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
//             height: rowHeight * 3,
//             child: TextFormField(
//                 minLines: null,
//                 maxLines: null,
//                 expands: true,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//                 controller: eventComment_controller,
//                 onChanged: (String value) {
//                   Events.comment = value;
//                 },
//                 textAlign: TextAlign.center),
//           ),
//           Row(
//             children: [
//               Checkbox(
//                   value: Events.isDone,
//                   onChanged: (bool) {
//                     setState(() {
//                       Events.isDone = !Events.isDone;
//                     });
//                   }),
//               const Text('Выполнено'),
//             ],
//           ),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//             TextButton.icon(
//                 icon: const Icon(Icons.delete),
//                 label: const Text('Удалить'),
//                 onPressed: () async {
//                   await Events.deleteEvent(
//                     Users.name,
//                     allIventsMap.keys.elementAt(index),
//                   );
// // Navigator.of(context).pop();
//                   Navigator.pushNamed(context, '/home');
// //  setState(() {});
//                 }
// //  Navigator.pushNamed(context, '/home');
//             ),
//             TextButton.icon(
//               icon: const Icon(Icons.save),
//               label: const Text('Сохранить'),
//               onPressed: () async {
//                 if (Events.event == '') Events.event = 'Событие';
//                 await Events.addEvent(
//                     Users.name,
//                     Events.event,
//                     Events.startDate,
//                     Events.endDate,
//                     Events.dateOfNotification,
//                     Users.role,
//                     Events.comment,
//                     Events.isDone);
//                 isNewEvent = false;
//                 Navigator.of(context).pop();
//                 setState(() {});
//                 Navigator.pushNamed(context, '/home');
//               },
//             ),
//           ])
//         ],
//       ),
//     );
//   }


//   Widget build(BuildContext context) {
//     return StatefulBuilder(builder: (context, setState) {
//       return AlertDialog(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(DateFormat.yMMMMd().format(clickedDate).toString()),
//             ElevatedButton(
//               onPressed: () {
//                 isNewEvent = !isNewEvent;
//                 setState(() {});
//
//               },
//               child: const Icon(Icons.add, color: Colors.white),
//               style: ElevatedButton.styleFrom(
//                 shape: const CircleBorder(),
//                 padding: const EdgeInsets.all(10),
//                 primary: Colors.blue, // <-- Button color
//                 onPrimary: Colors.red, // <-- Splash color
//               ),
//             ),
//           ],
//         ),
//         content:
//         // StatefulBuilder(
//         //     builder: (BuildContext context, StateSetter setState) {
//         //       return
//         SizedBox(
//           width: MediaQuery.of(context).size.width - 40.0,
//           height: MediaQuery.of(context).size.height / 2,
//           child: ListView.builder(
//             itemCount: isNewEvent ? 1 : allIventsMap.length,
//             itemBuilder: (context, index) {
//               return isNewEvent
//                   ? eventBody(index, isNewEvent)
//                   : //если нажата кнопка создания нового ивента, показываются только поля создания ивента
//               ListTile(
//                 title: Column(
//                   children: [
//                     SizedBox(
//                       width: 280.0,
//                       height: rowHeight,
//                       child: ElevatedButton(
//                           style: isClicked[index]
//                               ? ButtonStyle(
//                               backgroundColor:
//                               MaterialStateProperty.all<Color>(
//                                   Colors.brown))
//                               : ButtonStyle(
//                             backgroundColor:
//                             MaterialStateProperty.all<Color>(
//                                 Colors.blue),
//                           ),
//                           // кнопка событие в диалоге
//
//                           onPressed: () async {
//                             await Events.getEvent(Users.name,
//                                 allIventsMap.keys.elementAt(index));
//                             for (int i = 0;
//                             i < allIventsMap.length;
//                             i++) {
//                               (i == index)
//                                   ? isClicked[index] = !isClicked[index]
//                                   : isClicked[i] = false;
//                             }
//                             setState(() {});
//                           },
//                           child:
//                           Text(allIventsMap.values.elementAt(index))),
//                     ),
//                     eventBody(index, isClicked[index]),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//         // }),
//
//         actions: [
//           TextButton(
//             child: const Text('Отмена'),
//             onPressed: () {
//               isNewEvent=false;
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//         // });
//       );
//     });
//   }
// }
