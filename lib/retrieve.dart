import 'package:shared_preferences/shared_preferences.dart';

// Retrieves a String from Shared Preferences given a specified key.
// It then begins to parse the code so it can be re-read into a List
Future<List> restoreListOfObjectsFromSharedPreferences(String key) async
{
  List list = [];

  SharedPreferences _sp = await SharedPreferences.getInstance();
  String _stream = _sp.getString(key);

  List<String> splitString = _stream.split('}{');
  for(int i = 0; i < splitString.length; i++) {                                 // adds/removes { and } characters so it is formatted correctly so the String can be parsed back into a List<Object>
    if (!splitString[i].startsWith('{'))
      {
        splitString[i] = '{' + splitString[i];
      }
    else if(!splitString[i].endsWith('}'))
      {
        splitString[i] += '}';
      }

    list.add(splitString[i]);
  }
  return list;                                                                  // returns the list for use
}