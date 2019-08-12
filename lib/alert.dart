import 'package:flutter/material.dart';
import 'package:flutter_app/view_model.dart';

class AlertPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AlertState();
  }
}

class AlertState extends State<AlertPage> {
  ViewModel vm;

  AlertState() {
    vm = ViewModel.get();

    _fcw = vm.detectFlagFile.config['enable_fcw'] == 'true' ?? false;

    _hmw = vm.detectFlagFile.config['enable_hmw'] == 'true' ?? false;

    _ldw = vm.detectFlagFile.config['enable_ldw'] == 'true' ?? false;

    _tsr = vm.detectFlagFile.config['enable_tsr'] == 'true' ?? false;

    _pcw = vm.detectFlagFile.config['enable_pcw'] == 'true' ?? false;
  }

  bool _lights = false;

  bool _fcw;

  bool _hmw;

  bool _ldw;

  bool _tsr;

  bool _pcw;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("报警"),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SwitchListTile(
              title: const Text('FCW报警'),
              value: _fcw,
              onChanged: (bool value) {
                setState(() {
                  _fcw = value;
                  vm.update(
                      vm.detectFlagFile, {'enable_fcw': value.toString()});
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('HMW报警'),
              value: _hmw,
              onChanged: (bool value) {
                setState(() {
                  _hmw = value;
                  vm.update(
                      vm.detectFlagFile, {'enable_hmw': value.toString()});
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('LDW报警'),
              value: _ldw,
              onChanged: (bool value) {
                setState(() {
                  _ldw = value;
                  vm.update(
                      vm.detectFlagFile, {'enable_ldw': value.toString()});
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('超速预警(TSR)'),
              value: _tsr,
              onChanged: (bool value) {
                setState(() {
                  _tsr = value;
                  vm.update(
                      vm.detectFlagFile, {'enable_tsr': value.toString()});
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('行人预警'),
              value: _pcw,
              onChanged: (bool value) {
                setState(() {
                  _pcw = value;
                  vm.update(
                      vm.detectFlagFile, {'enable_pcw': value.toString()});
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('轻度闭眼'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('重度闭眼'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('低头'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('打电话'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('左顾右盼'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('打哈欠'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('吸烟'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('离岗'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('驾驶员变更'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('遮挡'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('抬头'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('墨镜遮挡'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('双手脱离方向盘'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            SwitchListTile(
              title: const Text('长时间驾驶'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
          ],
        )));
  }
}
