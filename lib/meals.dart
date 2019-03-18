import 'package:flutter/material.dart'; // all of the widgets needed for Flutter
import 'main.dart'; // all of the language packages for Dart
import 'package:mood_app/backend/mealClass.dart'; // access the enum and objects for the Meal Class
import 'package:recase/recase.dart'; // able to change lowercase text -> title case for button labels
import 'package:mood_app/backend/format_date_time.dart'; // able to format strings from DateTime objects in human readable format
import 'package:mood_app/backend/entry.dart'; // able to work with the Entry class
import 'package:mood_app/backend/save.dart'; // enables saving the List<Objects> to SharedPreferences
import 'package:mood_app/backend/user.dart';

class MealsWidget extends StatefulWidget {
  final MyHomePageState parent;
  final Entry _entry;
  final int _index;

  MealsWidget(this.parent, this._entry,
      this._index); // passes MyHomePageState to access global variables for read/write

  @override
  MealsWidgetState createState() {
    return new MealsWidgetState();
  }
}

class MealsWidgetState extends State<MealsWidget> {
  static Meal breakfast = new Meal(MealType.breakfast,
      false); // creates objects of the 4 meals from the Meal Class
  static Meal lunch = new Meal(MealType.lunch, false);
  static Meal dinner = new Meal(MealType.dinner, false);
  static Meal snack = new Meal(MealType.snack, false);
  List<Meal> mealList = <Meal>[
    breakfast,
    lunch,
    dinner,
    snack
  ]; // creates list of meals to iterate over to make the layout
  DateTime _date =
      new DateTime.now(); // sets default date to today for date picker
  TimeOfDay _time =
      new TimeOfDay.now(); // sets default time to current time for time picker
  String _dateString =
      ''; // the string to use to display to the user the desired date for the meal record
  String _timeString =
      ''; // the String to use to display to the user the desired time for the meal record

  TextEditingController notesController =
      new TextEditingController(); // controller to process text of notes field

  String get dateString => _dateString;

  set dateString(String dateString) {
    _dateString = dateString;
  } // Initial date for the label of the date picker. Defaults to today.

  bool _dateEdited = false;
  bool _timeEdited = false;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: new DateTime(_date.year,
          _date.month - 1), // users can record meals one month in the past
      lastDate: new DateTime(_date.year, _date.month,
          _date.day + 1), // users cannot record meals in the future
    );

    if (picked != null && picked != _date) {
      setState(() {
        _date =
            picked; // changes the displayed date from today to the one the user selected from the DatePicker
        String _dayOfWeek = abbreviatedWeekday(_date);
        String _month = abbreviatedMonth(_date);
        dateString =
            _dayOfWeek + ', ' + _month + ' ${_date.day}, ${_date.year}';
        _dateEdited = true;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _time);

    if (picked != null && picked != _time) {
      setState(() {
        _time =
            picked; // changes the displayed date from today to the one the user selected from the DatePicker
        _timeString = formatHour(_time.hour) +
            ':' +
            formatMinutes(_time.minute) +
            ' ' +
            formatAMPM(_time.hour); // formats time to user friendly format
        _timeEdited = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String _dayOfWeek = abbreviatedWeekday(
        _date); // sets the text on the Time tile to be today's date by default. Users can click it to bring up the DatePicker to change the date.
    String _month = abbreviatedMonth(_date);
    dateString = _dayOfWeek + ', ' + _month + ' ${_date.day}, ${_date.year}';
    _timeString = formatHour(_time.hour) +
        ':' +
        formatMinutes(_time.minute) +
        ' ' +
        formatAMPM(_time.hour);

    bool checkAnyMealSelected() {
      // checks to see if the user has selected any meal to record
      // i.e., breakfast, lunch, etc. If not, will not run and clicking on the +
      // icon will do nothing

      bool flag = false;
      mealList.forEach((meal) {
        (meal.state == true)
            ? flag = true
            : null; // loops through all the meals. If any one is true, then the function returns
        // true, otherwise if none are selected, function returns false
      });
      return flag;
    }

    void addMealRecord() {
      // adds the meal record to the general Journal, saves it to
      // Shared Preferences for permanent storage
      setState(() {
        this.widget.parent.setState(() {
          // updates UI in this widget/class/file as well as in main.dart
          List<String> mealAsAList = <
              String>[]; // place to store the meal type as List to satisfy the requirements of the Entry Class
          String selectedMeal =
              ''; // placeholder String with the name of the meal user selected e.g., Breakfast
          mealList.forEach((meal) {
            if (meal.state == true) {
              // loops through and find which meal was selected and then returns the name of the meal into selectedMeal String
              selectedMeal = meal.toString();
            }
          });
          mealAsAList.add(
              selectedMeal); // adds the selectedMeal to the mealAsList to meet requirements of the Entry Class parameter type

          String eventNotes = notesController
              .text; // stores the text from the Notes field into a variable eventNotes

          DateTime combinedDateTime = combineDateTime(_date,
              _time); // combines the date from the Date Picker and the time from the TimePicker
          Entry newEntry = new Entry(
              combinedDateTime, eventNotes, mealAsAList, EntryType.meal);
          // creates a new Entry with all of the information the user has selected.

          if (widget._entry == null) {
            this
                .widget
                .parent
                .users[this.widget.parent.currentUser]
                .journal
                .insert(0, newEntry);
          } else {
            this
                .widget
                .parent
                .users[this.widget.parent.currentUser]
                .journal[widget._index] = newEntry;
          }
// adds the new Entry into the global journal to show up in Calendar View

          // saves whole journal with new entry and entire user account to SharedPreferences library

          saveUserAccount(
              this.widget.parent.userKey,
              this.widget.parent.currentUser,
              new User(
                  this.widget.parent.currentUser,
                  this.widget.parent.users[this.widget.parent.currentUser].name,
                  this
                      .widget
                      .parent
                      .users[this.widget.parent.currentUser]
                      .name[0],
                  this
                      .widget
                      .parent
                      .users[this.widget.parent.currentUser]
                      .journal));

          mealAsAList
              .clear(); // clears the list containing the selectedMeal so it can be reused in the future
          notesController
              .clear(); // clears the user notes section so it can be reused in the future

          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
        });
      });
    }

    Future<void> _promptToSelectMeal() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Meal Not Selected'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Please select a meal (breakfast, lunch, dinner, or snack to add an entry.'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: (widget._entry != null)
            ? Text(
                'Edit Meal Entry', // app bar title that this medicine entry mode
              )
            : Text(
                'Add New Meal Entry', // app bar title that this medicine entry mode
              ),
        leading: GestureDetector(
          child: Icon(Icons.clear),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: widget._entry != null
                ? Icon(
                    Icons.save,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
            onPressed:
                checkAnyMealSelected() ? addMealRecord : _promptToSelectMeal,
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
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
                                'graphics/${mealList[index].toString().toLowerCase()}.png')
                            : AssetImage(
                                'graphics/${mealList[index].toString().toLowerCase()}_bw.png'),
                        width: 64.0,
                        height: 64.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text(
                          '${ReCase(mealList[index].toString()).titleCase}',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ), // uses ReCase to convert from lowercase -> titleCase for formatting
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
            title: (widget._entry != null && !_dateEdited)
                ? Text(formatAbbreviatedDayWeekMDY(widget._entry.eventTime))
                : Text(dateString),
            onTap: () {
              _selectDate(context);
            },
            trailing: GestureDetector(
              onTap: () {
                _selectTime(context);
              },
              child: (widget._entry != null && !_timeEdited)
                  ? Text(splitOffTime(widget._entry.eventTime))
                  : Text(_timeString),
            ),
          ),

          Divider(),
          // Allows user to add notes
          ListTile(
            leading: Icon(Icons.subject),
            title: TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              controller: notesController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(hintText: 'Add note'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget._entry != null) {
      switch (widget._entry.dataList.toString()) {
        case '[Breakfast]':
          mealList[0].state = true;
          mealList[1].state = false;
          mealList[2].state = false;
          mealList[3].state = false;
          break;
        case '[Lunch]':
          mealList[0].state = false;
          mealList[1].state = true;
          mealList[2].state = false;
          mealList[3].state = false;
          break;
        case '[Dinner]':
          mealList[0].state = false;
          mealList[1].state = false;
          mealList[2].state = true;
          mealList[3].state = false;
          break;
        case '[Snack]':
          mealList[0].state = false;
          mealList[1].state = false;
          mealList[2].state = false;
          mealList[3].state = true;
          break;

        default:
          print('fail');
          break;
      }

      notesController.text = '${widget._entry.eventNotes}';
    }
  }
}
