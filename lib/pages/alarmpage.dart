import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../models/alarmresult.dart';
import '../models/eventargs.dart';
import '../util/getit.dart';
import '../util/global.dart';
import '../widgets/advanced_datatable/advancedDataTableSource.dart';
import '../widgets/advanced_datatable/datatable.dart';

class AlarmPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AlarmPageState();
  }
}

class _AlarmPageState extends State<AlarmPage> {
  final datasource = AlarmDataSource();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('设备'),
        ),
        body: SafeArea(
            child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Column(
            children: [
              FormBuilder(
                key: _formKey,
                child: Row(children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'AlarmType',
                      decoration: const InputDecoration(
                        labelText: '告警类型',
                      ),
                      // initialValue: 'Male',
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      primary: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      _formKey.currentState!.save();
                      datasource.filterServerSide(
                        _formKey.currentState?.value['name'],
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.search_rounded),
                        SizedBox(width: 6),
                        Text('搜索'),
                      ],
                    ),
                  ),
                ]),
              ),
              Expanded(
                  child: SingleChildScrollView(
                      child: AdvancedPaginatedDataTable(
                dataRowHeight: 150,
                showCheckboxColumn: false,
                rowsPerPage: 5,
                columns: const [
                  DataColumn(label: Text('设备')),
                ],
                source: datasource,
              )))
            ],
          ),
        )));
  }
}

class AlarmDataSource extends AdvancedDataTableSource<AlramItem> {
  late BuildContext context;
  String? AlarmType = '';
  List<AlramItem> list = [];
  int _selectedCount = 0;
  List<String> selectedIds = [];

  void filterServerSide(String? AlarmType) {
    this.AlarmType = AlarmType;
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<AlramItem>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage

    var profile = getUserProfile();
    int page = (pageRequest.offset / pageRequest.pageSize).round();

    var param = {
      'limit': pageRequest.pageSize,
      'offset': page,
      'AlarmType': AlarmType ?? '',
      'OriginatorName': '',
      'OriginatorId': '00000000-0000-0000-0000-000000000000',
      'Name': '',
      'alarmStatus': '-1',
      'originatorType': '-1',
      'serverity': '-1'
    };

    var result = await getIt<Dio>()
        .post('${profile?.serverurl}/api/alarm/list', data: param);
    var data = AlramResult.fromJson(result.data);

    list = data.data?.rows ?? [];
    var rowCount = data.data?.total ?? 0;
    return RemoteDataSourceDetails(rowCount, list);
  }

  @override
  DataRow? getRow(int index) {
    if (index >= list.length) return null;

    final alarm = list[index];
    var originator = _getoriginatortype(alarm.originatorType);
    var serverityLevel = _getserverity(alarm.serverity);
    var status = _getalarmStatus(alarm.alarmStatus);
    // TODO: implement getRow
    return DataRow.byIndex(
      index: index,
      selected: alarm.selected ?? false,
      onSelectChanged: (value) {
        if (alarm.selected != value) {
          _selectedCount += value! ? 1 : -1;
          alarm.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Column(
            children: [
              CellHeader(
                item: alarm,
                onTap: cellToolPressed,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 1.0, vertical: 3.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: (status?.bgcolor??Colors.indigo),
                              ),
                              child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 2, 5, 2),
                                  child: Text(status?.title ?? '',
                                      style: TextStyle(
                                          color: status?.fontcolor)))),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: serverityLevel?.bgcolor,
                              ),
                              child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 2, 5, 2),
                                  child: Text(serverityLevel?.title ?? '',
                                      style: TextStyle(
                                          color: serverityLevel?.fontcolor)))),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: originator?.bgcolor,
                              ),
                              child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 2, 5, 2),
                                  child: Text(originator?.title ?? '',
                                      style: TextStyle(
                                          color: originator?.fontcolor))))
                        ],
                      ))
                    ],
                  )),
              Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 1.0, vertical: 3.0),
                  child: Row(
                    children: [
                      Text('创建时间:'),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                      ),
                      Expanded(
                          child: Text(alarm.startDateTime?.toString() ?? '')),
                    ],
                  )),
              CellTool(item: alarm, onPressed: cellToolPressed),
            ],
          ),
        )),
      ],
    );
  }

  CellSubItem? cellToolPressed(EventArgs args) {}

  CellSubItem? _getalarmStatus(String? alarmStatus) {
    switch (alarmStatus) {
      case 'Active_UnAck':
        return CellSubItem(
            title: '激活未应答',
            key: 'Active_UnAck',
            bgcolor: const Color.fromARGB(1, 255, 163, 158),
            fontcolor: Colors.white);
      case 'Active_Ack':
        return CellSubItem(
            title: '激活已应答',
            key: 'Active_Ack',
            bgcolor: const Color.fromARGB(1, 247, 89, 171),
            fontcolor: Colors.white);
      case 'Cleared_UnAck':
        return CellSubItem(
            title: '清除未应答',
            key: 'Cleared_UnAck',
            bgcolor: const Color.fromARGB(1, 255, 163, 158),
            fontcolor: Colors.white);
      case 'Cleared_Act':
        return CellSubItem(
            title: '清除已应答',
            key: 'Cleared_Act',
            bgcolor: const Color.fromARGB(1, 124, 179, 5),
            fontcolor: Colors.white);
    }
  }

  CellSubItem? _getserverity(String? alarmStatus) {
    switch (alarmStatus) {
      case 'Indeterminate':
        return CellSubItem(
            title: '不确定',
            key: 'Indeterminate',
            bgcolor: Colors.cyanAccent,
            fontcolor: Colors.white);
      case 'Warning':
        return CellSubItem(
            title: '警告',
            key: 'Warning',
            bgcolor: const Color.fromARGB(1, 250, 173, 20),
            fontcolor: Colors.white);
      case 'Minor':
        return CellSubItem(
            title: '次要',
            key: 'Minor',
            bgcolor: Colors.yellow,
            fontcolor: Colors.black);
      case 'Major':
        return CellSubItem(
            title: '重要',
            key: 'Major',
            bgcolor: Colors.blueAccent,
            fontcolor: Colors.white);
      case 'Critical':
        return CellSubItem(
            title: '错误',
            key: 'Critical',
            bgcolor: const Color.fromARGB(1, 245, 34, 45),
            fontcolor: Colors.white);
    }
  }

  _getoriginatortype(String? alarmStatus) {
    switch (alarmStatus) {
      case 'Unknow':
        return CellSubItem(
            title: '未知',
            key: 'Unknow',
            bgcolor: const Color.fromARGB(1, 255, 163, 158),
            fontcolor: Colors.white);
      case 'Device':
        return CellSubItem(
            title: '设备',
            key: 'Device',
            bgcolor: const Color.fromARGB(1, 247, 89, 171),
            fontcolor: Colors.white);
      case 'Gateway':
        return CellSubItem(
            title: '网关',
            key: 'Gateway',
            bgcolor: const Color.fromARGB(1, 255, 163, 158),
            fontcolor: Colors.white);
      case 'Asset':
        return CellSubItem(
            title: '资产',
            key: 'Asset',
            bgcolor: const Color.fromARGB(1, 124, 179, 5),
            fontcolor: Colors.white);
    }
  }

  @override
  int get selectedRowCount => selectedIds.length;
}

class CellHeader extends StatelessWidget {
  final ValueChanged<EventArgs> onTap;
  final AlramItem item;

  const CellHeader({
    required this.item,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        onTap: () {
          onTap(EventArgs(eventName: 'detail', item: item, context: context));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 3.0),
          child: Row(
            children: [
              Text('告警类型:'),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
              ),
              Text(item.alarmType ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ))
            ],
          ),
        ));
  }
}

class CellTool extends StatelessWidget {
  const CellTool({
    required this.item,
    required this.onPressed,
    super.key,
  });

  final AlramItem item;
  final ValueChanged<EventArgs> onPressed;

  @override
  Widget build(BuildContext context) {
    List<Widget> tools = [];

    switch (item.alarmStatus) {
      case 'Active_UnAck':
        tools = [
          OutlinedButton(
              onPressed: () {
                onPressed(EventArgs(
                    eventName: 'ackwarning', item: item, context: context));
              },
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  )),
                  side: MaterialStateProperty.all(
                    BorderSide(color: Colors.lime, width: 2.0),
                  )),
              child: const Text(
                '确认告警',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.lime,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              )),
          OutlinedButton(
              onPressed: () {
                onPressed(EventArgs(
                    eventName: 'claerwarning', item: item, context: context));
              },
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  )),
                  side: MaterialStateProperty.all(
                    BorderSide(color: Colors.lime, width: 2.0),
                  )),
              child: const Text(
                '清除告警',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.lime,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ))
        ];
        break;
      case 'Cleared_UnAck':
        tools = [
          OutlinedButton(
              onPressed: () {
                onPressed(EventArgs(
                    eventName: 'claerwarning', item: item, context: context));
              },
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  )),
                  side: MaterialStateProperty.all(
                    const BorderSide(color: Colors.lime, width: 2.0),
                  )),
              child: const Text(
                '清除告警',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.lime,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ))
        ];
        break;
    }

    // TODO: implement build
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 6.0),
        child: Row(
          children: tools,
        ));
  }
}

class CellSubItem {
  String title;
  String key;
  Color fontcolor;
  Color bgcolor;

  CellSubItem(
      {required this.title,
      required this.key,
      required this.fontcolor,
      required this.bgcolor});
}
