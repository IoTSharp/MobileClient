import 'appresult.dart';

class SignInResult extends ApiResult {
  SignInEntity? data;

  SignInResult.fromJson(Map json)
      : data = SignInEntity.fromJson(json['data']),
        super.fromJson(json);
}

class SignInEntity {
  String? userName;
  Token? token;
  List<String>? roles;
  String? avatar;

  SignInEntity.fromJson(Map json)
      : userName = json['userName'],
        token = Token.fromJson(json['token']),
        roles = List<String>.from(json['roles']),
        avatar = json['avatar'];
}

class Token {
  String? access_token;
  int? expires_in;
  String? refresh_token;
  String? expires;

  Token.fromJson(Map json)
      : access_token = json['access_token'],
        expires_in = json['expires_in'],
        refresh_token = json['refresh_token'],
        expires = json['expires'];
}
