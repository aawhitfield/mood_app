import 'package:flutter/material.dart';
import 'package:mood_app/backend/entry.dart';
import 'package:mood_app/backend/format_date_time.dart';
import 'package:mood_app/meds.dart';
import 'package:mood_app/main.dart';
import 'package:mood_app/meals.dart';
import 'package:mood_app/mood.dart';

// TODO: Show only the Calendar for a given month with a view to select previous/next month
class CalendarView extends StatefulWidget {
  final List<Entry> entries; // a List of each of the entries the user has saved
  final MyHomePageState parent;

  const CalendarView({Key key, this.entries, this.parent})
      : super(key: key); // constructor that initializes the parameter entries

  @override
  CalendarViewState createState() {
    return new CalendarViewState();
  }
}

class CalendarViewState extends State<CalendarView> {
  // a stateful widget

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _buildCalendarList(),
    );
  }

  Widget _buildCalendarList() {
    if (widget.entries.length > 0) {
      return new ListView.builder(
          reverse: false,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int i) {
            if (i.isOdd) // puts a divider between each entry
            {
              return new Divider();
            }
            final int index = i ~/ 2;
            if (index < widget.entries.length) {
              return _buildRow(widget.entries[index], index);
            }
          });
    } else
      return new Container(
        child: Center(
          child: Text(''),
        ),
      );
  }

  Widget _buildRow(Entry entry, int index) // builds the row in the ListView
  {
    String formattedEmotionString = '';
    for (int i = 0;
        i < entry.dataList.length;
        i++) // formats when more than one emotion was selected for a given entry
    {
      if (i >= 1) {
        formattedEmotionString += ', ';
      }
      formattedEmotionString += entry.dataList[i];
    }

    return GestureDetector(
      onTap: () {
        switch (entry.entryType) {
          case EntryType.mood:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MoodContainer(widget.parent, entry, index)),
            );
            break;
          case EntryType.meal:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MealsWidget(widget.parent, entry, index)),
            );
            break;

          case EntryType.med:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MedsWidget(widget.parent, entry, index)),
            );
            break;
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 8.0, left: 8.0),
            width: 70.0,
            child: Column(
              children: <Widget>[
                Image(
                  // if an entry has more than one category (emotion) then the first one selected will be the default image
                  // displays generic medicine icon for meds, more specific for mood and meals
                  image: entry.entryType == EntryType.med
                      ? AssetImage('graphics/medicine.png')
                      : AssetImage(
                          'graphics/${entry.dataList[0]}.png'.toLowerCase()),
                  height: 32.0,
                ),
                Text(
                  formattedEmotionString,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    entry.eventNotes,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    entry.typeAsString(entry.entryType) +
                        ': ' +
                        formatAbbreviatedDayWeekDateTime(entry.eventTime),
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
