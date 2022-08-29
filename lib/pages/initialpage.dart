import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlarmPage extends StatefulWidget {
  String title = 'IotSharp';
  static const androidIcon = Icon(Icons.library_books);
  static const iosIcon = Icon(CupertinoIcons.home);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AlarmPageState();
  }
}

class _AlarmPageState extends State<AlarmPage> {
  TextEditingController _usernameController = new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();
  @override
  Widget build(context) {


    var initialform=Expanded(
      flex: 2,
      child: Padding(
        padding:
        EdgeInsetsDirectional.fromSTEB(0, 10, 10, 0),
        child: TextFormField(
          controller: _usernameController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            // border: OutlineInputBorder(),
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.all(6),
              labelText: "卡箱1卡箱号",
              hintText: "请输入卡箱1卡箱号",
              prefixIcon: Icon(
                Icons.credit_card,
                color: Colors.blueAccent,
              )),
          validator: (value) {
            RegExp reg = new RegExp(r'^\d+$');
            if (!reg.hasMatch(value ?? '')) {
              return '卡箱号不正确';
            }
            return null;
          },
          onSaved: (value) {

          },
        ),
      ),
    );

    return Scaffold(


    );
  }
}

