import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
      title: Text('Credits Page'),
    ),
      body: Center(
        child: Text('Meal Icons made by Freepik from www.flaticon.com'),
      ),
    );
  }
}

