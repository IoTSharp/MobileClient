import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:iotsharp/pages/signinpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/alarmpage.dart';
import 'pages/homepage.dart';
import 'pages/listpage.dart';
import 'pages/settingspage.dart';
import 'util/adddio.dart';
import 'util/adddrift.dart';
import 'util/addeventbus.dart';
import 'util/addjaguar.dart';
import 'util/addsharedpreferences.dart';
import 'util/getit.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AddSharedPreferences();
  AddEventBus();
  AddDrift();
  AddDio();
  await AddJaguar();
  getIt<SharedPreferences>().clear();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IotSharp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute:'/',
      // routes: {
      //   '/':(context) =>const MyHomePage(title:'IotSharp' ),
      //   '/SignIn':(context) =>SignInPage()
      //
      // },
        onGenerateRoute:onGenerateRoute,
    );
  }
}

Route<dynamic> onGenerateRoute(RouteSettings settings){
  String routeName;
  routeName = routeBeforeHook(settings);
  return MaterialPageRoute(builder: (context) {

    switch (routeName) {
      case "/":
        return MyHomePage(title:'Iotshap');
      case "/SignIn":
        return SignInPage();
      default:
        return Scaffold(
          body: Center(
            child: Text("页面不存在"),
          ),
        );
    }
  });


}
String routeBeforeHook(RouteSettings settings) {
  final userProfile =   getIt<SharedPreferences>().getString('userProfile') ?? '';
  if (userProfile != '') {
    if (settings.name == '/SignIn') {
      return '/';
    }
    return settings.name??'/';
  }else{
    return '/SignIn';
  }

}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CupertinoTabController controller = CupertinoTabController();
  _NotifyObject _object = _NotifyObject(TabIndex: 0);



  @override
  Widget build(BuildContext context) {



    return _buildHomePage(context);
  }

  Widget _buildHomePage(BuildContext context) {


    return InheritedContext(
      NotifyObject: this._object,
      child: CupertinoTabScaffold(
        controller: controller,
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(
              label: '首页',
              icon: Icon(CupertinoIcons.home),
            ),
            BottomNavigationBarItem(
              label: '设备',
              icon: Icon(Icons.memory_sharp),
            ),
            BottomNavigationBarItem(
              label: '告警',
              icon: Icon(CupertinoIcons.antenna_radiowaves_left_right),
            ),
            BottomNavigationBarItem(
              label: '设置',
              icon: Icon(CupertinoIcons.settings_solid),
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                defaultTitle: '首页',
                builder: (context) => HomePage(),
                // builder: (context) => LossCard(),
              );
            case 1:
              return CupertinoTabView(
                defaultTitle: '设备',
                builder: (context) => ListPage(),
              );

            case 2:
              return CupertinoTabView(
                defaultTitle: '告警',
                builder: (context) => AlarmPage(),
              );
            case 3:
              return CupertinoTabView(
                defaultTitle: '设置',
                builder: (context) => SettingsPage(),
              );
            default:
              assert(false, 'Unexpected tab');
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  void initState() {



  }
}

class _NotifyObject {
  _NotifyObject({required this.TabIndex}) {}
  int TabIndex;
}

class InheritedContext extends InheritedWidget {
  final _NotifyObject NotifyObject;

  InheritedContext(
      {required this.NotifyObject, required Widget child, Key? key})
      : super(key: key, child: child);

  static InheritedContext? of(BuildContext context) {
    InheritedWidget? contexts =
        context.dependOnInheritedWidgetOfExactType(aspect: InheritedContext);
    return context.dependOnInheritedWidgetOfExactType<InheritedContext>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return NotifyObject != NotifyObject;
  }
}
