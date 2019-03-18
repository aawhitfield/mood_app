import 'package:flutter/material.dart';
import 'main.dart';
import 'package:mood_app/backend/emotions.dart';
import 'package:mood_app/backend/entry.dart';

class MoodContainer
    extends StatefulWidget // creates a custom stateful widget for the Mood tab
{
  final MyHomePageState
      parent; // creates a variable for the parent Widgets so I can pass/receive info from parent variables
  final Entry _entry;
  final int _index;

  MoodContainer(this.parent,
      this._entry,
      this._index,
      ); // constructor requiring the parent's context, and initializer

  @override
  State<StatefulWidget> createState() {
    return new MoodContainerState(); // creates the container that will be for the main Mood widget
  }
}

class MoodContainerState
    extends State<MoodContainer> // controls all the UI state of the Mood Widget
{
  // ***

  @override
  Widget build(BuildContext context) {
    // builds a container for the mood list view
    return Scaffold(
      appBar: AppBar(
        title: (widget._entry != null)
            ? Text(
                'Edit Mood', // app bar title that this medicine entry mode
              )
            : Text('Add Mood'),
        leading: GestureDetector(
          // cancel X button to close if user wants to abort adding an entry
          child: Icon(Icons.clear),
          onTap: () {
            Navigator.pop(context);
            this.widget.parent.todaysEmotions.clear();
          },
        ),
        actions: <Widget>[
          IconButton(
              icon: (widget._entry != null)
                  ? Icon(
                      Icons.edit,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
              onPressed: () {
                if(widget._entry == null) {
                  widget.parent.onButtonPressed(null, null);
                }
                else{
                  widget.parent.onButtonPressed(widget._entry, widget._index);
                }
              }),
        ],
      ),
      body: new Container(
        child: _buildEmotionList(),
      ),
    );
  }

  // ********
  Widget _buildEmotionList() // builds the ListView
  {
    return new ListView.builder(itemBuilder: (BuildContext _context, int i) {
      if (i.isOdd) {
        // puts a divider between each row
        return new Divider();
      }
      final int index = i ~/ 2;
      if (index < emotions.length) {
        return _buildRow(emotions[index]);
      }
    });
  }

  // **********
  Widget _buildRow(String emotion) // builds each row in the ListView
  {
    bool emotionSelected = this.widget.parent.todaysEmotions.contains(emotion);

    return new ListTile(
      leading: Image(
        // emoji representing the first emotion selected in each entry
        image: AssetImage('graphics/$emotion.png'
            .toLowerCase()), // looks up the file with the same name and converts to lower case to match case
        height: 32.0,
      ),
      title: new Text(
          emotion), // displays all the emotions that were selected on the given entry
      onTap: () {
        setState(() {
          widget.parent.setState(() {
            emotionSelected
                ? this.widget.parent.todaysEmotions.remove(
                    emotion) // if the emotion is already selected and it's selected again, then it's removed from the list
                : this.widget.parent.todaysEmotions.add(
                    emotion); // if the emotion hasn't been selected previously, then it is added to the list
          });
        });
      },
      trailing: Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: new Checkbox(
            // adds a checkbox on the end of each tile to indicate to the user if the emotion is/isn't in the list
            value:
                emotionSelected, // matches the checkbox with whether or not it is in the list
            onChanged: (bool newValue) {
              setState(() {
                widget.parent.setState(() {
                  newValue
                      ? this.widget.parent.todaysEmotions.add(
                          emotion) // gives the same functionality if you tap on the checkbox itself as if you had tapped on the list tile
                      : this.widget.parent.todaysEmotions.remove(emotion);
                  emotionSelected = newValue;
                });
              });
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget._entry != null) {
      print(this.widget._entry.dataList);
      widget._entry.dataList.forEach((emotion) {
        this.widget.parent.todaysEmotions.add(emotion.trim());
        print(emotion);
      });
    }
  }
} // end class MoodContainerState
