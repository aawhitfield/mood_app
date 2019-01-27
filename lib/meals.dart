import 'package:flutter/material.dart'; // all of the widgets needed for Flutter
import 'main.dart'; // all of the language packages for Dart
import 'mealClass.dart'; // access the enum and objects for the Meal Class
import 'package:recase/recase.dart'; // able to change lowercase text -> title case for button labels
import 'format_date_time.dart';

class MealsWidget extends StatefulWidget {
  final MyHomePageState parent;

  MealsWidget(
      this.parent); // passes MyHomePageState to access global variables for read/write

  @override
  MealsWidgetState createState() {
    return new MealsWidgetState();
  }
}

class MealsWidgetState extends State<MealsWidget> {
  static Meal breakfast = new Meal(MealType.breakfast,
      false);                                                                   // creates objects of the 4 meals from the Meal Class
  static Meal lunch = new Meal(MealType.lunch, false);
  static Meal dinner = new Meal(MealType.dinner, false);
  static Meal snack = new Meal(MealType.snack, false);
  List<Meal> mealList = <Meal>[
    breakfast,
    lunch,
    dinner,
    snack
  ];                                                                            // creates list of meals to iterate over to make the layout
  DateTime _date = new DateTime.now();                                          // sets default date to today for date picker
  TimeOfDay _time = new TimeOfDay.now();                                        // sets default time to current time for time picker TODO: implement time picker
  String _dateString = '';                                                      // the string to use to display to the user the desired date for the meal record
  String _timeString = '';                                                      // the String to use to display to the user the desired time for the meal record

  String get dateString => _dateString;

  set dateString(String dateString) {
    _dateString = dateString;
  }                                      // Initial date for the label of the date picker. Defaults to today.

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(_date.year, _date.month - 1),                   // users can record meals one month in the past
        lastDate: new DateTime(_date.year,_date.month,_date.day+1),             // users cannot record meals in the future
    );

    if(picked != null && picked != _date)
      {
        setState(() {
          _date = picked;                                                       // changes the displayed date from today to the one the user selected from the DatePicker
          String _dayOfWeek = abbreviatedWeekday(_date);
          String _month = abbreviatedMonth(_date);
          dateString = _dayOfWeek + ', ' + _month + ' ${_date.day}, ${_date.year}';
        });
      }
  }


  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time);

    if(picked != null && picked != _time)
    {
      setState(() {
        _time = picked;                                                       // changes the displayed date from today to the one the user selected from the DatePicker
        _timeString = formatHour(_time.hour) + ':' + formatMinutes(_time.minute) + ' ' + formatAMPM(_time.hour);             // formats time to user friendly format

      });
    }
}


  @override
  Widget build(BuildContext context) {
    String _dayOfWeek = abbreviatedWeekday(_date);                              // sets the text on the Time tile to be today's date by default. Users can click it to bring up the DatePicker to change the date.
    String _month = abbreviatedMonth(_date);
    dateString = _dayOfWeek + ', ' + _month + ' ${_date.day}, ${_date.year}';
    _timeString = formatHour(_time.hour) + ':' + formatMinutes(_time.minute) + ' ' + formatAMPM(_time.hour);


    return Scaffold(
      appBar: AppBar(
        title: Text('Add Meal Entry'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                  Icons.add,
              color: Colors.white),
              onPressed: null)
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          // the main layout of the page going down in a column
//          Container(
//            color: Colors.grey[300],
//            child: ButtonBar(
//              mainAxisSize: MainAxisSize.max,
//              alignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                FlatButton(
//                  child: Icon(Icons.clear),
//                ),
//                FlatButton(
//                  child: Text(
//                    'SAVE',
//                    style: TextStyle(color: Theme.of(context).primaryColor),
//                  ),
//                )
//              ],
//            ),
//          ),
          ListTile(
            title: Text('Meal Type'),
            leading: Icon(Icons.local_dining),
          ),

          GridView.count(
            // creates a aesthetic grid of icon buttons to click on to toggle which meal to record
            crossAxisCount: 4,
            shrinkWrap: true,
            children: List.generate(mealList.length, (index) {
              // generates a flat button for each meal in the meal list
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(64.0)),
                  // makes the InkWell ripples more circular to match the circular icon
                  onPressed: () {
                    setState(() {
                      mealList.forEach((meal) {
                        // ensures that only one meal is selected. The one that is tapped gets selected and the others are deactivated
                        meal.mealType == mealList[index].mealType
                            ? meal.state = true
                            : meal.state = false;
                      });
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: mealList[index]
                                .state // activates colored image if its state property is toggled true, black&white if false
                            ? AssetImage(
                                'graphics/${mealList[index].toString()}_colored.png')
                            : AssetImage(
                                'graphics/${mealList[index].toString()}_bw.png'),
                        width: 64.0,
                        height: 64.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                            '${ReCase(mealList[index].toString()).titleCase}'), // uses ReCase to convert from lowercase -> titleCase for formatting
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          Divider(),
          // Controls the date and time picker. Defaults to now. Can be changed with a tap.
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text(
              'Time',
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.access_time,
              color: Colors.white,
            ),
            title: Text(dateString),
            onTap: (){_selectDate(context);},
            trailing: GestureDetector(
              onTap: (){
                _selectTime(context);
              },
              child: Text(_timeString),
            ),
          ),

          Divider(),
          // Allows user to add notes
          ListTile(
            leading: Icon(Icons.subject),
            title: TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(hintText: 'Add note'),
            ),
          ),
        ],
      ),
    );
  }
}
