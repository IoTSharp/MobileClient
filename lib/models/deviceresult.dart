import 'appresult.dart';

class  DeviceResult extends ApiResult {
  DeviceEntity? data;

  DeviceResult.fromJson(Map json)
      : data = DeviceEntity.fromJson(json['data']),
        super.fromJson(json);
}


class DeviceEntity{
  bool? hasNextPageData;
  int? total;
  List<DeviceItem>? rows;
  DeviceEntity.fromJson(Map json)
      : hasNextPageData = json['hasNextPageData'],
        total = json['total'],
        rows = (json['rows'] as List<dynamic>).map((e) => DeviceItem.fromJson(e)).toList();
}

class DeviceItem{
String? id;
String? customer;
String? deviceType;
String? identityId;
String? identityType;
String? identityValue;
String? lastActive;
String? name;
bool? online;
int? timeout;
bool? selected;
DeviceItem.fromJson(Map json)
    : id = json['id'],
      customer = json['customer'],
      deviceType = json['deviceType'],
      identityId = json['identityId'],
      identityType = json['identityType'],
      identityValue = json['identityValue'],
      lastActive = json['lastActive'],
      name = json['name'],
      online = json['online'],
      timeout = json['timeout'];

}