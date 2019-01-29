import 'package:flutter/material.dart';
import 'entry.dart';
import 'format_date_time.dart';
import 'package:flutter/scheduler.dart';
// TODO: Show only the Calendar for a given month with a view to select previous/next month
class CalendarView extends StatefulWidget {

  final List<Entry> entries;                                                    // a List of each of the entries the user has saved


  const CalendarView({Key key, this.entries}) : super(key: key);                // constructor that initializes the parameter entries

  @override
  CalendarViewState createState() {

    return new CalendarViewState();
  }
}

class CalendarViewState extends State<CalendarView> {                           // a stateful widget

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(

      body: _buildCalendarList(),
    );
  }

    Widget _buildCalendarList()
    {
        return new ListView.builder(
          reverse: false,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int i)
            {
              if(i.isOdd)                                                       // puts a divider between each entry
              {
              return new Divider();
            }
            final int index = i ~/ 2;
            if(index < widget.entries.length){
              return _buildRow(widget.entries[index]);
            }
            }
        );
    }

  Widget _buildRow(Entry entry)                                      // builds the row in the ListView
  {

    String formattedEmotionString = '';
    for (int i = 0; i < entry.emotionList.length; i++)              // formats when more than one emotion was selected for a given entry
      {
          if (i >= 1)
            {
              formattedEmotionString += ', ';
            }
          formattedEmotionString += entry.emotionList[i];
      }

    return new ListTile(
            leading: Container(
              width: 70.0,
              child: Column(
                children: <Widget>[
                  Image(
                    image: AssetImage('graphics/${entry.emotionList[0]}.png'.toLowerCase()),        // if an entry has more than one category (emotion) then the first one selected will be the default image
                    height: 32.0,
                    ),
                  Text(
                    formattedEmotionString,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            title: Text(entry.eventNotes),
            subtitle: Text(entry.typeAsString(entry.entryType) + ': ' + formatAbbreviatedDayWeekDateTime(entry.eventTime)),
          );
  }
}
