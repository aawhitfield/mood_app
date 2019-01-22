import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
// saves a List of Any Objects into Shared Preferences. Take a key and parses into a string with JSON then saves the String.


Future<void> saveListOfObjectsToSharedPreferences(String key, List objects) async
{
  String _value = '';
  Map<String, String> map;
  objects.forEach((entry) {
    map = entry.toJson();
    _value += json.encode(map);
  });


  SharedPreferences _sp = await SharedPreferences.getInstance();
  _sp.setString(key, _value);
}