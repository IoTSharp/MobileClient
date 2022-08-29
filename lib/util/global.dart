import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:jaguar/jaguar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/iot.dart';
import '../main.dart';
import '../models/userprofile.dart';
import 'getit.dart';

saveUserProfile(UserProfile  profile) {
  getIt<SharedPreferences>().setString('userProfile',jsonEncode(profile));
}

UserProfile? getUserProfile(){
 var userProfile= getIt<SharedPreferences>().getString('userProfile');
 if(userProfile!=null){
   return UserProfile.fromJson(jsonDecode(userProfile));
 }
 return null;
}













