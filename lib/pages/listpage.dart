// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:iotsharp/util/global.dart';

import '../models/deviceresult.dart';
import '../util/getit.dart';
import '../widgets/advanced_datatable/advancedDataTableSource.dart';
import '../widgets/advanced_datatable/datatable.dart';
import 'device/devicepannel.dart';

class ListPage extends StatefulWidget {
  String title = 'IotSharp';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListPageState();
  }
}

class _ListPageState extends State<ListPage> {
  final datasource = DeviceDataSource();
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
                      name: 'name',
                      decoration: const InputDecoration(
                        labelText: '设备名称',
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

  @override
  void initState() {
    if (mounted) {
      getIt<EventBus>().on<String>().listen((event) {
        // All events are of type UserLoggedInEvent (or subtypes of it).
        print(event);
      });
    }
  }
}

class DeviceDataSource extends AdvancedDataTableSource<DeviceItem> {
  late BuildContext context;
  String? name = '';
  List<DeviceItem> list = [];
  int _selectedCount = 0;
  List<String> selectedIds = [];

  void filterServerSide(String? Name) {
    name = Name;
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<DeviceItem>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage

    var profile = getUserProfile();
    int page = (pageRequest.offset / pageRequest.pageSize).round();
    var result = await getIt<Dio>().get(
        '${profile?.serverurl}/api/Devices/Customers?offset=${page}&limit=5&pi=0&ps=${pageRequest.pageSize}&sorter=&customerId=${profile?.comstomer}&name=${name}&sort=');
    var data = DeviceResult.fromJson(result.data);
    list = data.data?.rows ?? [];
    var rowCount = data.data?.total ?? 0;
    return RemoteDataSourceDetails(rowCount, list);
  }

  void selectedRow(String id, bool newSelectState) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= list.length) return null;

    final device = list[index];
    // TODO: implement getRow
    return DataRow.byIndex(
      index: index,
      selected: device.selected ?? false,
      onSelectChanged: (value) {
        if (device.selected != value) {
          _selectedCount += value! ? 1 : -1;
          device.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Column(
            children: [
              CellHeader(item: device, onTap: cellToolPressed),
              Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 1.0, vertical: 3.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Text('认证方式:'),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: (device.identityType == 'AccessToken')
                                    ? Colors.deepPurple
                                    : Colors.orangeAccent,
                              ),
                              child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 2, 5, 2),
                                  child: Text(
                                    device.identityType ?? '',
                                    style: TextStyle(color: Colors.white),
                                  )))
                        ],
                      )),

                      Expanded(child: Row( children: [ Text('在线状态:'), Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: (device.online ?? false)
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          ),
                          child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5, 2, 5, 2),
                              child:
                              Text((device.online ?? false) ? '在线' : '离线')))
                       ],) )
                     ,

                    ],
                  )),
              Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 1.0, vertical: 3.0),
                  child: Row(
                    children: [
                      Text('最后活动时间:'),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                      ),
                      Expanded(
                          child: Text(device.lastActive?.toString() ?? '')),
                    ],
                  )),
              CellTool(item: device, onPressed: cellToolPressed),
            ],
          ),
        )),
      ],
    );
    //lastDetails!.rows[index].getRow(selectedRow, selectedIds);
  }

  cellToolPressed(EventArgs args) {
    switch (args.eventName) {
      case 'edit':
        setNextView();
        break;
      case 'delete':
        setNextView();
        break;
      case 'proptityedit':
        break;
      case 'gettoken':
        Clipboard.setData(ClipboardData(text:args.item.identityId??'' ));
        ScaffoldMessenger.of(args.context).showSnackBar(SnackBar(content: Text('token: ${args.item.identityId??''} 已复制到剪贴板')));


        break;

      case 'detail':
        Navigator.of(args.context, rootNavigator: true).push(
          CupertinoPageRoute<bool>(
            fullscreenDialog: true,
            builder: (BuildContext context) => DevicePanel(
              DeviceId: args.item.id ?? '',
            ),
          ),
        );
        break;
    }
  }

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => selectedIds.length;
}

class CellHeader extends StatelessWidget {
  final ValueChanged<EventArgs> onTap;
  final DeviceItem item;

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
              Text('设备名称:'),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
              ),
              Text(
                item.name ?? '',
                style: TextStyle(
                    fontSize: 16,
                    color: (item.online ?? false)
                        ? Colors.green
                        : Colors.redAccent),
              )
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

  final DeviceItem item;
  final ValueChanged<EventArgs> onPressed;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 6.0),
        child: Row(
          children: [
            OutlinedButton(
                onPressed: () {
                  onPressed(EventArgs(
                      eventName: 'edit', item: item, context: context));
                },
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    )),
                    side: MaterialStateProperty.all(
                      BorderSide(color: Colors.indigoAccent, width: 2.0),
                    )),
                child: Text(
                  '修改',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
            ),
            OutlinedButton(
                onPressed: () {
                  onPressed(EventArgs(
                      eventName: 'delete', item: item, context: context));
                },
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    )),
                    side: MaterialStateProperty.all(
                      BorderSide(color: Colors.red, width: 2.0),
                    )),
                child: Text(
                  '删除',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
            ),
            OutlinedButton(
                onPressed: () {
                  onPressed(EventArgs(
                      eventName: 'proptityedit', item: item, context: context));
                },
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    )),
                    side: MaterialStateProperty.all(
                      BorderSide(color: Colors.teal, width: 2.0),
                    )),
                child: Text(
                  '属性修改',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.teal,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
            ),
            OutlinedButton(
                onPressed: () {
                  onPressed(EventArgs(
                      eventName: 'gettoken', item: item, context: context));
                },
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    )),
                    side: MaterialStateProperty.all(
                      BorderSide(color: Colors.lime, width: 2.0),
                    )),
                child: Text(
                  '获取Token',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.lime,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ))
          ],
        ));
  }
}

class EventArgs {
  const EventArgs(
      {required this.eventName, required this.item, required this.context});

  final BuildContext context;
  final DeviceItem item;
  final String eventName;
}
