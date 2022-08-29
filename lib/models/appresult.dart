class ApiResult{
  int? code;
  String? msg;
  ApiResult.fromJson(Map json)
      : code = json['code'],
        msg = json['msg'];
}



