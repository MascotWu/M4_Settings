import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/view_model.dart';

class ADASSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ADASSettingsState();
  }
}

class _ADASSettingsState extends State {
  ViewModel vm = ViewModel.get();

  String _runningMode = "正常运行";

  Widget _runningModeWidget() {
    return ListTile(
      title: Text("运行模式"),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton.icon(
            onPressed: () {
              setState(() {
                _runningMode = "正常运行";
              });
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Radio<String>(
              value: "正常运行",
              groupValue: _runningMode,
              onChanged: (value) {
                print(value);
                setState(() {
                  _runningMode = value;
                });
              },
            ),
            label: Text("正常运行"),
          ),
          FlatButton.icon(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {
              setState(() {
                _runningMode = "静默运行";
              });
            },
            icon: Radio<String>(
              value: "静默运行",
              groupValue: _runningMode,
              onChanged: (value) {
                print(value);
                setState(() {
                  _runningMode = value;
                });
              },
            ),
            label: Text(
              "静默运行",
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  static final alerts = <ADASType>[
    ADASType.fcw,
    ADASType.hmw,
    ADASType.ldw,
    ADASType.pcw,
    ADASType.tsr
  ];

  Map<ADASType, ADASModel> models = () {
    var tModels = Map<ADASType, ADASModel>();
    alerts.forEach((ADASType item) => tModels[item] = ADASModel(item));
    return tModels;
  }();

  Future _showDialog(BuildContext context, String title, List<Map> options,
      ADASModel model, selectedValue) async {
    var value = await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text(title),
              children: options.map((option) {
                return FlatButton(
                  color: option["value"] == selectedValue["value"]
                      ? Colors.grey[100]
                      : Colors.transparent,
                  onPressed: () {
                    Navigator.of(context).pop(option);
                  },
                  child: Text(
                    "${option["name"]}",
                  ),
                );
              }).toList(),
            ));
    return value;
  }

  @override
  Widget build(BuildContext context) {
    var children = [
      _runningModeWidget(),
      Container(
        color: Colors.grey[350],
        height: 1,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      )
    ];

    alerts.forEach((ADASType type) {
      var model = models[type];
      children.add(model.buildWidget(model.value, (value) {
        print(value);
        setState(() {
          model.value = value;
        });
      }, onTimeTap: () {
        _showDialog(context, "请选择启动时间", ADASModel.timeOption, model, model.time)
            .then((result) {
          if (result == null) {
            return;
          }
          print("selected $result");
          setState(() {
            model.time = result;
          });
        });
      }, onSpeedTap: () {
        _showDialog(
                context, "请选择启动速度", ADASModel.speedOption, model, model.speed)
            .then((result) {
          if (result == null) {
            return;
          }
          print("selected $result");
          setState(() {
            model.speed = result;
          });
        });
      }, onSensitivityTap: () {
        var option = model.type == ADASType.fcw
            ? ADASModel.fcwSensitivityOption
            : ADASModel.ldwSensitivityOption;
        _showDialog(context, "请选择灵敏度", option, model, model.sensitivity)
            .then((result) {
          if (result == null) {
            return;
          }
          print("selected $result");
          setState(() {
            model.sensitivity = result;
          });
        });
      }));
    });

    return Scaffold(
        appBar: AppBar(
          title: Text("ADAS报警设置"),
        ),
        body: SingleChildScrollView(child: Column(children: children)));
  }
}

enum ADASType { fcw, hmw, ldw, pcw, tsr }

class ADASModel {
  ADASType type;

  ADASModel(this.type);

  String get title {
    return <ADASType, String>{
      ADASType.fcw: "FCW",
      ADASType.hmw: "HMW",
      ADASType.ldw: "LDW",
      ADASType.pcw: "PCW",
      ADASType.tsr: "TSR",
    }[this.type];
  }

  bool value = true;

  Map time = timeOption[0];
  Map speed = speedOption[0];
  Map sensitivity = fcwSensitivityOption[0];

  static List<Map<String,String>> _formatOptions<T>(List<T> list, String suffix) {
    return list
        .map((item) => {"value": "$item", "name": "$item$suffix"})
        .toList();
  }

  static final timeOption = _formatOptions<double>(
      [0.6, 0.7, 0.8, 0.9, 1.0, 1.2, 1.4, 1.6, 1.8], " s");
  static final speedOption =
      _formatOptions<String>(["30", "35", "40", "45", "50", "55"], " km/h");
  static final fcwSensitivityOption =
      _formatOptions<String>(["标准", "敏感", "更敏感"], "");
  static final ldwSensitivityOption =
      _formatOptions<String>(["标准", "低敏感度"], "");

  Widget buildWidget(bool value, ValueChanged<bool> onSwitchChanged,
      {VoidCallback onSpeedTap,
      VoidCallback onSensitivityTap,
      VoidCallback onTimeTap}) {
    var style = TextStyle(color: Colors.black87, fontSize: 16);
    double titleWidth = 100;

    var _buildOption = (String title, String optionValue, VoidCallback onTap) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: titleWidth,
            child: Text(
              title,
              style: style,
            ),
          ),
          OutlineButton.icon(
            onPressed: onTap,
            padding: EdgeInsets.only(left: 10),
            icon: SizedBox(
              child: Text(optionValue),
              width: 80,
            ),
            label: Icon(Icons.arrow_drop_down),
          ),
        ],
      );
    };

    var children = <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: titleWidth,
            child: Text(
              this.title,
              style: style,
            ),
          ),
          Expanded(child: SizedBox()),
          Switch(value: value, onChanged: onSwitchChanged),
        ],
      )
    ];
    if (type == ADASType.fcw) {
      children.add(
          _buildOption("灵敏度：", sensitivity["name"], onSensitivityTap));
    }
    if (type == ADASType.hmw) {
      children.add(_buildOption("启动时间：", time["name"], onTimeTap));
    }
    if (type == ADASType.ldw) {
      children.add(_buildOption("启动时速：", speed["name"], onSpeedTap));
      children.add(
          _buildOption("灵敏度：", sensitivity["name"], onSensitivityTap));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Column(
        children: children,
      ),
    );
  }
}
