import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iotsharp/util/getit.dart';
import 'package:iotsharp/util/global.dart';


import '../models/kanbanresult.dart';

class HomePage extends StatefulWidget {
  String title = 'IotSharp';
  static const androidIcon = Icon(Icons.library_books);
  static const iosIcon = Icon(CupertinoIcons.home);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  KanbanResult? kanban;
  @override
  Widget build(context) {
    getUserProfile();

    return Scaffold(
      appBar: AppBar(
        title: Text('IotSharp'),
      ),
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.lightGreen,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${kanban?.data?.deviceCount}',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .headline2,
                                    ),
                                    Text('所有设备')
                                  ],
                                ),
                              )),
                        ),
                        const VerticalDivider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 20,
                          endIndent: 0,
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.deepOrangeAccent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${kanban?.data?.onlineDeviceCount}',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headline2,
                                  ),
                                  Text('在线设备')
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                const Divider(
                  color: Colors.grey,
                  height: 20,
                  thickness: 1,
                  indent: 20,
                  endIndent: 0,
                ),
                Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.deepPurpleAccent,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${kanban?.data?.eventCount}',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .headline2,
                                    ),
                                    Text('事件')
                                  ],
                                ),
                              )),
                        ),
                        const VerticalDivider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 20,
                          endIndent: 0,
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.redAccent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${kanban?.data?.telemetryDataCount}',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headline2,
                                  ),
                                  Text('遥测')
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            )),
      ),
    );
  }

  @override
  void initState() {
    getdata();
  }

  void getdata() {
    var profile = getUserProfile();
    getIt<Dio>().get(
        '${profile?.serverurl}/api/home/kanban').then((value) {


        setState(() {
          kanban = KanbanResult.fromJson(value.data);
        });
    });
  }

}
