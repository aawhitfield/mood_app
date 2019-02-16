enum EntryType{
  mood,
  meal,
  med
}

class Entry
{ // ASn entry on a person's mood. It records the data and time of the entry, user inputted noted, and a list of emotions selected by the user.
  DateTime eventTime;
  String eventNotes;
  List<String> emotionList;
  EntryType entryType;

  Entry(this.eventTime, this.eventNotes, this.emotionList, this.entryType);                     // constructor

  Entry.fromJson(Map<String, dynamic> entry)                                    // custom decodes strings (e.g., from Shared Preferences back into an Entry object
  {
    List<String> _toListString(string)                                          // formats the string so it can be parsed back into a List<String>
    {
      List<String> stringList = <String>[];
      String formattedString = string.substring(1, string.length - 1);
      stringList = formattedString.split(',');

      return stringList;
    }

    eventTime = DateTime.parse(entry['eventTime']);                             // uses built in DateTime parser for String -> DateTime
    eventNotes = entry['eventNotes'];
    emotionList =  _toListString(entry['emotionList']);
    entryType = entryTypeStringToJSON(entry['entryType']);


  }


  Map<String, String> toJson() =>                                               // custom encoder for Entry objects -> String for storage in like SharedPreferences
      {
        'eventTime': eventTime.toString(),
        'eventNotes': eventNotes,
        'emotionList': emotionList.toString(),
        'entryType': typeAsString(entryType),
      };

  EntryType entryTypeStringToJSON(String typeString){

    EntryType entryType;

    switch(typeString){
      case 'Mood' : entryType = EntryType.meal;
                    break;
      case 'Meal' : entryType = EntryType.meal;
                    break;
      case 'Med' : entryType = EntryType.med;
                    break;
    }
    return entryType;
  }

  String typeAsString(EntryType entryType){
    String typeString = '';
    switch (entryType){
      case EntryType.mood : typeString = 'Mood';
                            break;
      case EntryType.meal : typeString = 'Meal';
                            break;
      case EntryType.med : typeString = 'Med';
                          break;
    }
    return typeString;
  }
}