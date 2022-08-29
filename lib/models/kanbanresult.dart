import 'appresult.dart';

class  KanbanResult extends ApiResult {
  KanbanEndity? data;

  KanbanResult.fromJson(Map json)
      : data = KanbanEndity.fromJson(json['data']),
        super.fromJson(json);
}


class KanbanEndity{
  int deviceCount;
  int eventCount;
  int telemetryDataCount;
  int onlineDeviceCount;
  KanbanEndity.fromJson(Map json)
      : deviceCount = json['deviceCount'],
        eventCount = json['eventCount'],
        telemetryDataCount = json['telemetryDataCount'],
        onlineDeviceCount = json['onlineDeviceCount'];

}