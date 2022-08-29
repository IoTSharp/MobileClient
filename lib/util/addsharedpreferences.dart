import 'package:shared_preferences/shared_preferences.dart';

import 'getit.dart';

AddSharedPreferences() async {
  getIt.registerSingleton<SharedPreferences>(await SharedPreferences.getInstance(),
      signalsReady: true);
}
