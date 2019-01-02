import 'package:flutter/material.dart';




class MealsWidget extends StatelessWidget {
  final Color color;

  MealsWidget(this.color);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text('Meals'),
 ),
    );
  }
}