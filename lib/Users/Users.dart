import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/Users/Users.dart';
import 'package:kip_calendar_v2/Menu/Menu.dart';
import 'package:kip_calendar_v2/Events/Events.dart';
import 'package:kip_calendar_v2/styles.dart';
import 'package:kip_calendar_v2/Calendar.dart';
import 'package:kip_calendar_v2/widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kip_calendar_v2/StatesAndVariables.dart';

class UsersScreen extends StatefulWidget {

  // const UsersScreen({
  //   Key? key,
  // }) : super(key: key);
  //

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

  // void _update(){
  //   setState(() {
  //   });
  // }
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
        title: const Text("Пользователи"),
      ),
      body: Column(
        children: [

          Widgets.usersScreen(Variables.clickedDay,context),
        ],
      ),
    );
  }
}
