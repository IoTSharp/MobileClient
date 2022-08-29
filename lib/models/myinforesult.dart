import 'appresult.dart';

class  MyInfoResult extends ApiResult {
  MyInfoEntity? data;

  MyInfoResult.fromJson(Map json)
      : data = MyInfoEntity.fromJson(json['data']),
        super.fromJson(json);
}

class MyInfoEntity {
  int? code;
  String? roles;
  String? avatar;
  String? name;
  String? introduction;
  String? phoneNumber;
  String? email;
  Customer? customer;
  Tenant? tenant;
  MyInfoEntity.fromJson(Map json)
      : code = json['code'],
        roles = json['roles'],
        avatar = json['avatar'],
        name = json['name'],
        introduction = json['introduction'],
        phoneNumber = json['phoneNumber'],
        email = json['email'],
        customer = Customer.fromJson(json['customer']),
        tenant = Tenant.fromJson(json['tenant']);
}



class Customer {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? country;
  String? province;
  String? city;
  String? street;
  String? address;
  int? zipCode;
  Customer.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        phone = json['phone'],
        country = json['country'],
        province = json['province'],
        city = json['city'],
        street = json['street'],
        address = json['address'],
        zipCode = json['zipCode']
  ;
}

class Tenant {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? country;
  String? province;
  String? city;
  String? street;
  String? address;
  int? zipCode;
  Tenant.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        phone = json['phone'],
        country = json['country'],
        province = json['province'],
        city = json['city'],
        street = json['street'],
        address = json['address'],
        zipCode = json['zipCode']
  ;
}
