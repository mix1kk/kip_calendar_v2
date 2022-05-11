import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kip_calendar_v2/Users/Users.dart';
import 'package:kip_calendar_v2/Menu/Menu.dart';
import 'package:kip_calendar_v2/Events/Events.dart';
import 'package:flutter/material.dart';

import '../AlertDialogs.dart';
import '../Widgets.dart';
import '../main.dart';

class EventsScreen extends StatefulWidget {
  EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('События'),
          centerTitle: true,
          actions: [
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
            Widgets.eventsScreen(context),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
         await AlertDialogs.addEventAlertDialog(context);
         setState(() {

         });
        },
        child: const Icon(Icons.add_outlined),
      ),

    );
  }
}
