import 'package:flutter/material.dart';
import 'package:mood_app/backend/format_date_time.dart';
import 'main.dart';
import 'package:mood_app/backend/entry.dart';
import 'package:mood_app/backend/save.dart';
import 'package:mood_app/backend/retrieve.dart';
import 'package:mood_app/backend/user.dart';

// TODO: change + button to update
// TODO: update calendar_view with edited med
// TODO: apply med updates to meals and mood

class MedsWidget extends StatefulWidget {
  final MyHomePageState parent;
  final Entry _entry;

  MedsWidget(this.parent, this._entry);

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
  final String medNameKey =
      'medNameKey'; // key for storing / retrieving the last medicine name that was selected to make it faster for user to reuse common medicine
  var notesController =
      new TextEditingController(); // access text of notes to pass to journal entry
  String notes = ''; // medicine notes

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
            icon: widget._entry != null
                ? Text('Update',
                    style: TextStyle(
                      fontSize: 10.0,
                    ),)
                : Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
            onPressed: () {
              addMedRecord(notesController.text);
            },
          )
          // adds medicine entry to the journal
        ],
      ),
      body: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.local_pharmacy),
            title: widget._entry != null
                ? new Text(widget._entry.dataList[0])
                : new FutureBuilder(
                    future: restoreStringFromSharedPreferences(medNameKey),

                    // a Future<String> or null

                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      medicineName = snapshot.data;

                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      else if (snapshot.data == null) {
                        return new Text('Medicine Name');
                      } else
                        return new Text('${snapshot.data}');
                    },
                  ),
            onTap: () {
              _selectMed(); // lets user change the name of the medicine for the journal entry
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.access_time),
            title: widget._entry != null
                ? Text(formatAbbreviatedDayWeekMDY(widget._entry.eventTime))
                : Text(dateString),
            onTap: () {
              _selectDate(context);
            },
            trailing: GestureDetector(
              onTap: () {
                _selectTime(context);
              },
              child: widget._entry != null
                  ? Text(splitOffTime(widget._entry.eventTime))
                  : Text(_timeString),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: notesController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.subject),
                hintText: null,
                border: OutlineInputBorder(),
                labelText: 'Notes',
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              onSubmitted: (text) {
                setState(() {
                  addMedRecord(text);
                });
              },
              onChanged: (text) {
                notes = text;
              },
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
                    contentPadding: EdgeInsets.all(8.0),
                    hintText:
                        'Enter new medicine name', // prompts user to enter a new medicine
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  onSubmitted: (String text) {
                    setState(() {
                      medicineName = text;
                      medicineList.insert(0,
                          medicineName); // adds user entry to a list to save for quick re-selection
                      saveStringToSharedPreferences(medNameKey, medicineName);
                      saveListStringToSharedPreferences(medKey, medicineList);
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'Previously Entered',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
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
                            saveStringToSharedPreferences(
                                medNameKey, medicineName);
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
// TODO: save text labels on edit meds as data and add to calendar view
  void addMedRecord(String eventNotes) {
    // adds the med record to the general Journal, saves it to Shared Preferences for permanent storage
    setState(() {
      this.widget.parent.setState(() {
        // updates UI in this widget/class/file as well as in main.dart
        List<String> medAsAList = <
            String>[]; // place to store the med type as List to satisfy the requirements of the Entry Class
        medAsAList.add(
            medicineName); // adds the medicine name to the medAsList to meet requirements of the Entry Class parameter type

        DateTime combinedDateTime = combineDateTime(_date,
            _time); // combines the date from the Date Picker and the time from the TimePicker
        Entry newEntry =
            new Entry(combinedDateTime, eventNotes, medAsAList, EntryType.med);
        // creates a new Entry with all of the information the user has selected.

        this.widget.parent.users[this.widget.parent.currentUser].journal.insert(
            0,
            newEntry); // adds the new Entry into the global journal to show up in Calendar View at the beginning of the list



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

        medAsAList
            .clear(); // clears the list containing the medicine so it can be reused in the future

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
      if (widget._entry != null && widget._entry.eventNotes != null) {
        notesController.text = '${widget._entry.eventNotes}';
      }
      restoreListStringFromSharedPreferences(medKey).then((value) {
        value.forEach((entry) {
          medicineList.add(entry);
        });
      });
    });
  }
}
