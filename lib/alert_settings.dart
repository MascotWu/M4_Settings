import 'package:flutter/material.dart';
import 'package:flutter_app/view_model.dart';

class AlertSettingsPage extends StatefulWidget {
  createState() => new AlertSettingsState();
}

class AlertSettingsState extends State<AlertSettingsPage> {
  ViewModel vm;

  AlertSettingsState() {
    vm = ViewModel.get();

    _fcw = vm.macroConfigFile.config['enable_fcw'];

    _hmw = vm.detectFlagFile.config['enable_hmw'];

    _ldw = vm.detectFlagFile.config['enable_ldw'];

    _tsr = vm.detectFlagFile.config['enable_tsr'];

    _pcw = vm.detectFlagFile.config['enable_ped'];

    _alertItemEyeclose1 =
    vm.dmsSetupFlagFile.config['alert_item_eyeclose1'];

    _alertItemEyeclose2 =
    vm.dmsSetupFlagFile.config['alert_item_eyeclose2'];

    _alertItemYawn =
    vm.dmsSetupFlagFile.config['alert_item_yawn'];

    _alertItemLookaround =
    vm.dmsSetupFlagFile.config['alert_item_lookaround'];

    _alertItemBow =
    vm.dmsSetupFlagFile.config['alert_item_bow'];

    _alertItemPhone =
    vm.dmsSetupFlagFile.config['alert_item_phone'];

    _alertItemSmoking =
    vm.dmsSetupFlagFile.config['alert_item_smoking'];

    _alertItemDemobilized =
    vm.dmsSetupFlagFile.config['alert_item_demobilized'];

    _alertItemDriverchange =
    vm.dmsSetupFlagFile.config['alert_item_driverchange'];

    _alertItemOcclusion =
    vm.dmsSetupFlagFile.config['alert_item_occlusion'];

    _alertItemLookup =
    vm.dmsSetupFlagFile.config['alert_item_lookup'];

    _alertItemEyeocclusion =
    vm.dmsSetupFlagFile.config['alert_item_eyeocclusion'];

    _alertItemHandsoff =
    vm.dmsSetupFlagFile.config['alert_item_handsoff'];

    _alertItemLongtimedrive =
    vm.dmsSetupFlagFile.config['alert_item_longtimedrive'];
  }

  bool _fcw;

  bool _hmw;

  bool _ldw;

  bool _tsr;

  bool _pcw;

  bool _alertItemEyeclose1;

  bool _alertItemEyeclose2;

  bool _alertItemYawn;

  bool _alertItemLookaround;

  bool _alertItemBow;

  bool _alertItemPhone;

  bool _alertItemSmoking;

  bool _alertItemDemobilized;

  bool _alertItemDriverchange;

  bool _alertItemOcclusion;

  bool _alertItemLookup;

  bool _alertItemEyeocclusion;

  bool _alertItemHandsoff;

  bool _alertItemLongtimedrive;

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
                });
                vm.addOrUpdate(
                    vm.macroConfigFile, {'enable_fcw': value ? '1' : '0'});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('HMW报警'),
              value: _hmw,
              onChanged: (bool value) {
                setState(() {
                  _hmw = value;
                });
                vm.addOrUpdate(
                    vm.detectFlagFile, {'enable_hmw': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('LDW报警'),
              value: _ldw,
              onChanged: (bool value) {
                setState(() {
                  _ldw = value;
                });
                vm.addOrUpdate(
                    vm.detectFlagFile, {'enable_ldw': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('超速预警(TSR)'),
              value: _tsr,
              onChanged: (bool value) {
                setState(() {
                  _tsr = value;
                });
                vm.addOrUpdate(
                    vm.detectFlagFile, {'enable_tsr': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('行人预警'),
              value: _pcw,
              onChanged: (bool value) {
                setState(() {
                  _pcw = value;
                });
                vm.addOrUpdate(
                    vm.detectFlagFile, {'enable_ped': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('轻度闭眼'),
              value: _alertItemEyeclose1,
              onChanged: (bool value) {
                setState(() {
                  _alertItemEyeclose1 = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_eyeclose1': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('重度闭眼'),
              value: _alertItemEyeclose2,
              onChanged: (bool value) {
                setState(() {
                  _alertItemEyeclose2 = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_eyeclose2': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('低头'),
              value: _alertItemBow,
              onChanged: (bool value) {
                setState(() {
                  _alertItemBow = value;
                });
                vm.addOrUpdate(
                    vm.dmsSetupFlagFile, {'alert_item_bow': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('打电话'),
              value: _alertItemPhone,
              onChanged: (bool value) {
                setState(() {
                  _alertItemPhone = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_phone': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('左顾右盼'),
              value: _alertItemLookaround,
              onChanged: (bool value) {
                setState(() {
                  _alertItemLookaround = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_lookaround': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('打哈欠'),
              value: _alertItemYawn,
              onChanged: (bool value) {
                setState(() {
                  _alertItemYawn = value;
                });
                vm.addOrUpdate(
                    vm.dmsSetupFlagFile, {'alert_item_yawn': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('吸烟'),
              value: _alertItemSmoking,
              onChanged: (bool value) {
                setState(() {
                  _alertItemSmoking = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_smoking': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('离岗'),
              value: _alertItemDemobilized,
              onChanged: (bool value) {
                setState(() {
                  _alertItemDemobilized = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_demobilized': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('驾驶员变更'),
              value: _alertItemDriverchange,
              onChanged: (bool value) {
                setState(() {
                  _alertItemDriverchange = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_driverchange': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('遮挡'),
              value: _alertItemOcclusion,
              onChanged: (bool value) {
                setState(() {
                  _alertItemOcclusion = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_occlusion': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('抬头'),
              value: _alertItemLookup,
              onChanged: (bool value) {
                setState(() {
                  _alertItemLookup = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_lookup': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('墨镜遮挡'),
              value: _alertItemEyeocclusion,
              onChanged: (bool value) {
                setState(() {
                  _alertItemEyeocclusion = value;
                });

                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_eyeocclusion': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('双手脱离方向盘'),
              value: _alertItemHandsoff,
              onChanged: (bool value) {
                setState(() {
                  _alertItemHandsoff = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_handsoff': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('长时间驾驶'),
              value: _alertItemLongtimedrive,
              onChanged: (bool value) {
                setState(() {
                  _alertItemLongtimedrive = value;
                });

                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_longtimedrive': value.toString()});
              },
              secondary: const Icon(Icons.warning),
            ),
          ],
        )));
  }
}
