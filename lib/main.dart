import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'mood.dart';
import 'meals.dart';
import 'meds.dart';
import 'package:platform_aware/platform_aware.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracker App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.blue.shade700,
        accentColor: Colors.red.withAlpha(200),
        fontFamily: Theme.of(context).platform == TargetPlatform.iOS
            ? 'Pristina'
            : 'Roboto',
        toggleableActiveColor: Colors.red.withAlpha(200),
      ),
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
  _MyHomePageState createState() => _MyHomePageState();
}

enum Answer { CANCEL, ADD } // enum for pop up

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<String> _emotions = <String>[];

  final List<Widget> _children = [
    // creates the 3 tabs source codes at the bottom of the screen
    MoodWidget(),
    MealsWidget(Colors.white),
    MedsWidget(Colors.white),
  ];

  //////////////////////////////////////////////////////////////////////////
  // Pop-up dialog code

  String _answer = '';
  void setAnswer(String value) {
    setState(() {
      //TODO: act on the answer
      _answer = value;
    });
  }

  Future<Null> _askuser() async {
    // TODO: Finish popup design for New Journal Entry
    switch (await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text('New Journal Entry'),
          children: <Widget>[
            Row(
              children: <Widget>[
                new FlatButton(
                  onPressed: (() {
                    Navigator.pop(context, Answer.ADD);
                  }),
                  child: Text('TESTING'),
                  textColor: Theme.of(context).primaryColor,
                ),
                new SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, Answer.CANCEL);
                  },
                  child: const Text(
                      'CANCEL',
                      ),
                  ),

                new SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, Answer.ADD);
                  },
                  child: const Text('ADD'),
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

  // end pop up code
  ////////////////////////////////////////////////////////////////////////////

  @override
  void setState(fn) {
    //
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    void _onButtonPressed() {
      // action that floating button takes

      setState(() {
        _getEmotionsPreferences().then(updateEmotions);
        print(_emotions);
        _askuser();
      });
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
        leading: Icon(Icons.menu),
        title: Text(widget.title),
      ),
      body: _children[_currentIndex],
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
      floatingActionButton: FloatingActionButton(
        onPressed: _onButtonPressed,
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<List<String>> _getEmotionsPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> emotions = prefs.getStringList("emotions");

    return emotions;
  }

  void updateEmotions(List<String> emotions) {
    setState(() {
      this._emotions = emotions;
    });
  }
}
