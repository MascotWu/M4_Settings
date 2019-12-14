import 'package:flutter/material.dart';

class PackageManagerPage extends StatefulWidget {
  @override
  _PackageManagerPageState createState() => _PackageManagerPageState();
}

class _PackageManagerPageState extends State<PackageManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('软件包管理')),
      body: SingleChildScrollView(child: Container(child: _buildPanel())),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Icon(Icons.move_to_inbox),
              title: Text(item.packageName),
              subtitle: Text(item.version),
            );
          },
          body: Column(
            children: item.releases.map<Widget>((release) {
              return Column(children: <Widget>[
                ListTile(
                  title: Text(release['version']),
                  subtitle: Column(children: <Widget>[
                    Text(release['note']),
                    Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Visibility(
                          visible: release.containsKey('progress'),
                          child: SizedBox(
                            child: LinearProgressIndicator(value: release['progress']),
                            height: 2,
                          ),
                        ))
                  ], crossAxisAlignment: CrossAxisAlignment.start),
                  trailing: Icon(Icons.file_download),
                ),
              ]);
            }).toList(),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

//ListTile(
//title: Text(item.releases['version']),
//subtitle: Text(item.releases['note']),
//trailing: Icon(Icons.file_download),
//onTap: () {
//setState(() {
//_data.removeWhere((currentItem) => item == currentItem);
//});
//})

// stores ExpansionPanel state information
class Item {
  Item({
    this.packageName,
    this.version,
    this.releases,
    this.isExpanded = false,
  });

  String version;
  List<Map> releases;
  String packageName;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  var packages = [
    {
      "name": "BSP",
      "version": "1.4.9",
      'releases': [
        {'version': '1.4.9', 'note': '修复了崩溃的问题', 'progress': 0.8},
        {'version': '1.4.10', 'note': '优化了网络请求'},
      ]
    },
    {
      "name": "ADAS",
      "version": "1.5.0",
      'releases': [
        {'version': '1.5.0', 'note': '提高了行人的识别率'},
        {'version': '1.5.0-alpha', 'note': '新增了1440p的支持'},
      ]
    },
    {
      "name": "DMS",
      "version": "5.5.1-beta",
      'releases': [
        {'version': '5.5.1-beta', 'note': '修改人脸的编码机制'},
        {'version': '5.5.2', 'note': '新增了驾驶员分神提醒的功能'},
        {'version': '5.5.3', 'note': '删除更换驾驶员的提醒'},
      ]
    }
  ];
  return List.generate(packages.length, (int index) {
    return Item(
      packageName: packages[index]['name'],
      version: packages[index]['version'],
      releases: packages[index]['releases'],
    );
  });
}

List<Item> _data = generateItems(8);
