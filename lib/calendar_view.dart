import 'package:flutter/material.dart';
import 'entry.dart';
import 'format_date_time.dart';
// TODO: Show only the Calendar for a given month with a view to select previous/next month
// TODO: Annotate the code for CalendarView
class CalendarView extends StatefulWidget {

  final List<Entry> entries;


  const CalendarView({Key key, this.entries}) : super(key: key);

  @override
  CalendarViewState createState() {

    return new CalendarViewState();
  }
}

class CalendarViewState extends State<CalendarView> {



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
          reverse: true,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int i)
            {
              if(i.isOdd)
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
    for (int i = 0; i < entry.emotionList.length; i++)
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
                    image: AssetImage('graphics/${entry.emotionList[0]}.png'.toLowerCase()),
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
            subtitle: Text('Mood: ' + formatDateTime(entry.eventTime)),
          );
  }
}
