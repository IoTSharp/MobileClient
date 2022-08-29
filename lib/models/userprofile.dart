class UserProfile{


  UserProfile();

  String? comstomer;
  String? appName;
  String? email;
  String? tenant;
  String? username;
  String? token;
  String? refreshtoken;
  String? serverurl;
  UserProfile.fromJson(Map json)
      : comstomer = json['comstomer'],
        appName =json['appName'],
        email =  json['email'],
        tenant =  json['tenant'],
        username =  json['username'],
        token =  json['token'],
        refreshtoken =  json['refreshtoken'],
        serverurl =  json['serverurl'];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'comstomer': comstomer,
    'appName': appName,
    'email': email,
    'tenant': tenant,
    'username': username,
    'token': token,
    'refreshtoken': refreshtoken,
    'serverurl': serverurl,
  };
}