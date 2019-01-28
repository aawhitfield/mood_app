import 'package:flutter/material.dart';

class MedsWidget extends StatelessWidget {
  final Color color;

  MedsWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Med Entry',
        ),
        leading: GestureDetector(
          child: Icon(Icons.clear),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                  Icons.add,
                  color: Colors.white,
              ),
              onPressed: null)
        ],
      ),
      body: Container(
        color: color,
        child: Center(
          child: Text('Meds'),
        ),
      ),
    );
  }
}
