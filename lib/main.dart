import 'package:flutter/material.dart';
import 'package:flutter_app/common/common_variable.dart';
import 'package:flutter_app/routes/connection.dart';
import 'package:flutter_app/routes/left_drawer.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: CommonVariable.appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(CommonVariable.appName),
          ),
          drawer: LeftDrawer(),
          body: ConnectionPage(),
        ));
  }
}
