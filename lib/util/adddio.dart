import 'package:dio/dio.dart';

import '../main.dart';
import 'getit.dart';

AddDio(){
  var dio=Dio();
  dio.options.headers.addAll({'User-Agent':'IotSharp-Dart-Client'});
  getIt.registerSingleton<Dio>(dio,
      signalsReady: true);
// register interceptor
 // dio.interceptors.add(element)
}