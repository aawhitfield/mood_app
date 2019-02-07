import 'package:flutter/material.dart';
import 'format_date_time.dart';
import 'main.dart';
import 'entry.dart';
import 'save.dart';
import 'retrieve.dart';

// TODO: save last used medicine to Saved Preferences so it will always show up by default
// TODO: save medicine list to Saved Preferences so users only have to add them once
class MedsWidget extends StatefulWidget {
  final MyHomePageState parent;

  MedsWidget(this.parent);

  @override
  MedsWidgetState createState() {
    return new MedsWidgetState();
  }
}

class MedsWidgetState extends State<MedsWidget> {
  String medicineName =
      'Medicine Name'; // text that will be the name of the medicine to get stored into the calendar entry journal
  List<String> medicineList =
      []; // list of medicines to be saved for users to quickly reselect medicines
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  String dateString = '';
  String _timeString = '';
  final String medKey =
      'medKey'; // key for storing and retrieving medicine lists to/from Shared Preferences

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(_date.year - 1),
      lastDate: DateTime(_date.year + 1),
    );

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
        String _dayOfWeek = abbreviatedWeekday(_date);
        String _month = abbreviatedMonth(_date);
        dateString =
            _dayOfWeek + ', ' + _month + ' ${_date.day}, ${_date.year}';
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String _dayOfWeek = abbreviatedWeekday(
        _date); // sets the text on the Time tile to be today's date by default. Users can click it to bring up the DatePicker to change the date.
    String _month = abbreviatedMonth(_date);
    dateString = _dayOfWeek + ', ' + _month + ' ${_date.day}, ${_date.year}';
    // the string to use to display to the user the desired date for the med record
    _timeString = formatHour(_time.hour) +
        ':' +
        formatMinutes(_time.minute) +
        ' ' +
        formatAMPM(_time.hour);
    // the string to use to display to the user the desired time for the med record

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Med Entry', // app bar title that this medicine entry mode
        ),
        leading: GestureDetector(
          child: Icon(Icons.clear), // X icon to cancel entry mode
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: addMedRecord,
          )
          // adds medicine entry to the journal
        ],
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.local_pharmacy),
            title: Text(medicineName),
            onTap: () {
              _selectMed(); // lets user change the name of the medicine for the journal entry
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text(dateString),
            onTap: () {
              _selectDate(context);
            },
            trailing: GestureDetector(
              onTap: () {
                _selectTime(context);
              },
              child: Text(_timeString),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  void _selectMed() {
    // popup to select the medicine for the journal entry
    showDialog(
        context: context,
        child: Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: Theme.of(context).dividerColor,
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText:
                        'New medicine', // prompts user to enter a new medicine
                    hintStyle: Theme.of(context).textTheme.headline,
                  ),
                  onSubmitted: (String text) {
                    setState(() {
                      medicineName = text;
                      medicineList.add(
                          medicineName); // adds user entry to a list to save for quick re-selection
                      saveListStringToSharedPreferences(medKey, medicineList);
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              Expanded(
                // expanded prevents overflow on the ListView and makes it scrollable
                child: ListView.builder(
                    itemCount: medicineList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return new ListTile(
                        title: Text(medicineList[index]),
                        onTap: () {
                          setState(() {
                            medicineName = medicineList[index];
                            Navigator.pop(context);
                          });
                        },
                      );
                    }),
              ),
            ],
          ),
        ));
  }

  void addMedRecord() {
    // adds the med record to the general Journal, saves it to Shared Preferences for permanent storage
    setState(() {
      this.widget.parent.setState(() {
        // updates UI in this widget/class/file as well as in main.dart
        List<String> medAsAList = <
            String>[]; // place to store the med type as List to satisfy the requirements of the Entry Class
        medAsAList.add(
            medicineName); // adds the medicine name to the medAsList to meet requirements of the Entry Class parameter type

        String eventNotes = ''; // TODO: implement med notes

        DateTime combinedDateTime = combineDateTime(_date,
            _time); // combines the date from the Date Picker and the time from the TimePicker
        Entry newEntry =
            new Entry(combinedDateTime, eventNotes, medAsAList, EntryType.med);
        // creates a new Entry with all of the information the user has selected.

        this.widget.parent.journal.insert(0,
            newEntry); // adds the new Entry into the global journal to show up in Calendar View at the beginning of the list

        saveListOfObjectsToSharedPreferences(
            this.widget.parent.journalKey,
            this
                .widget
                .parent
                .journal); // saves whole journal with new entry to SharedPreferences library

        medAsAList
            .clear(); // clears the list containing the medicine so it can be reused in the future
//      notesController.clear();                                              // clears the user notes section so it can be reused in the future TODO: implement med notes controller

        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        // clears stack and returns to the Home screen
      });
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      restoreListStringFromSharedPreferences(medKey).then((value) {
        value.forEach((entry) {
          medicineList.add(entry);
        });
      });
    });
  }
}
