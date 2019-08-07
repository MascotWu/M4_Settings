import 'package:flutter/material.dart';

class Picker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PickerState();
  }
}

enum SingingCharacter { lafayette, jefferson }

class PickerState extends State<Picker> {
  SingingCharacter _character = SingingCharacter.lafayette;

  final items = List<String>.generate(10000, (i) => "Item $i");

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rewind and remember'),
      content: Column(
//        width: 100,
//        height: 100,
        children: <Widget>[
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${items[index]}'),
              );
            },
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('确定'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
