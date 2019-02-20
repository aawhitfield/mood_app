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
                  future: restoreStringFromSharedPreferences(this.widget.parent.userKey + 'name ${this.widget.parent.currentUser}'),

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
                      return new Text('Tap to enter name');
                    } else {
                      return new Text('${snapshot.data}');
                    }
                  },
                ),
                onTap: () {
                  _promptChangeUserName(this.widget.parent.users[this.widget.parent.currentUser].id); // lets user change the name of the medicine for the journal entry
                }),
            accountEmail: null,
            currentAccountPicture: new CircleAvatar(
              child: new FutureBuilder(
                future: restoreStringFromSharedPreferences(this.widget.parent.userKey + 'name ${this.widget.parent.currentUser}'),
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
          ),


          new ListTile(
            leading: Icon(Icons.add),
            title: Text('Add account'),
            onTap: addAccount,
          ),
          new ListTile(
            leading: Icon(Icons.settings),
            title: Text('Manage accounts'),
            onTap: () {
              setState(() {
                _manageAccounts();
              });
            },
          )
        ],
      ),
    );
  }

  Future<void> _promptChangeUserName(int userID) async {
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
                      saveStringToSharedPreferences(this.widget.parent.userKey + 'name $userID', text);
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
          this.widget.parent.setState(() {
            accountName = nameController.text;

            this.widget.parent.users[userID].name =
                accountName;

            saveUserAccount(
                this.widget.parent.userKey, userID,
                this.widget.parent.users[userID]);
          });
        }); // ...
        break;
    }
  }


  void addAccount() {
    // TODO: add circle avatar on add account instead of replace default

    setState(() {
      _promptChangeUserName(this.widget.parent.users.length);

      // create new user
      User newUser = new User(this.widget.parent.users.length, accountName,
          accountName[0], new List<Entry>());

      // add user to users list
      this.widget.parent.users.add(newUser);

      // increment the number of users by users.length
      this.widget.parent.numberOfUsers = this.widget.parent.users.length;

      // save numberOfUsers to Shared Preferences
      saveIntToSharedPreferences(this.widget.parent.numberOfUsersKey,
          this.widget.parent.numberOfUsers);

      // change currentUser
      this.widget.parent.currentUser = this.widget.parent.users.length - 1;

      // save currentUser to Shared Preferences
      saveIntToSharedPreferences(
          this.widget.parent.currentUserKey, this.widget.parent.currentUser);

      // clear name field
      nameController.clear();

      // add account photos in drawer
    });
  }

  Future<void> _manageAccounts() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            titlePadding: EdgeInsets.all(0.0),
            title: Container(
              padding: EdgeInsets.all(16.0),
              color: Theme.of(context).primaryColor,
              child: Text('Manage accounts',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            children: <Widget>[
                ListTile(
                  title: Text('Click on an account to select. Long press to rename. Or click the X to delete.'),
                ),
              Divider(),
              Container(
                width: 100.0,
                height: 250.0,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: this.widget.parent.users.length,
                    itemBuilder: (BuildContext context, int index){
                        return new ListTile(
                          title: new FutureBuilder(
                              future: restoreStringFromSharedPreferences(this.widget.parent.userKey + 'name $index'),
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                                if(snapshot.data == null)
                                  {
                                    return new Text('Default User');
                                  }
                                  else
                                    {
                                      return new Text(snapshot.data);
                                    }
                              },
                          ),

                          onTap: (){
                            setState(() {
                              saveIntToSharedPreferences(this.widget.parent.currentUserKey, index);

                              Navigator.of(context)
                                  .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                            });
                          },

                          onLongPress: (){
                            _promptChangeUserName(index);
                          },

                          trailing: GestureDetector(
                            child: Icon(Icons.cancel),
                            onTap: (){
                              String userName = ' ';
                              restoreStringFromSharedPreferences(this.widget.parent.userKey + 'name $index').then((name){
                                userName = name;
                              });

                              showDialog<void>(
                                context: context,
                                barrierDismissible: false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    titlePadding: EdgeInsets.all(0.0),
                                    title: Container(
                                        padding: EdgeInsets.all(16.0),
                                        margin: EdgeInsets.all(0.0),
                                        child: Text('Delete User',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        color: Colors.red,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('Are you sure you wish to delete the user ' + userName + '?'),
                                          Text('This will delete ALL user data. This action CANNOT be undone.'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('CANCEL',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('DELETE',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            this.widget.parent.setState((){
                                              this.widget.parent.users.removeAt(index);
                                              for (int i = 0; i < this.widget.parent.users.length; i++)   // resets the user id's to the index in the array
                                                {
                                                  this.widget.parent.users[i].id = i;

                                                  //clearSharedPreferences(this.widget.parent.userKey);
                                                  saveUserAccount(this.widget.parent.userKey, i, this.widget.parent.users[i]);

                                                  // updates the number of users by users.length
                                                  this.widget.parent.numberOfUsers = this.widget.parent.users.length;

                                                  // save numberOfUsers to Shared Preferences
                                                  saveIntToSharedPreferences(this.widget.parent.numberOfUsersKey,
                                                      this.widget.parent.numberOfUsers);

                                                  // change currentUser
                                                  this.widget.parent.currentUser = 0;

                                                  // save currentUser to Shared Preferences
                                                  saveIntToSharedPreferences(
                                                      this.widget.parent.currentUserKey, 0);

                                                }
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                                            });
                                          });

                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        );
                    }),
              ),
            ],
          );
        });
  }

}
