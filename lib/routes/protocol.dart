import 'package:flutter/material.dart';
import 'package:flutter_app/routes/subiao.dart';
import 'package:flutter_app/models/view_model.dart';
import 'tianmai_directed.dart';

import 'jt808.dart';

class ProtocolPage extends StatefulWidget {
  createState() => _ProtocolPageState();
}

class _ProtocolPageState extends State<ProtocolPage> {
  @override
  Widget build(BuildContext context) {
    final ViewModel vm = ViewModel.get();
    return Scaffold(
      appBar: AppBar(
        title: Text('请选择协议'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.assignment),
            title: Text('天迈直连协议'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => TianMaiDirectConfigPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: Text('天迈协议'),
            onTap: () {
              vm.addOrUpdate(vm.mProtocolJsonFile, {'protocol': 'tianmai'});
              vm.protocolStream.add('tianmai');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: Text('JT808协议'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => Jt808ConfigPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: Text('苏标协议'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => SuBiaoConfigPage()));
            },
          ),
        ],
      ),
    );
  }
}
