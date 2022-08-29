import 'package:event_bus/event_bus.dart';
import '../main.dart';
import 'getit.dart';

AddEventBus(){
  getIt.registerSingleton<EventBus>(EventBus(),
      signalsReady: true);
}