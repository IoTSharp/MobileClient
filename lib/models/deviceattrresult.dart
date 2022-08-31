import 'appresult.dart';

class  DeviceAttrResult extends ApiResult {
  List<DeviceAttrItem> data=[];

  DeviceAttrResult.fromJson(Map json)
      : data =(json['data'] as List<dynamic>).map((e) => DeviceAttrItem.fromJson(e)).toList(),
        super.fromJson(json);
}


class DeviceAttrItem{


  String? dataSide;
  String?  dataType;
  String?  dateTime;
  String?  keyName;
  dynamic?  value;
  DeviceAttrItem.fromJson(Map json)
      : dataSide = json['dataSide'],
        dataType = json['dataType'],
        dateTime = json['dateTime'],
        keyName = json['keyName'],
        value = json['value']?.toString()??''
        ;
}


