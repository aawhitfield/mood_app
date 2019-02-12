import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'mood_notes.dart';
import 'calendar_view.dart';
import 'entry.dart';
import 'save.dart';
import 'dart:convert';
import 'retrieve.dart';
import 'drawer.dart';
import 'package:flutter/animation.dart';
import 'animated_floating_action_button.dart';
import 'menu/menu.dart';
import 'menu/settings.dart';
import 'menu/credits.dart';
import 'emotions.dart';                                                         // contains the list of all emotions the user can track  plus the ones the user selected to track

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  ThemeData blueTheme = new ThemeData(
    // theme data and color palettes
    primaryColor: Colors.blue.shade500,
    accentColor: Colors.lightBlue[500],
    primaryColorDark: Colors.blue.shade700,
    primaryColorLight: Colors.blue.shade100,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    dividerColor: Colors.grey.shade400,
  );

  ThemeData redTheme =
      new ThemeData(primaryColor: Colors.red, accentColor: Colors.redAccent);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tracker App',
      theme: blueTheme,
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new MyHomePage(title: 'EmojiTrack+'),
      },
      home: MyHomePage(title: 'EmojiTrack+'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

enum Answer { CANCEL, ADD } // enum for pop up

class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // with Ticker for animated floating action button
  // global variables
  String appBarTitle = 'EmojiTracker+'; // title of the App on its home screen
  List<String> titles = [
    'Calendar',
    'Mood',
    'Meals',
    'Meds'
  ]; // names of the 4 tabs at the bottom of the navigation bar

  String notesText = ''; // value of the notes section
  TextEditingController notesController =
      new TextEditingController(); // Text controller to handle the Notes TextView in the add mood entry mode
  DateTime now; // the current DateTime reported from the OS
  Entry newEntry; // new entry to the journal to be displayed in Calendar mode
  List<Entry> journal = <Entry>[]; // the list of all journal entries
  final scaffoldKey = GlobalKey<
      ScaffoldState>(); // sets a key to Scaffold so we can refer to it to call a Snackbar to alert users when entry has been added
  final String journalKey =
      'journalKey'; // the global key to the journal so it can be saved and restored to/from Shared Preferences
  final String mood = ''; // variable to store all of the moods a user selects
  bool colored =
      true; // sets the selected Meal icon to be colored or black/white

  // ***************                                                            // variables to control animation for floating action button
  int angle = 90;
  bool isRotated = true;

  AnimationController controller;
  Animation<double> animation;
  Animation<double> animation2;
  Animation<double> animation3;
  // ***************                                                            // end of variables for animated floating action button




  List<String> todaysEmotions =
      <String>[];                                                               // the list of all emotions the user selects in a single entry

  void choiceAction(String choice){
    switch(choice){
      case 'Settings'
          : Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => SettingsPage(),
                ),
            );
            break;
      case 'Credits'
          : Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => CreditsPage(),
                ),
            );
            break;
      default
          : print('Unknown');
          break;
    }
  }

  @override
  void setState(fn) {
    //
    super.setState(fn);
  }

  @override // prevents users from adding a note with no emotions
  void initState() {
    // load the Calendar view from Shared Preferences on initial State
    journal.clear(); // clears the local variable to avoid duplicates
    restoreListOfObjectsFromSharedPreferences(journalKey)
        .then((stringListOfObjects) {
      // restores List from SharedPreferences string key

      stringListOfObjects.forEach((stringObject) {
        // formats List further so it parses back into Entry object correctly.
        if (!stringObject.toString().endsWith('}')) {
          stringObject += '}';
        }

        Map<String, dynamic> map = json.decode(
            stringObject); // uses JSON library to decode the string containing the List<Object> -> Map

        Entry entry = new Entry.fromJson(
            map); // creates Entry objects with contents of Map

        setState((){
          journal.add(
              entry);
        }); // adds the Entry to journal List to complete the restore.
      });
    });

    restoreListStringFromSharedPreferences('settingsEmotionsKey')
      .then((stringList) {

        setState((){
          if (stringList != null) {
            emotions.clear();
            stringList.forEach((element){
              emotions.add(element);
            });
          }

        });

    });

    // **************                                                           // set of commands to handle animations of the animated floating action button
    controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    animation = new CurvedAnimation(
      parent: controller,
      curve: new Interval(0.0, 1.0, curve: Curves.linear),
    );

    animation2 = new CurvedAnimation(
      parent: controller,
      curve: new Interval(0.5, 1.0, curve: Curves.linear),
    );

    animation3 = new CurvedAnimation(
      parent: controller,
      curve: new Interval(0.8, 1.0, curve: Curves.linear),
    );
    controller.reverse();
    // **************                                                           // end of commands to handle animations of the animated floating action button

    super.initState();
  } // end initState                                                            // end initState

  // ****************                                                           // custom method to handle the animated floating action button
  void rotate() {
    setState(() {
      if (isRotated) {
        angle = 45;
        isRotated = false;
        controller.forward();
      } else {
        angle = 90;
        isRotated = true;
        controller.reverse();
      }
    });
  }
  // *****************                                                          // end of method for animated floating action button

  void onButtonPressed() {
    // action that floating button takes

    todaysEmotions.length > 0 ? MoodNotesDialog(this).onLoad(context) : null;
  }

  @override
  Widget build(BuildContext context) {
    DateTime testTime = new DateTime.now();
    List<String> testString = [''];

Entry test = new Entry(testTime, '', testString, EntryType.meal);
print(test.typeAsString(test.entryType));


    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.

        title: Text('EmojiTrack+'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context){
              return Menu.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: CalendarView(
          entries:
              journal),
      key: scaffoldKey,


      //drawer: UserDrawer(this),                                               TODO: un-comment when ready to deploy drawer

      floatingActionButton: AnimatedFloatingActionButton(this),
    );
  }






  void onAddPressed(
      String text) // runs when user presses ADD on the notes popup
  {
    //
    setState(() {
      notesText = text;
      List<String> tempList = todaysEmotions.toList();
      newEntry = Entry(now, notesText, tempList, EntryType.mood);
      journal.insert(0,newEntry);

      saveListOfObjectsToSharedPreferences(journalKey,
          journal); // saves whole journal with new entry to SharedPreferences library
      todaysEmotions.clear();
      notesController.clear();
      Navigator.pop(context);
    });
  }
}
