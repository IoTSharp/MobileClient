import 'package:event_bus/event_bus.dart';
import 'package:jaguar/jaguar.dart';

import '../main.dart';
import 'getit.dart';

AddJaguar() async {
  var jaguar=Jaguar(port: 2927);
  getIt.registerSingleton<Jaguar>(jaguar,
      signalsReady: true);
  jaguar.get('/i', (context){
    //Fire Events
    getIt<EventBus>().fire('testhttp request');


//Register listeners
    // getIt<EventBus>().on<T>().listen((event) {
    //
    //   print(event);
    // });
    //
  });
 await jaguar.serve();
}