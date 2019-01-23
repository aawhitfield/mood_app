import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'mood.dart';
import 'mood_notes.dart';
import 'meals.dart';
import 'meds.dart';
import 'calendar_view.dart';
import 'entry.dart';
import 'save.dart';
import 'dart:convert';
import 'retrieve.dart';
import 'drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {


  ThemeData blueTheme = new ThemeData(                                          // theme data and color palettes
    primaryColor: Colors.blue.shade500,
    accentColor: Colors.lightBlue[500],
    primaryColorDark: Colors.blue.shade700,
    primaryColorLight: Colors.blue.shade100,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    dividerColor: Colors.grey.shade400,
  );

  ThemeData redTheme = new ThemeData(
    primaryColor: Colors.red,
    accentColor: Colors.redAccent
  );

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tracker App',
      theme: blueTheme,

      home: MyHomePage(title: 'Tracker App'),
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

class MyHomePageState extends State<MyHomePage> {                               // global variables
  String appBarTitle = 'EmojiTracker+';
  List<String> titles = ['Calendar', 'Mood', 'Meals', 'Meds'];
  int currentIndex = 1;
  int _calendarIndex = 0;
  List<Widget> tabs = <Widget>[]; // the navigation bar tabs at the bottom
  String notesText = ''; // value of the notes section
  TextEditingController notesController = new TextEditingController();
  DateTime now;
  Entry newEntry;
  List<Entry> journal = <Entry>[];
  final scaffoldKey = GlobalKey<ScaffoldState>();                              // sets a key to Scaffold so we can refer to it to call a Snackbar to alert users when entry has been added
  final String _journalKey = 'journalKey';
  final String mood = '';
  bool colored = true;                                                          // sets the selected Meal icon to be colored or black/white

  List<String> emotions = <String>[
    'Happy',
    'Angry',
    'Sad',
    'Scared',
    'Tired',
    'Wiggly',
    'Hyper',
    'Grumpy',
    'Robotic',
    'Calm',
  ];
  List<String> todaysEmotions = <String>[];




  @override
  void setState(fn) {
    //
    super.setState(fn);
  }

  @override                                                                     // prevents users from adding a note with no emotions
  void initState() {                                                            // load the Calendar view from Shared Preferences on initial State
    journal.clear();                                                            // clears the local variable to avoid duplicates
    restoreListOfObjectsFromSharedPreferences(_journalKey).then((stringListOfObjects) { // restores List from SharedPreferences string key


      stringListOfObjects.forEach((stringObject) {                              // formats List further so it parses back into Entry object correctly.
        if(!stringObject.toString().endsWith('}')) {
          stringObject += '}';
        }

        Map<String, dynamic> map = json.decode(stringObject);                   // uses JSON library to decode the string containing the List<Object> -> Map

        Entry entry = new Entry.fromJson(map);                                  // creates Entry objects with contents of Map

    journal.add(entry);                                                         // adds the Entry to journal List to complete the restore.
    });

    });

  }

  @override
  Widget build(BuildContext context) {
    tabs = [
                                                                                // creates the 4 tabs source codes at the bottom of the screen

      CalendarView(entries: journal,),
      MoodContainer(this),
      MealsWidget(this),
      MedsWidget(Colors.white),
    ];

    void onButtonPressed() {                                                    // action that floating button takes

      todaysEmotions.length > 0 ? MoodNotesDialog(this).onLoad(context) : null;
    }

    void onTabTapped(int index) {                                               // switches navigation tabs when tapped
      setState(() {
        currentIndex = index;
        appBarTitle = titles[index];
      });
    }


    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.

        title: Text(appBarTitle),//Text(widget.title),
      ),
      body: tabs[currentIndex],
      key: scaffoldKey,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [

          BottomNavigationBarItem(
            icon: new Icon(Icons.calendar_today),
            title: new Text(titles[0]),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mood),
            title: new Text(titles[1]),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.fastfood),
            title: new Text(titles[2]),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.local_pharmacy),
            title: new Text(titles[3]),
          ),

        ],
      ),
      drawer: UserDrawer(this),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: currentIndex == _calendarIndex ? null : FloatingActionButton(    // deactivates Floating Action Button on Calendar tab
          onPressed: () {
            //
            onButtonPressed();
          },
          child: Icon(Icons.add),
          //backgroundColor: Theme.of(context).primaryColor,//Colors.red.withAlpha(200),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //****************

  //******************

  void onAddPressed(
      String text) // runs when user presses ADD on the notes popup
  {
    //
    setState(() {
      notesText = text;
      List<String> tempList = todaysEmotions.toList();
      newEntry = Entry(now, notesText, tempList);
      journal.add(newEntry);

      saveListOfObjectsToSharedPreferences(_journalKey, journal); // saves whole journal with new entry to SharedPreferences library
      todaysEmotions.clear();
      notesController.clear();
    });
  }

  //***************************

/////////////////////////////////////////////////////////////////////
  //                         MOOD








}



