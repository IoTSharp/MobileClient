// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../models/deviceattrresult.dart';
import '../../models/devicedetailresult.dart';

import '../../models/devicetempresult.dart';
import '../../util/getit.dart';
import '../../util/global.dart';

class DevicePanel extends StatefulWidget {
  DevicePanel({required this.DeviceId});

  final String DeviceId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DevicePanelState(DeviceId: this.DeviceId);
  }
}

class _DevicePanelState extends State<DevicePanel> {
  final String DeviceId;

  DeviceDetailResult? deviceinfo;
  List<DeviceAttrItem> deviceattrs = [];
  List<DeviceTempItem> devicetemps = [];

  _DevicePanelState({required this.DeviceId});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设备详情'),
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            DeviceBaseInfo(deviceinfo: this.deviceinfo),
            DeviceAttr(deviceattrs: this.deviceattrs),
            DeviceTemp(devicetemps: this.devicetemps),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    var profile = getUserProfile();




    getIt<Dio>()
        .get('${profile?.serverurl}/api/Devices/${this.DeviceId}')
        .then((device) {
      setState(() {
        this.deviceinfo = DeviceDetailResult.fromJson(device.data);
      });
    });

    getIt<Dio>()
        .get(
            '${profile?.serverurl}/api/Devices/${this.DeviceId}/AttributeLatest')
        .then((data) {
      setState(() {
        this.deviceattrs = DeviceAttrResult.fromJson(data.data).data;
      });
    });

    getIt<Dio>()
        .get(
            '${profile?.serverurl}/api/Devices/${this.DeviceId}/TelemetryLatest')
        .then((data) {
      setState(() {
        this.devicetemps = DeviceTempResult.fromJson(data.data).data;
      });
    });
  }
}

class DeviceBaseInfo extends StatelessWidget {
  DeviceBaseInfo({required this.deviceinfo});

  DeviceDetailResult? deviceinfo;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 10),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '设备信息',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '设备Id:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            deviceinfo?.data?.id ?? '',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '设备名称:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            deviceinfo?.data?.name ?? '',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '最后活动时间:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            '',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '类型:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            '',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DeviceAttr extends StatelessWidget {
  List<DeviceAttrItem> deviceattrs = [];

  DeviceAttr({required this.deviceattrs});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Card(
          child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 10),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    child: Text(
                      '设备属性',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                      child: ListView(
                    controller: ScrollController(),
                    children: [
                      for (int index = 0; index < deviceattrs.length; index++)
                        ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                  child: Text(deviceattrs[index].keyName ?? '',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left)),
                              Expanded(
                                  child: Text(
                                deviceattrs[index].value ?? '',
                                style: TextStyle(),
                                textAlign: TextAlign.right,
                              ))
                            ],
                          ),
                        ),
                    ],
                  ))
                ],
              )),
        ));
  }
}

class DeviceTemp extends StatelessWidget {
  DeviceTemp({required this.devicetemps});

  List<DeviceTempItem> devicetemps = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Card(
          child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 10),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    child: Text(
                      '设备遥测',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                      child: ListView(
                    controller: ScrollController(),
                    children: [
                      for (int index = 0; index < devicetemps.length; index++)
                        ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                  child: Text(devicetemps[index].keyName ?? '',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left)),
                              Expanded(
                                  child: Text(
                                devicetemps[index].value ?? '',
                                style: TextStyle(),
                                textAlign: TextAlign.right,
                              ))
                            ],
                          ),
                        ),
                    ],
                  ))
                ],
              )),
        ));
  }
}
