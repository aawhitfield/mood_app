import 'package:flutter/material.dart';
import 'main.dart';




class MealsWidget extends StatefulWidget {
  final MyHomePageState parent;

  MealsWidget(this.parent);

  @override
  MealsWidgetState createState() {
    return new MealsWidgetState();
  }
}

class MealsWidgetState extends State<MealsWidget> {
  @override
  Widget build(BuildContext context) {


    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
              'Meals',
              style: Theme.of(context).textTheme.headline,
          ),

          IconButton(
            icon: Image(
              image: AssetImage(
                  widget.parent.colored ? 'graphics/breakfast_colored.png' : 'graphics/breakfast_bw.png',
                  ),
               ),
            iconSize: 64.0,
            onPressed: () {
              setState((){
                widget.parent.colored ? widget.parent.colored = false : widget.parent.colored = true;
              });
    }

            ),

          Text('Breakfast'),
        ],
      ),
    );
  }
}