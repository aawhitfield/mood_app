import 'package:flutter/material.dart';
import 'main.dart';
import 'package:mood_app/backend/format_date_time.dart';

class MoodNotesDialog extends StatefulWidget                                    // creates a custom stateful widget for the Mood notes popup dialog
{
  final MyHomePageState parent;                                                 // creates a variable for the parent Widgets so I can pass/receive info from parent variables

  MoodNotesDialog(this.parent);                                                 // constructor requiring the parent's context, and initializer

  @override
  State<StatefulWidget> createState() {                                         // nevessary override function

    return new MoodNotesDialogState();
  }


  void onLoad(BuildContext context) {                                           // this is the function I want to run when the widget is loaded



    Widget _buildTile(String emotion) // builds the row in the ListView         // this private function builds  the row of emojis in the popup. Called by _buildEmojiList
    {
      return new Container(
        width: 60,
        padding: EdgeInsets.all(0.0),
        margin: EdgeInsets.all(0.0),
        alignment: Alignment.topLeft,
        child: Row(
          children: <Widget>[
            Image(
              image: AssetImage(
                'graphics/$emotion.png'.toLowerCase(),
              ),
              width: 14,
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Text(
                emotion,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }








    Widget _buildEmojiList()                                                    // builds the ListView of emojis. Called by askUser
    {
      return new ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext _context, int index) {

            if (index < parent.todaysEmotions.length) {
              return _buildTile(parent.todaysEmotions[index]);
            }
          });
    }





    Future<Null> askUser() async {                                              // this is the function that builds the popup for notes to mood
      parent.now = new DateTime.now();
      String formattedDateTime = formatDateTime(parent.now);
      switch (await showDialog(
          context: context,
          child: new SimpleDialog(
            title: new Text(
              'New Journal Entry',
              style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w600,
              ),
            ),
            children: <Widget>[
              Row(
                // time date stamp
                children: <Widget>[
                  Center(
                    child: Container(
                      child: Text(formattedDateTime,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              Row(
                // Emotions list
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,

                children: <Widget>[
                  Container(
                    height: 14.0,
                    width: 250,
                    child: _buildEmojiList(),
                  ),
                ],
              ),
              Row(
                // user text field input for notes section
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 250,
                      maxHeight: 42,
                    ),
                    child: TextField(
                      autofocus: true,
                      controller: parent.notesController,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 3,
                      decoration: InputDecoration(
                          labelText: 'Notes',
                          labelStyle:
                          TextStyle(color: Theme.of(context).hintColor)),
                      onSubmitted: (String text) => parent.onAddPressed,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
              Row(
                // clear divider to make the text input field not overlap the cancel and add buttons
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    height: 30,
                    width: 150,
                  )
                ],
              ),
              Row(
                // action buttons
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new FlatButton(
                    onPressed: (() {
                      Navigator.pop(context, Answer.CANCEL);
                    }),
                    child: Text('CANCEL'),
                    textColor: Theme.of(context).accentColor,
                  ),
                  new FlatButton(
                    onPressed: (() {
                      Navigator.pop(context, Answer.ADD);
                      parent.onAddPressed(parent.notesController.text);
                      parent.notesController.clear();

                      // let user know action was successful
                      final snackbar = new SnackBar(
                        content: Text(
                          'Entry added',
                        ),
                      );
                      parent.scaffoldKey.currentState.showSnackBar(snackbar);
                    }),
                    child: Text('ADD'),
                    textColor: Theme.of(context).accentColor,
                  ),
                ],
              ),
            ],
          ))) {
        case Answer.ADD:

          break;
        case Answer.CANCEL:

          break;
      }
    }














  askUser();                                                                    // this is the command that actually calls the askUser function and starts everything in motion

  } // end onLoad



}

class MoodNotesDialogState extends State<MoodNotesDialog>
{
  @override
  Widget build(BuildContext context) {                                          // useless but I don't know what else to put as a child. I needed a widget to pass the build context to?
    return new Container(
        child: Text('Hello World'),
    );
  }

  @override                                                                     // also useless but I didn't know what other function I could run when Widget built
  void initState() {
    super.initState();
    print('initState');
    widget.onLoad(context);
  }










}