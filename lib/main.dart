import 'package:flutter/material.dart';
import 'package:flutter_app/common/common_variable.dart';
import 'package:flutter_app/routes/connection.dart';
import 'package:flutter_app/routes/home.dart';
import 'package:flutter_app/routes/left_drawer.dart';

void main() {
  runApp(App());
}


class RouteName {
  final String home = "home";
  final String connect = "connect";
}

class AppRoute {

  static RouteName name = RouteName();
  static var _routes = <String,Widget>{
    name.home: Scaffold(
      appBar: AppBar(title: Text(CommonVariable.appName),),
      drawer: LeftDrawer(),
      body: HomePage(title: CommonVariable.appName,),
    ),
    name.connect: Scaffold(
      appBar: AppBar(title: Text(CommonVariable.appName),),
      drawer: LeftDrawer(),
      body: ConnectionPage(),
    )
  };

  static Widget routeFromName(String name) {
    var widget = _routes[name];
    return widget;
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: CommonVariable.appName,
        theme: ThemeData(primarySwatch: Colors.blue,),
      initialRoute: AppRoute.name.connect,
      routes: {
        AppRoute.name.home:(context) => AppRoute.routeFromName(AppRoute.name.home),
        AppRoute.name.connect:(context) => AppRoute.routeFromName(AppRoute.name.connect),
      },
    );
  }
}
