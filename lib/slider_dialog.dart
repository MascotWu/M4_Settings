import 'package:flutter/material.dart';

class SliderDialog extends StatefulWidget {
  final double max;

  final double value;

  SliderDialog({Key key, this.value, this.max}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SliderDialogState(value);
}

class _SliderDialogState extends State<SliderDialog> {
  double _value;

  _SliderDialogState(double value) {
    _value = value;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, _value);
          },
          child: Slider(
            value: _value,
            max: widget.max,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
            onChangeEnd: (value) {
              Navigator.pop(context, value);
            },
          ),
        ),
      ],
    );
  }
}
