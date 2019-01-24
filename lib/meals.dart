import 'package:flutter/material.dart';
import 'main.dart';
import 'mealClass.dart';

class MealsWidget extends StatefulWidget {
  final MyHomePageState parent;

  MealsWidget(this.parent);

  @override
  MealsWidgetState createState() {
    return new MealsWidgetState();
  }
}

class MealsWidgetState extends State<MealsWidget> {
  Meal breakfast = new Meal(MealType.breakfast);
  Meal lunch = new Meal(MealType.lunch);
  Meal dinner = new Meal(MealType.dinner);
  Meal snack = new Meal(MealType.snack);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Select meal to record',
            style: Theme.of(context).textTheme.headline,
            textAlign: TextAlign.left,
          ),
        ),

        GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            children: List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage('graphics/breakfast_colored.png'),
                      width: 64.0,
                      height: 64.0,
                    ),
                    Text('Breakfast'),
                  ],
                ),
              );
            }),
      ),
    ],
    );

  }

  Widget _buildMealList() {
    return new ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: EdgeInsets.all(8.0),
        itemBuilder: (BuildContext context, int i) {
          if (i < 16) {
            return Image(image: AssetImage('graphics/breakfast_colored.png'), width: 64.0, height: 64.0,);//_buildMealTile();
          }
        });
  }

  Widget _buildMealTile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image(
            image: AssetImage('graphics/breakfast_colored.png'),
            width: 64.0,
            height: 64.0,
          ),
          Text('Breakfast'),
        ],
      ),
    );
  }

//    return Container(
//      color: Colors.white,
//      padding: EdgeInsets.all(8.0),
//      child: Column(
//        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.only(bottom: 16.0),
//                child: Text(
//                  'Select meal to record',
//                  style: Theme.of(context).textTheme.headline,
//                  textAlign: TextAlign.left,
//
//                ),
//              ),
//            ],
//          ),
//          Row(                                                                  // row of meals
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              Column(
//                children: <Widget>[
//                  IconButton(
//                      icon: Image(
//                        image: AssetImage(
//                          widget.parent.colored
//                              ? 'graphics/breakfast_colored.png'
//                              : 'graphics/breakfast_bw.png',
//                        ),
//                      ),
//                      iconSize: 64.0,
//                      onPressed: () {
//                        setState(() {
//                          widget.parent.colored
//                              ? widget.parent.colored = false
//                              : widget.parent.colored = true;
//                        });
//                      }),
//                  Text('Breakfast'),
//                ],
//              ),
//              Column(
//                children: <Widget>[
//                  IconButton(
//                      icon: Image(
//                        image: AssetImage(
//                          widget.parent.colored
//                              ? 'graphics/lunch_colored.png'
//                              : 'graphics/lunch_bw.png',
//                        ),
//                      ),
//                      iconSize: 64.0,
//                      onPressed: () {
//                        setState(() {
//                          widget.parent.colored
//                              ? widget.parent.colored = false
//                              : widget.parent.colored = true;
//                        });
//                      }),
//                  Text('Lunch'),
//                ],
//              ),
//              Column(
//                children: <Widget>[
//                  IconButton(
//                      icon: Image(
//                        image: AssetImage(
//                          widget.parent.colored
//                              ? 'graphics/dinner_colored.png'
//                              : 'graphics/dinner_bw.png',
//                        ),
//                      ),
//                      iconSize: 64.0,
//                      onPressed: () {
//                        setState(() {
//                          widget.parent.colored
//                              ? widget.parent.colored = false
//                              : widget.parent.colored = true;
//                        });
//                      }),
//                  Text('Dinner'),
//                ],
//              ),
//              Column(
//                children: <Widget>[
//                  IconButton(
//                      icon: Image(
//                        image: AssetImage(
//                          widget.parent.colored
//                              ? 'graphics/snack_colored.png'
//                              : 'graphics/snack_bw.png',
//                        ),
//                      ),
//                      iconSize: 64.0,
//                      onPressed: () {
//                        setState(() {
//                          widget.parent.colored
//                              ? widget.parent.colored = false
//                              : widget.parent.colored = true;
//                        });
//                      }),
//                  Text('Snack'),
//                ],
//              ),
//            ],
//          ),
//        ],
//      ),
//    );
}
//}
