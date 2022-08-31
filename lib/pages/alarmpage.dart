import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlarmPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AlarmPageState();
  }
}

class _AlarmPageState extends State<AlarmPage> {

  @override
  Widget build(context) {

    return Scaffold(
        appBar:AppBar(title: Text('alarm'),)

    );
  }
}

