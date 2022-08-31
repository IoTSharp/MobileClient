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
        appBar:AppBar(title: Text('设置'),),
        body:Padding(
    padding: const EdgeInsets.all(10),
    child: Column(children: [SetttingOption(),SetttingOption(),SetttingOption()],),
    )

    );
  }

}



class SetttingOption extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      // Makes integration tests possible.

      color: Theme.of(context).colorScheme.surface,
      child: MergeSemantics(
        child: InkWell(
          onTap: () {

          },
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: 32,
              top: 20,
              end:8,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.abc_sharp,
                  color:Colors.deepPurple,
                ),
                const SizedBox(width: 40),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'aaaaa',
                        style: TextStyle(),
                      ),
                      Text(
                        'bbbb',
                        style: TextStyle(),

                      ),
                      const SizedBox(height: 20),
                      Divider(
                        thickness: 1,
                        height: 1,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}