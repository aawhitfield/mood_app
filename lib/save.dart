import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
//TODO: annotate save.dart with comments
Future<void> saveListOfObjectsToSharedPreferences(String key, List objects) async
{
  String _value = '';
  Map<String, String> map;
  objects.forEach((entry) {
    map = entry.toJson();
    _value += json.encode(map);
  });
  print(_value);

  SharedPreferences _sp = await SharedPreferences.getInstance();
  _sp.setString(key, _value);
}