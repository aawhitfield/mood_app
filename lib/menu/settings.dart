import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Settings Page'),
        leading: GestureDetector(
          child: Icon(Icons.clear),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text('Settings'),
      ),
    );
  }
}

