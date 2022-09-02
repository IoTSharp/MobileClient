import 'appresult.dart';

class  AlramResult extends ApiResult {
  AlramEntity? data;

  AlramResult.fromJson(Map json)
      : data = AlramEntity.fromJson(json['data']),
        super.fromJson(json);
}


class AlramEntity{
  bool? hasNextPageData;
  int? total;
  List<AlramItem>? rows;
  AlramEntity.fromJson(Map json)
      : hasNextPageData = json['hasNextPageData'],
        total = json['total'],
        rows = (json['rows'] as List<dynamic>).map((e) => AlramItem.fromJson(e)).toList();
}

class AlramItem{
  String? id;
  String? ackDateTime;
  String? alarmDetail;
  String? alarmStatus;
  String? alarmType;
  String? clearDateTime;
  String? endDateTime;
  dynamic? originator;
  String? originatorId;
  String? originatorType;
  bool? propagate;
  String? serverity;
  String? startDateTime;

  bool? selected;
  AlramItem.fromJson(Map json)
      : id = json['id'],
        ackDateTime = json['ackDateTime'],
        alarmDetail = json['alarmDetail'],
        alarmStatus = json['alarmStatus'],
        alarmType = json['alarmType'],
        clearDateTime = json['clearDateTime'],
        endDateTime = json['endDateTime'],
        originator = json['originator'],
        originatorId = json['originatorId'],
        originatorType = json['originatorType'],
        propagate = json['propagate'],
        serverity = json['serverity'],
        startDateTime = json['startDateTime']
  ;

}