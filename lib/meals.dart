import 'package:flutter/material.dart'; // all of the widgets needed for Flutter
import 'main.dart'; // all of the language packages for Dart
import 'mealClass.dart'; // access the enum and objects for the Meal Class
import 'package:recase/recase.dart'; // able to change lowercase text -> title case for button labels

class MealsWidget extends StatefulWidget {
  final MyHomePageState parent;

  MealsWidget(
      this.parent); // passes MyHomePageState to access global variables for read/write

  @override
  MealsWidgetState createState() {
    return new MealsWidgetState();
  }
}

class MealsWidgetState extends State<MealsWidget> {
  static Meal breakfast = new Meal(MealType.breakfast,
      false); // creates objects of the 4 meals from the Meal Class
  static Meal lunch = new Meal(MealType.lunch, false);
  static Meal dinner = new Meal(MealType.dinner, false);
  static Meal snack = new Meal(MealType.snack, false);
  List<Meal> mealList = <Meal>[
    breakfast,
    lunch,
    dinner,
    snack
  ]; // creates list of meals to iterate over to make the layout

  @override
  Widget build(BuildContext context) {
    return Column(
      // the main layout of the page going down in a column
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          color: Colors.grey[300],
          child: ButtonBar(
            mainAxisSize: MainAxisSize.max,
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Text(
                    'CANCEL',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              FlatButton(
                child: Text(
                    'SAVE',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              )
            ],
          ),
        ),
        ListTile(
          title: Text('Meal Type'),
          leading: Icon(Icons.local_dining),
        ),
        GridView.count(
          // creates a aesthetic grid of icon buttons to click on to toggle which meal to record
          crossAxisCount: 4,
          shrinkWrap: true,
          children: List.generate(mealList.length, (index) {
            // generates a flat button for each meal in the meal list
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(64.0)),
                // makes the InkWell ripples more circular to match the circular icon
                onPressed: () {
                  setState(() {
                    mealList.forEach((meal) {
                      // ensures that only one meal is selected. The one that is tapped gets selected and the others are deactivated
                      meal.mealType == mealList[index].mealType
                          ? meal.state = true
                          : meal.state = false;
                    });
                  });
                },
                child: Column(
                  children: <Widget>[
                    Image(
                      image: mealList[index]
                              .state // activates colored image if its state property is toggled true, black&white if false
                          ? AssetImage(
                              'graphics/${mealList[index].toString()}_colored.png')
                          : AssetImage(
                              'graphics/${mealList[index].toString()}_bw.png'),
                      width: 64.0,
                      height: 64.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                          '${ReCase(mealList[index].toString()).titleCase}'), // uses ReCase to convert from lowercase -> titleCase for formatting
                    ),
                  ],
                ),
              ),
            );
          }),
        ),

        Divider(),
        // Controls the date and time picker. Defaults to now. Can be changed with a tap.
        ListTile(
          leading: Icon(Icons.access_time),
          title: Text(
            'Time',
            style: Theme.of(context).textTheme.subhead,
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.access_time,
            color: Colors.white,
          ),
          title: Text('Thurs, Jan 24, 2019'),
          trailing: Text('9:37 PM'),
        ),

        Divider(),
        // Allows user to add notes
        ListTile(
          leading: Icon(Icons.subject),
          title: Text('Add note'),
        ),
      ],
    );
  }
}
