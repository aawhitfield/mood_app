import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// TODO: Annotate retreive.dart with comments
Future<List> restoreListOfObjectsFromSharedPreferences(String key) async
{
  List list = [];

  SharedPreferences _sp = await SharedPreferences.getInstance();
  String _stream = _sp.getString(key);
  print('Stream: ');
  print(_stream);

  List<String> splitString = _stream.split('}{');
  for(int i = 0; i < splitString.length; i++) {
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
  return list; //json.decode(_sp.getString(key));
}