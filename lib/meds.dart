import 'package:flutter/material.dart';




class MedsWidget extends StatelessWidget {
  final Color color;

  MedsWidget(this.color);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text('Meds'),
      ),
    );
  }
}