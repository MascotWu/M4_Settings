
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(context: context,
          removeTop: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 30),
                alignment: Alignment.center,
                child: Image(image: AssetImage('assets/ic_launcher.png'),width: 80,height: 80,),
              ),
              ListTile(
                title: Text('应用版本',style: TextStyle(fontSize: 16,color: Colors.black87)),
                subtitle: Text("0.7.0"),
                trailing: Row(
                    mainAxisSize:MainAxisSize.min,
                    children: <Widget>[
                      Text("检查更新"),
                      Icon(Icons.navigate_next)
                    ],
                ),
                onTap: () {

                },
              ),
              ListTile(
                title: Text('清理缓存',style: TextStyle(fontSize: 16,color: Colors.black87)),
                onTap: () {

                },
              ),
              ListTile(
                title: Text('关于我们',style: TextStyle(fontSize: 16,color: Colors.black87)),
                onTap: () {

                },
              ),

            ],
          )),
    );
  }
}