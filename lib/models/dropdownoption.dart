import 'package:equatable/equatable.dart';

class DropDownOption extends Equatable{
final  String text;
final  String value;
DropDownOption({required this.text,required this.value});
  @override
  // TODO: implement props
  List<Object?> get props => [text, value];

}


class DateTypeOption extends Equatable{
  final  String text;
  final  String value;
  DateTypeOption({required this.text,required this.value});
  @override
  // TODO: implement props
  List<Object?> get props => [text, value];

}
class DateSideOption extends Equatable{
  final  String text;
  final  String value;
  DateSideOption({required this.text,required this.value});
  @override
  // TODO: implement props
  List<Object?> get props => [text, value];

}

class DeviceTypeOption extends Equatable{
  final  String text;
  final  String value;
  DeviceTypeOption({required this.text,required this.value});
  @override
  // TODO: implement props
  List<Object?> get props => [text, value];

}
class IdentityTypeOption extends Equatable{
  final  String text;
  final  String value;
  IdentityTypeOption({required this.text,required this.value});
  @override
  // TODO: implement props
  List<Object?> get props => [text, value];

}

