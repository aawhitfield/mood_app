import 'package:flutter/material.dart';
import 'main.dart';
import 'package:mood_app/backend/save.dart';
import 'package:mood_app/backend/retrieve.dart';
import 'package:mood_app/backend/user.dart';
import 'package:mood_app/backend/entry.dart';

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

  String accountName = ' ';
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
                      widget.parent.users[this.widget.parent.currentUser].name =
                          snapshot.data;
                      accountName = widget
                          .parent
                          .users[this.widget.parent.currentUser]
                          .name; // Text to display fot the default user account until a user name has been entered
                      if (snapshot.data == null) {
                        return new Text('Default User');
                      } else {
                        return new Text('${snapshot.data}');
                      }
                    },
                  ),
                  onTap: () {
                    _promptChangeUserName(); // lets user change the name of the medicine for the journal entry
                  }),
              accountEmail: null,
              currentAccountPicture: new CircleAvatar(
                child: new FutureBuilder(
                  future: restoreStringFromSharedPreferences(defaultUserKey),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    widget.parent.users[this.widget.parent.currentUser].name =
                        snapshot.data;
                    accountName = widget
                        .parent
                        .users[this.widget.parent.currentUser]
                        .name; // Text to display fot the default user account until a user name has been entered
                    if (snapshot.data == null) {
                      return new Text(' ');
                    } else {
                      return new Text(
                        '${snapshot.data[0]}',
                        style: TextStyle(
                          fontSize: 48.0,
                        ),
                      );
                    }
                  },
                ),
              ),
              otherAccountsPictures: <Widget>[
                ListView.builder(
                  itemBuilder: (BuildContext context, int index){
                    if(index > 0 && index < this.widget.parent.users.length)
                      {
                        return _buildRow(this.widget.parent.users[index]);
                      }
                  }),
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
            onTap: addAccount,
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
          accountName = nameController.text;
          saveStringToSharedPreferences(defaultUserKey, accountName);
        }); // ...
        break;
    }
  }

  void addAccount() { // TODO: add circle avatar on add account instead of replace default
    //TODO: manage accounts (view and delete)
    // prompt user to enter name
    setState(() {
      _promptChangeUserName();

      // create new user
      User newUser = new User(
          this.widget.parent.users.length, accountName, accountName[0],
          new List<Entry>());

      // add user to users list
      this.widget.parent.users.add(newUser);

      // increment the number of users by users.length
      this.widget.parent.numberOfUsers = this.widget.parent.users.length;

      // save numberOfUSers to Shared Preferences
      saveIntToSharedPreferences(this.widget.parent.numberOfUsersKey,
          this.widget.parent.numberOfUsers);

      // change currentUser
      this.widget.parent.currentUser = this.widget.parent.users.length - 1;

      // save currentUser to Shared Preferences
      saveIntToSharedPreferences(
          this.widget.parent.currentUserKey, this.widget.parent.currentUser);

      // add account photos in drawer
    });
  }

  Widget _buildRow(User user) {
    return new CircleAvatar(
        child: Text(user.avatar),
      );
  }
}
