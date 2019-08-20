import 'package:flutter/material.dart';

class Picker extends StatefulWidget {
  final String title;

  final List<Map<String, dynamic>> options;

  Picker({Key key, this.title, this.options}) : super(key: key);

  createState() => PickerState();
}

class PickerState extends State<Picker> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Container(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(widget.title),
        ),
        children: widget.options.map(
          (option) {
            return Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, option['value'] ?? option['title']);
                  },
                  child: Text(option['title']),
                ));
          },
        ).toList());
  }
}
