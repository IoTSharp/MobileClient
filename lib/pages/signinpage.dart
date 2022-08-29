// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unnecessary_this, prefer_final_fields

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iotsharp/database/iot.dart';
import 'package:iotsharp/models/userprofile.dart';
import '../models/myinforesult.dart';
import '../models/signinresult.dart';
import '../util/getit.dart';
import '../util/global.dart';



// http://139.9.232.10:2927
// iotmaster@iotsharp.net
// P@ssw0rd
class SignInPage extends StatefulWidget {
  String title = '登录';
  final TextEditingController serverController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController( text: 'P@ssw0rd');

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignInState(
        serverController: serverController,
        usernameController: usernameController,
        passwordController: passwordController);
  }
}

class _SignInState extends State<SignInPage> {
  var icon = const Icon(Icons.info_outline, color: Color(0xFFFFFFFF));
  var success =
      const Icon(Icons.check_circle_outline, color: Color(0xFF09AF79));
  var failure = const Icon(Icons.error_outline, color: Color(0xFFEF6526));
  String? passwordErrorMsg;
  String? usernameErrorMsg;
  final TextEditingController serverController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  FocusNode serverfocusNode = FocusNode();
  FocusNode usernamfocusNode = FocusNode();
  FocusNode passwordfocusNode = FocusNode();

  _SignInState(
      {required this.serverController,
      required this.usernameController,
      required this.passwordController}) {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Future.delayed(Duration.zero, () {
      if (getUserProfile() != null) {
        Navigator.of(context).pushNamed('/');
      }
    });
    return Scaffold(
        appBar: AppBar(title: Text('登录')),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage('assets/images/iotsharp.png'))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60.0, vertical: 60.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                  )),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      OrientationBuilder(builder: (context, orientation) {
                        return MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? Container(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 10),
                                child: Text('',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w700)))
                            : const SizedBox(
                                width: 0,
                              );
                      }),
                      TextField(
                        textInputAction: TextInputAction.next,
                        onChanged: (text) {
                          if (text != '') {
                            this.setState(() {
                              usernameErrorMsg = null;
                            });
                          }
                        },
                        controller: serverController,
                        focusNode: usernamfocusNode,
                        decoration: InputDecoration(
                            labelText: '服务器', errorText: usernameErrorMsg
                            //  labelText: GalleryLocalizations.of(context).rallyLoginUsername,
                            ),
                      ),
                      TextField(
                        textInputAction: TextInputAction.next,
                        onChanged: (text) {
                          if (text != '') {
                            this.setState(() {
                              usernameErrorMsg = null;
                            });
                          }
                        },
                        controller: usernameController,
                        focusNode: serverfocusNode,
                        decoration: InputDecoration(
                            labelText: '用户名', errorText: usernameErrorMsg
                            //  labelText: GalleryLocalizations.of(context).rallyLoginUsername,
                            ),
                      ),
                      Container(
                        child: TextField(
                          onChanged: (text) {
                            if (text != '') {
                              this.setState(() {
                                passwordErrorMsg = null;
                              });
                            }
                          },
                          controller: passwordController,
                          focusNode: passwordfocusNode,
                          decoration: InputDecoration(
                              labelText: '密码', errorText: passwordErrorMsg),
                          obscureText: true,
                        ),
                      ),
                      Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(20, 30, 20, 20),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: signInSync,
                              child: Text('登录'),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor)),
                            ),
                          )),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future<void> signInSync() async {
    var signresultjson = await getIt<Dio>().post('${serverController.value.text}/api/Account/Login',
        data: {'password':passwordController.value
            .text, 'userName': usernameController.value.text});
   if(signresultjson.data['data']!=null){
     var sr = SignInResult.fromJson(signresultjson.data);
     if (signresultjson.data!=null&&sr.code == 10000) {
       getIt<Dio>().options.headers.addAll(
           {'Authorization': 'Bearer ${sr.data?.token?.access_token ?? ''}'});
       var myinfojson =
       await getIt<Dio>().get('${serverController.value.text}/api/Account/MyInfo');
       var myinfo = MyInfoResult.fromJson(myinfojson.data);
       UserProfile profile = UserProfile();
       profile.serverurl=serverController.value.text;
       profile.token = sr.data?.token?.access_token;
       profile.refreshtoken = sr.data?.token?.refresh_token;
       profile.tenant = myinfo.data?.tenant?.id ?? '';
       profile.comstomer = myinfo.data?.customer?.id ?? '';
       saveUserProfile(profile);
       getIt<IOTDatabase>().CreateProfile(IotSharpProfileCompanion(
         serverurl:drift.Value(serverController.text),
         username: drift.Value(usernameController.text),
         token: drift.Value(profile.token),
       ));

       Navigator.of(context).pushNamed('/');


     }  else{
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('用户名或者密码不正确')));

     }
   }
    else{
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('用户名或者密码不正确')));

    }
  }

  // void signIn() {
  //   var result = getIt<Dio>().post(
  //       '${serverController.value.text}/api/Account/Login',
  //       data: {
  //         'password': 'P@ssw0rd',
  //         'userName': 'iotmaster@iotsharp.net'
  //       }).then((x) {
  //     var d = SignInResult.fromJson(x.data);
  //     if (d.code == 10000) {
  //       getIt<Dio>().options.headers.addAll(
  //           {'Authorization': 'Bearer ${d.data?.token?.access_token ?? ''}'});
  //       UserProfile profile = UserProfile();
  //       profile.token = d.data?.token?.access_token;
  //       saveUserProfile(profile);
  //       getIt<IOTDatabase>().CreateProfile(IotSharpProfileCompanion(
  //           serverurl:drift.Value(serverController.text),
  //           username: drift.Value(usernameController.text),
  //           token: drift.Value(profile.token),
  //       ));
  //
  //       //      Navigator.of(context).pushNamed('/');
  //       Navigator.of(context, rootNavigator: false)
  //           .push(MaterialPageRoute(builder: (BuildContext context) {
  //         return MyHomePage(
  //           title: 'IotSharp',
  //         );
  //       }));
  //     }
  //   });
  // }

  void onTap() {}

  @override
  void initState() {


    getIt<IOTDatabase>().GetProfile().then((value) {
      if(value==null){

      }else{
        this.serverController.text=value.serverurl??'';
        this.usernameController.text=value.username??'';

      }

    });
    // this._passwordfocusNode.addListener(() {
    //   if (msg != '') {
    //     this.setState(() {
    //       icon = Icon(Icons.info_outline, color: Color(0xFFFFFFFF));
    //       msg = '';
    //     });
    //   }
    // });
    //
    // this._usernamfocusNode.addListener(() {
    //   if (msg != '') {
    //     this.setState(() {
    //       icon = Icon(Icons.info_outline, color: Color(0xFFFFFFFF));
    //       msg = '';
    //     });
    //   }
    // });

    super.initState();
  }
}
