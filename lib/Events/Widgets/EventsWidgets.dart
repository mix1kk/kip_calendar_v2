import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/AlertDialogs.dart';
import 'package:kip_calendar_v2/StatesAndVariables.dart';
import 'package:kip_calendar_v2/Database.dart';
import 'package:kip_calendar_v2/Styles.dart';
import 'package:intl/intl.dart';

final TextEditingController startDateEventController = TextEditingController();
final TextEditingController endDateEventController = TextEditingController();
final TextEditingController dateOfNotificationEventController =
    TextEditingController();

class EventsWidgets {
  static Widget eventsScreen(
      context,
      Stream<QuerySnapshot> stream, bool isDateSorted, DateTime date) {
//основная таблица  наэкране Events
    return Expanded(
        child: StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> events) {
              if (events.hasError) {
                return const Text('Что-то пошло не так');
              }

              if (events.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
//const Text("Loading");
              }
              return ListView.builder(
                  itemCount: events.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(children: [
                      eventsMainScreenName(
                        context,
                        index,
                        events.data!.docs[index],isDateSorted, date
                      ),
                      SizedBox(
                        height:
                            (events.data!.docs[index].id == States.eventPressed)
                                ? Variables.rowHeight * 11
                                : 0.0,
                        child: eventsMainScreenData(
                          context,
                          events.data!.docs[index],
                        ),
                      ),
                    ]);
                  });
            }));
  }

  static Widget eventsMainScreenName(
      context, int index, DocumentSnapshot event, bool isDateSorted, DateTime date ) {
    //построение списка с названиями событий для всех пользователей
    bool isVisible=false;
    Events newEvent = Events.getEventFromSnapshot(event);
    if (isDateSorted &&  Variables.setZeroTime(date)
        .compareTo(Variables.setZeroTime(newEvent.startDate)) >=
        0 &&
        Variables.setZeroTime(date)
            .compareTo(Variables.setZeroTime(newEvent.endDate)) <=
            0) {
      isVisible = true;
    }
    if (!isDateSorted) {isVisible = true;}
    return Row(
      children: [
        Container(
            padding: const EdgeInsets.all(2.0),
            height: isVisible?Variables.rowHeight * 2:0,//если не входит в диапазон дат, скрываем
            width: Variables.firstColumnWidth,
            child: ElevatedButton(
              style: ButtonStyles.headerButtonStyle,
              onPressed: () {},
              child: Text('${index + 1}'),
            )),
        Container(
            padding: const EdgeInsets.all(2.0),
            height: isVisible?Variables.rowHeight * 2:0,
            width:
                MediaQuery.of(context).size.width - Variables.firstColumnWidth,
            child: ElevatedButton(
              style: (event.id == States.eventPressed)
                  ? ButtonStyles.headerButtonStyle
                  : ButtonStyles.usersListButtonStyle,
              onPressed: () async {
                if (event.id == States.eventPressed) {
                  States.eventPressed = '';
                  Variables.currentEvent = Variables.initialEvent;
                } else {
                  States.eventPressed = event.id;
                  Variables.currentEvent = newEvent;
                  startDateEventController.text =
                      DateFormat.yMd().format(Variables.currentEvent.startDate);
                  dateOfNotificationEventController.text = DateFormat.yMd()
                      .format(Variables.currentEvent.dateOfNotification);
                  endDateEventController.text =
                      DateFormat.yMd().format(Variables.currentEvent.endDate);
                } //для окрашивания выбранного ивента
                newEvent.isExpanded =
                    !newEvent.isExpanded; //для обновления экрана
                await Events.updateEvent(
                    newEvent, event.id); //для обновления экрана
              },
              child: ListTile(
                title: Text(newEvent.event),
                subtitle: Text(newEvent.userName.toString()),
              ),
            )),
      ],
    );
  }

  static Widget eventsMainScreenData(context, DocumentSnapshot event) {
//полные данные пользователей
    return Container(
      padding: const EdgeInsets.all(2.0),
      width: MediaQuery.of(context).size.width,
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
                    DateFormat.yMd().format(Variables.currentEvent.startDate);
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
                Variables.currentEvent.endDate = await AlertDialogs.selectDate(
                    Variables.currentEvent.endDate, context);
                endDateEventController.text =
                    DateFormat.yMd().format(Variables.currentEvent.endDate);
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
                        Variables.currentEvent.dateOfNotification, context);
                dateOfNotificationEventController.text = DateFormat.yMd()
                    .format(Variables.currentEvent.dateOfNotification);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () async {
                    if (Variables.selectedUser.role == 'admin') {
                      await AlertDialogs.deleteEventsScreen(
                          context, Variables.currentEvent.userName, event.id);
                      Variables.allEvents.clear();
                      Variables.allEvents = await Events.getAllEventsForUser(
                          Variables.selectedUsers);
//  Events.deleteEvent(Variables.currentEvent.userName, event.id);
//todo:добавить уведомление о недостаточности прав , если не админ
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Удалить   ')),
              ElevatedButton.icon(
                  style: ButtonStyles.headerButtonStyle,
                  onPressed: () async {
                    if (Variables.selectedUser.role == 'admin') {
                      States.eventPressed = '';
                      Variables.currentEvent.isExpanded =
                          !Variables.currentEvent.isExpanded;
                      await Events.updateEvent(
                          Variables.currentEvent, event.id);
                      Variables.allEvents.clear();
                      Variables.allEvents = await Events.getAllEventsForUser(
                          Variables.selectedUsers);

// Variables.currentEvent.isExpanded=!Variables.currentEvent.isExpanded;
// await Events.updateEvent(Variables.currentEvent,event.id);
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Сохранить   ')),
            ],
          )
        ],
      ),
    );
  }


}
