import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/Users/Users.dart';
import 'package:kip_calendar_v2/Menu/Menu.dart';
import 'package:kip_calendar_v2/Events/Events.dart';
import 'package:kip_calendar_v2/styles.dart';
import 'Calendar.dart';
import 'widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'StatesAndVariables.dart';


class DayCalendarScreen extends StatefulWidget {
  const DayCalendarScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DayCalendarScreen> createState() => _DayCalendarScreenState();
}

class _DayCalendarScreenState extends State<DayCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.update),
            onPressed: () {
              setState(() {});
            },
          )
        ],
        title: const Text("День"),
      ),
      body: Column(
        children: [

          Widgets.mainBodyCalendarDayScreen(Variables.clickedDay,context),
        ],
      ),
    );
  }
}
