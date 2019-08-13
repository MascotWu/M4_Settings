import 'package:flutter/material.dart';

class Picker extends StatefulWidget {
  final String title;

  final List<Map<String, dynamic>> options;

  Picker({Key key, this.title, this.options}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new PickerState();
  }
}

class PickerState extends State<Picker> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Text(widget.title),
        children: widget.options.map(
          (option) {
            return new SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, option['value']);
              },
              child: Text(option['title']),
            );
          },
        ).toList());
  }
}
