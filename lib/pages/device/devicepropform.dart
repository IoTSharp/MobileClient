import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/deviceattrresult.dart';
import '../../util/getit.dart';
import '../../util/global.dart';
import '../../widgets/customfloatingactionbutton/customfloatingactionbuttonlocation.dart';

class DevicePropForm extends StatefulWidget {
  DevicePropForm({required this.DeviceId});

  final String DeviceId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DevicePropFormState(DeviceId: DeviceId);
  }
}

class _DevicePropFormState extends State<DevicePropForm> {
  _DevicePropFormState({required this.DeviceId});

  final String DeviceId;

  final _formKey = GlobalKey<FormBuilderState>();
  List<DeviceAttrItem> deviceattrs = [];

  List<DeviceAttrItem> serverside = [];
  List<DeviceAttrItem> clientside = [];
  List<DeviceAttrItem> anyside = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: const Text('属性修改')),
        floatingActionButtonLocation: CustomFloatingActionButtonLocation(
            FloatingActionButtonLocation.endFloat, 0, -50),
        floatingActionButton: FloatingActionButton(
          tooltip: '保存', // used by assistive technologies
          child: const Icon(Icons.save),
          onPressed: _saveDeviceProp,
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: FormBuilder(
              key: _formKey,
              onChanged: () {
                _formKey.currentState!.save();
                debugPrint(_formKey.currentState!.value.toString());
              },
              autovalidateMode: AutovalidateMode.disabled,
              initialValue: {},
              skipDisabled: true,
              child: DevicePropFormElements(deviceattrs: deviceattrs),
            ))));
  }

  _saveDeviceProp() async {
    if (this._formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_formKey.currentState?.value.toString() ?? '')));
    }
  }

  @override
  void initState() {
    var profile = getUserProfile();
    getIt<Dio>()
        .get(
            '${profile?.serverurl}/api/Devices/${this.DeviceId}/AttributeLatest')
        .then((data) {
      setState(() {
        this.deviceattrs = DeviceAttrResult.fromJson(data.data).data;
      });
      Stream.fromIterable(deviceattrs)
          .groupBy((g) => g.dataSide)
          .map((m) => DataAttr(dataType: m.key, attrs: m.toList()))
          .toList()
          .then((gm) {
        for (var item in gm) {
          switch (item.dataType) {
            case 'ClientSide':
              item.attrs?.then((value) {
                setState(() {
                  clientside = value;
                });
              });
              break;
            case 'ServerSide':
              item.attrs?.then((value) {
                setState(() {
                  serverside = value;
                });
              });
              break;
            case 'AnySide':
              item.attrs?.then((value) {
                setState(() {
                  anyside = value;
                });
              });
              break;
          }
        }
      });
    });
  }
}

class DevicePropFormElements extends StatelessWidget {



  DevicePropFormElements({required this.deviceattrs});

  List<DeviceAttrItem> deviceattrs = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _BuildFromEelements(context);
  }

  _BuildFromEelements(BuildContext context) {
    List<Widget> widgets = [];
    for (var i = 0; i < deviceattrs.length; i++) {
      switch (deviceattrs[i].dataType) {
        case 'String':
          widgets.add(FormBuilderTextField(
            autovalidateMode: AutovalidateMode.always,
            name: deviceattrs[i].keyName!,
            initialValue: deviceattrs[i].value ?? '',
            decoration: InputDecoration(
              labelText: deviceattrs[i].keyName!,
            ),
            onChanged: (val) {},
            // valueTransformer: (text) => num.tryParse(text),
            validator: FormBuilderValidators.compose([]),
            // initialValue: '12',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ));
          break;
        case 'DateTime':
          widgets.add(FormBuilderDateTimePicker(
            name: deviceattrs[i].keyName!,
            initialEntryMode: DatePickerEntryMode.calendar,
            initialValue: DateTime.parse(deviceattrs[i].value ?? ''),
            inputType: InputType.both,
            decoration: InputDecoration(
              labelText: deviceattrs[i].keyName!,
              suffixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {},
              ),
            ),
            initialTime: const TimeOfDay(hour: 8, minute: 0),
            // locale: const Locale.fromSubtags(languageCode: 'fr'),
          ));
          break;
        case 'Double':
          widgets.add(FormBuilderTextField(
            autovalidateMode: AutovalidateMode.always,
            name: deviceattrs[i].keyName!,
            initialValue: deviceattrs[i].value ?? '',
            decoration: InputDecoration(
              labelText: deviceattrs[i].keyName!,
            ),
            onChanged: (val) {},
            // valueTransformer: (text) => num.tryParse(text),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.numeric()]),
            // initialValue: '12',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ));
          break;
        case 'Long':
          widgets.add(FormBuilderTextField(
            autovalidateMode: AutovalidateMode.always,
            name: deviceattrs[i].keyName!,
            initialValue: deviceattrs[i].value ?? '',
            decoration: InputDecoration(
              labelText: deviceattrs[i].keyName!,
            ),
            onChanged: (val) {},
            // valueTransformer: (text) => num.tryParse(text),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.integer()]),
            // initialValue: '12',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ));
          break;
        case 'XML':
          widgets.add(FormBuilderTextField(
            autovalidateMode: AutovalidateMode.always,
            name: deviceattrs[i].keyName!,
            initialValue: deviceattrs[i].value ?? '',
            decoration: InputDecoration(
              labelText: deviceattrs[i].keyName!,
            ),
            onChanged: (val) {},
            // valueTransformer: (text) => num.tryParse(text),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.match(
                  '^([a-zA-Z]+-?)+[a-zA-Z0-9]+\\.[x|X][m|M][l|L]\$')
            ]),
            // initialValue: '12',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ));
          break;
        case 'Json':
          widgets.add(FormBuilderTextField(
            autovalidateMode: AutovalidateMode.always,
            name: deviceattrs[i].keyName!,
            initialValue: deviceattrs[i].value ?? '',
            decoration: InputDecoration(
              labelText: deviceattrs[i].keyName!,
            ),
            onChanged: (val) {},
            // valueTransformer: (text) => num.tryParse(text),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.match('^[\],:{}\s]*\$')]),
            // initialValue: '12',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ));
          break;
        case 'Binary':
          widgets.add(FormBuilderTextField(
            autovalidateMode: AutovalidateMode.always,
            name: deviceattrs[i].keyName!,
            initialValue: deviceattrs[i].value ?? '',
            decoration: InputDecoration(
              labelText: deviceattrs[i].keyName!,
            ),
            onChanged: (val) {},
            // valueTransformer: (text) => num.tryParse(text),
            validator: FormBuilderValidators.compose([]),
            // initialValue: '12',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ));
          break;
        case 'Boolean':
          widgets.add(FormBuilderRadioGroup<bool>(
            decoration: InputDecoration(
              labelText: deviceattrs[i].keyName!,
            ),
            initialValue: deviceattrs[i].value ?? false,
            name: deviceattrs[i].keyName!,
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            options: [true, false]
                .map((lang) => FormBuilderFieldOption(
                      value: lang,
                      child: Text(lang.toString()),
                    ))
                .toList(growable: false),
            controlAffinity: ControlAffinity.trailing,
          ));

          break;
      }
    }
    if (widgets.length == 0) {
      widgets.add(Text('没有定于属性数据'));
    }
    return Column(
      children: widgets,
    );
  }
}

class DataAttr {
  String? dataType;
  Future<List<DeviceAttrItem>>? attrs;

  DataAttr({this.dataType, this.attrs});
}
