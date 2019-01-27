import 'package:flutter/material.dart';
import 'main.dart';

class UserDrawer extends StatefulWidget
{
  final MyHomePageState parent;

  UserDrawer(this.parent);

  @override
  State<StatefulWidget> createState() {

    return new UserDrawerState();
  }

}

class UserDrawerState extends State<UserDrawer>
{
// TODO: make Drawer have dynamic content

  @override
  Widget build(BuildContext context) {

    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
              accountName: new Text('Default'),
              accountEmail: null,
              currentAccountPicture: new CircleAvatar(
                child: new Icon(Icons.account_circle,
                    size: 68.0,
                ),
              ),
              otherAccountsPictures: <Widget>[
                CircleAvatar(
                  child: Text('K'),
                ),
                CircleAvatar(
                  child: Text('S'),
                ),
              ]),
          new ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Calendar View'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          new ListTile(
            leading: Icon(Icons.add),
            title: Text('Add account'),
          ),
          new ListTile(
            leading: Icon(Icons.settings),
            title: Text('Manage accounts'),
          )
        ],
      ),
    );
  }

}