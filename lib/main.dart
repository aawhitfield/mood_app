import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'mood.dart';
import 'meals.dart';
import 'meds.dart';
import 'package:platform_aware/platform_aware.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calendar_view.dart';
import 'entry.dart';

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
    primaryColor: Colors.blue.shade500,
    accentColor: Colors.lightBlue[500], //Colors.teal[500],
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
//        theme: ThemeData(
      // This is the theme of your application.
      //
      // Try running your application with "flutter run". You'll see the
      // application has a blue toolbar. Then, without quitting the app, try
      // changing the primarySwatch below to Colors.green and then invoke
      // "hot reload" (press "r" in the console where you ran "flutter run",
      // or simply save your changes to "hot reload" in a Flutter IDE).
      // Notice that the counter didn't reset back to zero; the application
      // is not restarted.
//          primaryColor: Colors.blue.shade500,
//          //accentColor: Colors.red.withAlpha(200),
//          accentColor: Colors.lightBlue[500], //Colors.teal[500],
//          primaryColorDark: Colors.blue.shade700,
//          primaryColorLight: Colors.blue.shade100,
//          iconTheme: IconThemeData(
//            color: Colors.white,
//          ),
//          dividerColor: Colors.grey.shade400,
//
//
//
//
//          fontFamily: Theme.of(context).platform == TargetPlatform.iOS
//              ? 'SF-Pro-Text'
//              : 'Roboto',
//          //toggleableActiveColor: Colors.red.withAlpha(200),
//        ),
      home: MyHomePage(title: 'Tracker App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

enum Answer { CANCEL, ADD } // enum for pop up

class MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<Widget> tabs = <Widget>[]; // the navigation bar tabs at the bottom
  String notesText = ''; // value of the notes section
  TextEditingController notesController = new TextEditingController();
  DateTime now;
  Entry newEntry;

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Pop-up dialog code

  String _answer = '';
  void setAnswer(String value) {
    setState(() {
      // TODO: Does this need to be deleted altogether? It was sample code
      _answer = value;
    });
  }

  Future<Null> _askuser() async {
    now = new DateTime.now();
    String dayOfWeek = '';
    String month = '';
    int hour = now.hour;
    String amPM = '';
    String minutes = now.minute.toString();

    // set Day of Week
    switch (now.weekday) {
      case 1:
        dayOfWeek = "Monday";
        break;
      case 2:
        dayOfWeek = "Tuesday";
        break;
      case 3:
        dayOfWeek = "Wednesday";
        break;
      case 4:
        dayOfWeek = "Thursday";
        break;
      case 5:
        dayOfWeek = "Friday";
        break;
      case 6:
        dayOfWeek = "Saturday";
        break;
      case 7:
        dayOfWeek = "Sunday";
        break;
    }

    // Set month
    switch (now.month) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }

    // set AM or PM
    if (hour < 12) {
      amPM = 'AM';
    } else {
      amPM = 'PM';
    }

    // sets 12 hour time
    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    // sets minutes formatted with leading zero as needed
    if (now.minute < 10) {
      minutes = '0${now.minute}';
    }

    // TODO: Finish popup design for New Journal Entry
    switch (await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text(
            'New Journal Entry',
            style: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w600,
            ),
          ),
          children: <Widget>[
            Row(
              // time date stamp
              children: <Widget>[
                Center(
                  child: Container(
                    child: Text(
                      '$dayOfWeek, $month ${now.day}, ${now.year} ~ $hour:$minutes $amPM',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Row(
              // Emotions list
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,

              children: <Widget>[
                Container(
                  height: 14.0,
                  width: 250,
                  child: _buildEmojiList(),
                ),
              ],
            ),
            Row(
              // user text field input for notes section
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 250,
                    maxHeight: 42,
                  ),
                  child: TextField(
                    autofocus: true,
                    controller: notesController,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    decoration: InputDecoration(
                        labelText: 'Notes',
                        labelStyle:
                            TextStyle(color: Theme.of(context).hintColor)),
                    onSubmitted: (String text) => onAddPressed,
                  ),
                ),
              ],
            ),
            Row(
              // clear divider to make the text input field not overlap the cancel and add buttons
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  height: 30,
                  width: 150,
                )
              ],
            ),
            Row(
              // action buttons
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new FlatButton(
                  onPressed: (() {
                    Navigator.pop(context, Answer.CANCEL);
                  }),
                  child: Text('CANCEL'),
                  textColor: Theme.of(context).accentColor,
                ),
                new FlatButton(
                  onPressed: (() {
                    Navigator.pop(context, Answer.ADD);
                    onAddPressed(notesController.text);
                    notesController.clear();
                  }),
                  child: Text('ADD'),
                  textColor: Theme.of(context).accentColor,
                ),
              ],
            ),
          ],
        ))) {
      case Answer.ADD:
        setAnswer('yes');
        break;
      case Answer.CANCEL:
        setAnswer('cancel');
        break;
    }
  }

  //////////////////// build emoji list tiles for notes section/////////////////////

  Widget _buildEmojiList() // builds the ListView
  {
    return new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext _context, int index) {
//          if(i.isOdd)
//          {
//            return new VerticalDivider();
//          }
//          final int index = i ~/ 2;
          if (index < todaysEmotions.length) {
            return _buildTile(todaysEmotions[index]);
          }
        });
  }

  Widget _buildTile(String emotion) // builds the row in the ListView
  {
    return new Container(
      width: 60,
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.all(0.0),
      alignment: Alignment.topLeft,
      child: Row(
        children: <Widget>[
          Image(
            image: AssetImage(
              'graphics/$emotion.png'.toLowerCase(),
            ),
            width: 14,
            height: 14,
          ),
          Text(
            emotion,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  //////////////////////end emoji label list view for notes section

  // end pop up code
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  void setState(fn) {
    //
    super.setState(fn);
  }

  @override // prevents users from adding a note with no emotions
  void initState() {}

  @override
  Widget build(BuildContext context) {
    tabs = [
      // creates the 3 tabs source codes at the bottom of the screen
      Container(child: _buildEmotionList()),
      MealsWidget(Colors.white),
      MedsWidget(Colors.white),
    ];

    void onButtonPressed() {
      // action that floating button takes

      //setState(() {
      todaysEmotions.length > 0 ? _askuser() : null;
      // });
    }

    void onTabTapped(int index) {
      setState(() {
        _currentIndex = index;

      });
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.

        title: Text(widget.title),
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.mood),
            title: new Text('Mood'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.fastfood),
            title: new Text('Meals'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.local_pharmacy),
            title: new Text('Meds'),
          ),
        ],
      ),

      drawer: new Drawer(
          child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
              accountName: new Text('Ethan'),
              accountEmail: null,
              currentAccountPicture: new CircleAvatar(
                child: new Text('E'),
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
              Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new CalendarView(
                        entry: newEntry,
                      )
                  ));
            },
          ),
          new ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Account'),
          ),
          new ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          )
        ],
      )),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //
          onButtonPressed();
        },
        child: Icon(Icons.add),
        //backgroundColor: Theme.of(context).primaryColor,//Colors.red.withAlpha(200),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //****************

  //******************

  void onAddPressed(
      String text) // runs when user presses ADD on the notes popup
  {
    // TODO: This needs to get implemented fully. It's not clearing everything out of shared preferences and resetting on Add
    setState(() {
      notesText = text;
      newEntry = Entry(now, notesText);
      todaysEmotions.clear();
      notesController.clear();
    });
  }

  //***************************

/////////////////////////////////////////////////////////////////////
  //                         MOOD

  final String mood = '';

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

//
//                                                      // build widget for the State class UI
//  Widget MoodWidget(){
//    return Container(
//
//      child: _buildEmotionList(),
//    );
//  }

  Widget _buildEmotionList() // builds the ListView
  {
    return new ListView.builder(itemBuilder: (BuildContext _context, int i) {
      if (i.isOdd) {
        return new Divider();
      }
      final int index = i ~/ 2;
      if (index < emotions.length) {
        return _buildRow(emotions[index]);
      }
    });
  }

  Widget _buildRow(String emotion) // builds the row in the ListView
  {
    bool emotionSelected = todaysEmotions.contains(emotion);

    return new ListTile(
      leading: Image(
        image: AssetImage('graphics/$emotion.png'.toLowerCase()),
        height: 32.0,
      ),
      title: new Text(emotion),
      onTap: () {
        setState(() {
          emotionSelected
              ? todaysEmotions.remove(emotion)
              : todaysEmotions.add(emotion);
        });
      },
      trailing: new Checkbox(
          value: emotionSelected,
          onChanged: (bool newValue) {
            setState(() {
              newValue
                  ? todaysEmotions.add(emotion)
                  : todaysEmotions.remove(emotion);
              emotionSelected = newValue;
            });
          }),
    );
  }
}

class MoodWidget extends StatefulWidget {
  @override
  MoodWidgetState createState() => new MoodWidgetState();
}

class MoodWidgetState extends State<MoodWidget> {
  @override
  Widget build(BuildContext context) {
    //
    return Container(child: MyHomePageState()._buildEmotionList());
  }
}
