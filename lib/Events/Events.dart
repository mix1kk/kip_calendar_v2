import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../AlertDialogs.dart';
import '../StatesAndVariables.dart';
import '../main.dart';
import '../Database.dart';
import 'Widgets/EventsWidgets.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key, required this.stream}) : super(key: key);
 final Stream <QuerySnapshot> stream;
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
        Column(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: Text('События', style: TextStyle(fontSize: 20.0)) ,
            ),
            SizedBox(
                height: 20.0,
                width: MediaQuery.of(context).size.width - 20,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(EdgeInsets.zero) ),
                    child:
                    Text(Variables.selectedUsers.toString(),style: const TextStyle(fontSize: 12.0)),
                    onPressed: ()async {
                      await AlertDialogs.selectUsersAlertDialog(context,'/events');

                      setState(() {

                      });
                    },
                  ),
                )
            ),
          ],
        ),
        // const Text('События'),
        // centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await Events.deleteAllEvents();

            },
          ),
          IconButton(
            onPressed: () {
              MyApp.menuNavigationDialog(context);
            },
            icon: const Icon(Icons.list),
          )
        ],
      ),
      body: Column(
        children: [
          EventsWidgets.eventsScreen(context, widget.stream/*widget.name*/),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AlertDialogs.addEventAlertDialog(context,'/events');
          setState(() {});
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
