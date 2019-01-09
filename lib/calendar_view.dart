import 'package:flutter/material.dart';
import 'entry.dart';

class CalendarView extends StatefulWidget {

  final Entry entry;

  const CalendarView({Key key, this.entry}) : super(key: key);

  @override
  CalendarViewState createState() {
    return new CalendarViewState();
  }
}

class CalendarViewState extends State<CalendarView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Calendar View'),
      ),
      body: new ListView(
        children: <Widget>[
          new ListTile(
            title: Text('${widget.entry.eventTime} ~ ${widget.entry.eventNotes}'),
            subtitle: Text('Mood'),
          ),
        ],
      ),
    );
  }
}
