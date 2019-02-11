import 'package:flutter/material.dart';
import 'main.dart';
import 'save.dart';
import 'retrieve.dart';

enum DialogOptions { CANCEL, OK }

class UserDrawer extends StatefulWidget {
  final MyHomePageState parent;

  UserDrawer(this.parent);

  @override
  State<StatefulWidget> createState() {
    return new UserDrawerState();
  }
}

class UserDrawerState extends State<UserDrawer> {
// TODO: make Drawer have dynamic content

  String defaultUserAccountName =
      ' '; // Text to display fot the default user account until a user name has been entered
  String defaultUserKey =
      'defaultUserKey'; // Shared Preferences key to save default user account string
  TextEditingController nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(

              accountName: GestureDetector(
                  child: FutureBuilder(
                    future: restoreStringFromSharedPreferences(defaultUserKey),

                    // a Future<String> or null

                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      defaultUserAccountName = snapshot.data;
                      if (snapshot.data == null) {
                        return new Text('Default User');
                      }
                      else {
                        return new Text('${snapshot.data}');
                      }
                    },
                  ),
                  onTap: () {
                    _promptChangeUserName(); // lets user change the name of the medicine for the journal entry
                  }),
              accountEmail: null,
              currentAccountPicture: new CircleAvatar(
                child: FutureBuilder(
                  future: restoreStringFromSharedPreferences(defaultUserKey),

                  // a Future<String> or null

                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    defaultUserAccountName = snapshot.data;
                    if (snapshot.data == null) {
                      return new Text(' ');
                    }
                    else {
                      return new Text(
                        '${snapshot.data}'[0],
                        style: TextStyle(
                          fontSize: 48.0,
                        ),
                      );
                    }
                  },
                ),
              ),
              otherAccountsPictures: <Widget>[
                CircleAvatar(
                  child: Text('K'),
                ),
                CircleAvatar(
                  child: Text('S'),
                ),
              ],
    ),
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

  Future<void> _promptChangeUserName() async {
    switch (await showDialog<DialogOptions>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Enter account name'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  onSubmitted: (text) {
                    setState(() {
                      saveStringToSharedPreferences(defaultUserKey, text);
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              new ButtonBar(
                mainAxisSize: MainAxisSize.min,
                alignment: MainAxisAlignment.end,
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, DialogOptions.CANCEL);
                    },
                    child: const Text('CANCEL'),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, DialogOptions.OK);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          );
        })) {
      case DialogOptions.CANCEL:
        // Let's go.
        // ...
        break;
      case DialogOptions.OK:
          setState(() {
            defaultUserAccountName = nameController.text;
            saveStringToSharedPreferences(defaultUserKey, defaultUserAccountName);
          });// ...
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      restoreStringFromSharedPreferences(defaultUserAccountName).then((value) {
        defaultUserAccountName = value;
      });
    });
  }
}
