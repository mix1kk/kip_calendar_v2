import 'package:flutter/material.dart';
import 'widgets.dart';
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
