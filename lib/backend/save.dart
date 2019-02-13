import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'user.dart';

// saves a List of Any Objects into Shared Preferences. Take a key and parses into a string with JSON then saves the String.


Future<void> saveIntToSharedPreferences(String key, int value) async{
  SharedPreferences _sp = await SharedPreferences.getInstance();
  _sp.setInt(key, value);
}

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

Future<void> saveStringToSharedPreferences(String key, String value) async{
  SharedPreferences _sp = await SharedPreferences.getInstance();
  _sp.setString(key, value);
}

Future<void> saveListStringToSharedPreferences(String key, List<String> value) async{
  SharedPreferences _sp = await SharedPreferences.getInstance();
  _sp.setStringList(key, value);
}

Future<void> clearSharedPreferences(String key) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

Future<void> saveUserAccount(String key, int position, User user) async{
 saveIntToSharedPreferences(key + 'id $position', user.id);
 saveStringToSharedPreferences(key + 'name $position', user.name);
 saveStringToSharedPreferences(key + 'avatar $position', user.avatar);
 saveListOfObjectsToSharedPreferences(key + 'journal $position', user.journal);
}