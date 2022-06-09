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
        title:  Column(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: Text('Графики работы', style: TextStyle(fontSize: 20.0)) ,
            ),
            Container(
              // padding: const EdgeInsets.fromLTRB(50.0, 8.0, 0.0, 1.0),
                height: 20.0,
                width: MediaQuery.of(context).size.width - 20,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(Variables.selectedUser.name,style: const TextStyle(fontSize: 12.0)),
                )
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SchedulesWidgets.schedulesScreen(context),
        ],
      ),
    );
  }
}
