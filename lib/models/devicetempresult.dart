import 'appresult.dart';

class  DeviceTempResult extends ApiResult {
  List<DeviceTempItem> data=[];

  DeviceTempResult.fromJson(Map json)
      : data =(json['data'] as List<dynamic>).map((e) => DeviceTempItem.fromJson(e)).toList(),
        super.fromJson(json);
}


class DeviceTempItem{
  String? dataSide;
  String?  dataType;
  String?  dateTime;
  String?  keyName;
  String?  value;
  DeviceTempItem.fromJson(Map json)
      : dataSide = json['dataSide'],
        dataType = json['dataType'],
        dateTime = json['dateTime'],
        keyName = json['keyName'],
        value = json['value']?.toString()??''
  ;
}
