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
        //accentColor: Colors.red.withAlpha(200),
        accentColor: Colors.teal[500],
        fontFamily: Theme.of(context).platform == TargetPlatform.iOS
            ? 'Pristina'
            : 'Roboto',
        //toggleableActiveColor: Colors.red.withAlpha(200),
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
            Row(                                                                // time date stamp
              children: <Widget>[
                Center(
                  child: Container(
                      child: Text(
                          'Wednesday, January 2, 2019 ~ 6:00 PM',
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
            Row(                                                                // Emotions list
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


            Row(                                                                // user text field input for notes section
              // TODO: implement notes section
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: 250,
                      maxHeight: 42,
                  ),
                  child: TextField(
                    maxLines: 3,
                  ),
                ),
              ],
            ),


            Row(                                                                // action buttons
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
                    print(_emotions);
                    onAddPressed();
                    _emotions = [];
                    print(_emotions);
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

  Widget _buildEmojiList()                                     // builds the ListView
  {
    return new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext _context, int index)
        {
//          if(i.isOdd)
//          {
//            return new VerticalDivider();
//          }
//          final int index = i ~/ 2;
          if(index < _emotions.length){
            return _buildTile(_emotions[index]);
          }
        }
    );
  }


  Widget _buildTile(String emotion)                                      // builds the row in the ListView
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




//    void onAddPressed()                                                        // runs when user presses ADD on the notes popup
//    {
//      setState(() {
//        _clearEmotionsPreferences().then(updateEmotions);
//        print(_emotions);
//      });
//    }

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
        backgroundColor: Colors.red.withAlpha(200),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }






  //****************

  Future<List<String>> _getEmotionsPreferences() async {                        // Get emotions from Saved Preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> emotions = prefs.getStringList("emotions");


    return emotions;
  }



  //******************


  void onAddPressed()                                                        // runs when user presses ADD on the notes popup
  {
    // TODO: This needs to get implemented fully. It's not clearing everything out of shared preferences and resetting on Add
    setState(() {
      _clearEmotionsPreferences().then(updateEmotions);
      print(_emotions);
    });
  }





  Future<List<String>> _clearEmotionsPreferences() async {                        // Clear emotions from Saved Preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("emotions");
    List<String> emotions = [];


    return emotions;
  }







  //***************************


  void updateEmotions(List<String> emotions) {                                  // Restore Shared Preferences emotions into local variable
    setState(() {
      this._emotions = emotions;
    });
  }
}
