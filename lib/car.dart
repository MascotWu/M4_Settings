import 'package:flutter/material.dart';

class CarPage extends StatefulWidget {
  final String title;

  CarPage({Key key, this.title}) : super(key: key);

  @override
  _CarPageState createState() {
    return _CarPageState();
  }
}

class _CarPageState extends State<CarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          Container(
            height: 50,
            child: const Center(child: Text('五菱宏光')),
          ),
          Container(
            height: 50,
            child: const Center(child: Text('比亚迪')),
          ),
          Container(
            height: 50,
            child: const Center(child: Text('沃尔沃')),
          ),
        ],
      ),
    );
  }
}
