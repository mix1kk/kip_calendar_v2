import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kip_calendar_v2/Users/Users.dart';
import 'package:kip_calendar_v2/Menu/Menu.dart';
import 'package:kip_calendar_v2/Events/Events.dart';
import 'package:flutter/material.dart';
import '../AlertDialogs.dart';
import '../Widgets.dart';
import '../main.dart';
import '../Database.dart';
import 'Widgets/EventsWidgets.dart';

class EventsScreen extends StatefulWidget {
  EventsScreen({Key? key, required this.name}) : super(key: key);
final List<String> name;
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
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await Events.deleteAllEvents();
              setState(() {});
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
          EventsWidgets.eventsScreen(context,widget.name),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AlertDialogs.addEventAlertDialog(context);
          setState(() {});
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
