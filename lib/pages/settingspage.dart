import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  String title = 'IotSharp';
  static const androidIcon = Icon(Icons.library_books);
  static const iosIcon = Icon(CupertinoIcons.home);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingsPagePageState();
  }
}

class _SettingsPagePageState extends State<SettingsPage> {

  @override
  Widget build(context) {

    return Scaffold(
        appBar:AppBar(title: Text('list'),)

    );
  }

}