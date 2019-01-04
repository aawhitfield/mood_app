import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodWidgetState extends State<MoodWidget>
{

  final String mood = '';

  List<String> emotions = <String>[
    'Happy',
    'Angry',
    'Sad',
    'Scared',
    'Tired',
    'Wiggly',
    'Hyper',
    'Grumpy',
    'Robotic',
    'Calm',
  ];

  List<String> todaysEmotions = <String>[];



  @override                                                     // build widget for the State class UI
  Widget build(BuildContext context) {
    return Container(

      child: _buildEmotionList(),
    );
  }


  Widget _buildEmotionList()                                     // builds the ListView
  {
    return new ListView.builder(
        itemBuilder: (BuildContext _context, int i)
        {
          if(i.isOdd)
          {
            return new Divider();
          }
          final int index = i ~/ 2;
          if(index < emotions.length){
            return _buildRow(emotions[index]);
          }
        }
    );
  }


  Widget _buildRow(String emotion)                                      // builds the row in the ListView
  {
    bool emotionSelected = todaysEmotions.contains(emotion);

    return new ListTile(
      leading: Image(
        image: AssetImage('graphics/$emotion.png'.toLowerCase()),
        height: 32.0,
      ),
      title: new Text(emotion),
      onTap: () {
        setState(() {
          emotionSelected ? todaysEmotions.remove(emotion) : todaysEmotions.add(emotion);
          print(todaysEmotions);
          _saveEmotions(todaysEmotions);

        });
      },
      trailing: new Checkbox(
        value: emotionSelected,
        //activeColor: Colors.red.withAlpha(200),
        onChanged: (bool newValue) {
          setState(() {
            newValue ? todaysEmotions.add(emotion) : todaysEmotions.remove(emotion);
          });
        }
      ),
    );
  }

  void _saveEmotions(List<String> emotions) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("emotions", emotions);
  } // _buildRow


}// end of MoodWidgetStateClass


class MoodWidget extends StatefulWidget {

  @override
  MoodWidgetState createState() => new MoodWidgetState();
}

