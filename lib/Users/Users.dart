import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kip_calendar_v2/Widgets.dart';
import 'package:kip_calendar_v2/StatesAndVariables.dart';

import '../Database.dart';
import '../main.dart';
import 'Widgets/UsersWidgets.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);


  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

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
        title:
        Column(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: Text('Пользователи', style: TextStyle(fontSize: 20.0)) ,
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

        // const Text("Пользователи"),
      ),
      body:

      Column(
        children: [
          UsersWidgets.usersScreen(context),
        ],
      ),


    );
  }
}
