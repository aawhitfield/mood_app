// This file is used to save (read/write) journal entries to the local app storage folder for
// data persistence across app launches on the same device.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'entry.dart';
import 'dart:convert';

class JournalStorage
{
  Future<String> get _localPath async
  { // gets the path to the local storage folder for iOS/Android
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async
  { // creates a file to store the journal to
    final path = await _localPath;

    return File('$path/journal.txt');
  }

  Future<File> write(List<Entry> list) async
  // TODO: DELETE save_journal.dart
  { // TODO: figure out the parameters to pass - should it be the journal List or a JSON
    // encoded string??

    final file = await _localFile;
    String json = jsonEncode(list);


    return file.writeAsString(json);
    // TODO: figure out what to return. Probably the JSON encoded string??
  }

  Future<int> read() async
  //TODO: figure out type to return. Example had int. I probably need List<Entry>??
  // reads the file into local variables
  {
    try
    {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      Map<String, dynamic> entries = jsonDecode(contents);
//      List<Entry> = entries.to

      return 0;//list; // return contents of file probably as List<Entry>
    }
    catch (e)
    { // If we encounter an error, return 0
      return 0;
    }

  }
}