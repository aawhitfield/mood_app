import 'package:flutter/material.dart';
import 'package:mood_app/backend/emotions.dart';
import 'package:mood_app/backend/save.dart';
// TODO: Control how to SORT emotion list
// TODO: Add additional emotions to list
class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() {
    return new SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Settings Page'),
//        leading: GestureDetector(
//          child: Icon(Icons.clear),
//          onTap: () {
//            Navigator.pop(context);
//          },
//        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Emotions to track',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String emotion) {
    return new SwitchListTile(
      secondary: Image(
        image: AssetImage('graphics/$emotion.png'
            .toLowerCase()), // looks up the file with the same name and converts to lower case to match case
        height: 32.0,
      ),
      title: Text(emotion),
      value: emotions.contains(emotion),
      onChanged:  (bool newValue){
        setState((){
          newValue ? emotions.add(emotion) : emotions.remove(emotion);
          saveListStringToSharedPreferences('settingsEmotionsKey', emotions);
        });
      },
    );
  }

  Widget _buildList() {
    return new ListView.builder(itemBuilder: (BuildContext context, int i) {
      if (i.isOdd) {
        // puts a divider between each row
        return new Divider();
      }
      final int index = i ~/ 2;
      if (index < allEmotions.length) {
        return _buildRow(allEmotions[index]);
      }
    });
  }
}
