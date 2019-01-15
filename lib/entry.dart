class Entry
{
  DateTime eventTime;
  String eventNotes;
  List<String> emotionList;

  Entry(this.eventTime, this.eventNotes, this.emotionList);

  Entry.fromJson(Map<String, dynamic> entry)
  {
    eventTime = DateTime.parse(entry['eventTime']);
    eventNotes = entry['eventNotes'];
    emotionList = ['Happy']; // entry['emotionList']; // TODO: Import actual emotion instead of dummy code of HAPPY
  }


  Map<String, String> toJson() =>
      {
        'eventTime': eventTime.toString(),
        'eventNotes': eventNotes,
        'emotionList': emotionList.toString(),
      };
}