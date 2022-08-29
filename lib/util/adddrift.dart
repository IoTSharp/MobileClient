import '../database/iot.dart';
import 'getit.dart';

AddDrift(){
  getIt.registerSingleton<IOTDatabase>(IOTDatabase(),
      signalsReady: true);
}