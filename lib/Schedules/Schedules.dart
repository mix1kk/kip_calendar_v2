import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/Widgets.dart';
import 'package:kip_calendar_v2/StatesAndVariables.dart';

import '../main.dart';
import 'Widgets/SchedulesWidgets.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({Key? key}) : super(key: key);


  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.update),
            onPressed: () {
              setState(() {
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              MyApp.menuNavigationDialog(context);
            },
          )
        ],
        title: const Text("Графики работы"),
      ),
      body: Column(
        children: [
          SchedulesWidgets.schedulesScreen(context),
        ],
      ),
    );
  }
}
