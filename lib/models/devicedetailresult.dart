import 'appresult.dart';
import 'deviceresult.dart';

class DeviceDetailResult extends ApiResult {

  DeviceItem? data;
  DeviceDetailResult.fromJson(Map json)
      : data = DeviceItem.fromJson(json['data']),
        super.fromJson(json);



}