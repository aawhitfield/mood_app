import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Entry
{
  DateTime eventTime;
  String eventNotes;
  List<String> emotionList;

  Entry(this.eventTime, this.eventNotes, this.emotionList);

  Entry.fromJson(Map<String, dynamic> entry)
  {
    List<String> _toListString(string)
    {
      List<String> stringList = <String>[];
      String formattedString = string.substring(1, string.length - 1);
      stringList = formattedString.split(',');

      return stringList;
    }

    eventTime = DateTime.parse(entry['eventTime']);
    eventNotes = entry['eventNotes'];
    emotionList =  _toListString(entry['emotionList']);


  }


  Map<String, String> toJson() =>
      {
        'eventTime': eventTime.toString(),
        'eventNotes': eventNotes,
        'emotionList': emotionList.toString(),
      };
}