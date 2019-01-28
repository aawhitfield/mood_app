import 'package:flutter/material.dart';
import 'main.dart';
import 'mood.dart';
import 'meals.dart';
import 'meds.dart';

class AnimatedFloatingActionButton extends StatefulWidget {
  final MyHomePageState parent;

  AnimatedFloatingActionButton(this.parent);
  //const AnimatedFloatingActionButton({Key key, this.parent}) : super(key: key);                                                 // creates a variable for the parent Widgets so I can pass/receive info from parent variables
  // system generated constructor
  @override
  State<StatefulWidget> createState() {
    return AnimatedFloatingActionButtonState();
  }
}

class AnimatedFloatingActionButtonState
    extends State<AnimatedFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
        new Positioned(
            bottom: 200.0,
            right: 24.0,
            child: new Container(
              child: new Row(
                children: <Widget>[
                  new ScaleTransition(
                    scale: widget.parent.animation3,
                    alignment: FractionalOffset.center,
                    child: new Container(
                      margin: new EdgeInsets.only(right: 16.0),
                      child: new Text(
                        'Med',
                        style: new TextStyle(
                          fontSize: 13.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFFE57373),
                          background: Paint()..color = Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  new ScaleTransition(
                    scale: widget.parent.animation3,
                    alignment: FractionalOffset.center,
                    child: new Material(
                        color: new Color(0xFFE57373),
                        type: MaterialType.circle,
                        elevation: 6.0,
                        child: new GestureDetector(
                          child: new Container(
                              width: 40.0,
                              height: 40.0,
                              child: new InkWell(
                                onTap: () {
                                  if (widget.parent.angle == 45.0) {
                                    print("foo1");
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MedsWidget(Colors.white),));
                                },
                                child: new Center(
                                  child: new Icon(
                                    Icons.local_pharmacy,
                                    color: new Color(0xFFFFFFFF),
                                  ),
                                ),
                              )),
                        )),
                  ),
                ],
              ),
            )),
        new Positioned(
            bottom: 144.0,
            right: 24.0,
            child: new Container(
              child: new Row(
                children: <Widget>[
                  new ScaleTransition(
                    scale: widget.parent.animation2,
                    alignment: FractionalOffset.center,
                    child: new Container(
                      margin: new EdgeInsets.only(right: 16.0),
                      child: new Text(
                        'Meal',
                        style: new TextStyle(
                          fontSize: 13.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFFE57373),
                          background: Paint()..color = Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  new ScaleTransition(
                    scale: widget.parent.animation2,
                    alignment: FractionalOffset.center,
                    child: new Material(
                        color: new Color(0xFFE57373),
                        type: MaterialType.circle,
                        elevation: 6.0,
                        child: new GestureDetector(
                          child: new Container(
                              width: 40.0,
                              height: 40.0,
                              child: new InkWell(
                                onTap: () {
                                  if (widget.parent.angle == 45.0) {
                                    print("foo2");
                                  }

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MealsWidget(widget.parent),
                                      ),
                                  );
                                },
                                child: new Center(
                                  child: new Icon(
                                    Icons.fastfood,
                                    color: new Color(0xFFFFFFFF),
                                  ),
                                ),
                              )),
                        )),
                  ),
                ],
              ),
            )),
        new Positioned(
            bottom: 88.0,
            right: 24.0,
            child: new Container(
              child: new Row(
                children: <Widget>[
                  new ScaleTransition(
                    scale: widget.parent.animation,
                    alignment: FractionalOffset.center,
                    child: new Container(
                      margin: new EdgeInsets.only(right: 16.0),
                      child: new Text(
                        'Mood',
                        style: new TextStyle(
                          fontSize: 13.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFFE57373),
                          background: Paint()..color = Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  new ScaleTransition(
                    scale: widget.parent.animation,
                    alignment: FractionalOffset.center,
                    child: new Material(
                        color: new Color(0xFFE57373),
                        type: MaterialType.circle,
                        elevation: 6.0,
                        child: new GestureDetector(
                          child: new Container(
                              width: 40.0,
                              height: 40.0,
                              child: new InkWell(
                                onTap: () {
                                  if (widget.parent.angle == 45.0) {
                                    print("foo3");
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MoodContainer(widget.parent),
                                    ),
                                  );
                                },
                                child: new Center(
                                  child: new Icon(
                                    Icons.insert_emoticon,
                                    color: new Color(0xFFFFFFFF),
                                  ),
                                ),
                              )),
                        )),
                  ),
                ],
              ),
            )),
        new Positioned(
          bottom: 16.0,
          right: 16.0,
          child: new Material(
              color: new Color(0xFFE57373),
              type: MaterialType.circle,
              elevation: 6.0,
              child: new GestureDetector(
                child: new Container(
                    width: 56.0,
                    height: 56.00,
                    child: new InkWell(
                      onTap: widget.parent.rotate,
                      child: new Center(
                          child: new RotationTransition(
                        turns:
                            new AlwaysStoppedAnimation(widget.parent.angle / 360),
                        child: new Icon(
                          Icons.add,
                          color: new Color(0xFFFFFFFF),
                        ),
                      )),
                    )),
              )),
        ),
      ],
    );
  }
}
