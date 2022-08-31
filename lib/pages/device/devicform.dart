import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:iotsharp/util/global.dart';

import '../../models/const/deviceconst.dart';
import '../../models/devicedetailresult.dart';
import '../../models/deviceresult.dart';
import '../../models/dropdownoption.dart';
import '../../util/getit.dart';
import '../../widgets/customfloatingactionbutton/customfloatingactionbuttonlocation.dart';

class DeviceForm extends StatefulWidget{
  DeviceForm({required this.DeviceId});
  final String DeviceId;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DeviceFormState(DeviceId: DeviceId);
  }


}

class _DeviceFormState extends State<DeviceForm>{

  final String DeviceId;
  final _formKey = GlobalKey<FormBuilderState>();
  DeviceItem? deviceItem;
  _DeviceFormState({required this.DeviceId});
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: const Text('属性增加')),
        floatingActionButtonLocation: CustomFloatingActionButtonLocation(
            FloatingActionButtonLocation.endFloat, 0, -50),
        floatingActionButton: FloatingActionButton(
          tooltip: '保存', // used by assistive technologies
          child: const Icon(Icons.save),
          onPressed: _saveDevice,
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
                  initialValue: {
                    'id':deviceItem?.id??'',
                    'name':deviceItem?.name??'',
                    'timeout':deviceItem?.timeout.toString()??'0',
                    'identityType':deviceItem?.identityType??'AccessToken',
                    'deviceType':deviceItem?.deviceType??'Device',
                  },
                  skipDisabled: true,
                  child: Column( children: [
                    const SizedBox(height: 15),

                    FormBuilderTextField(

                      autovalidateMode: AutovalidateMode.always,
                      name: 'name',
                      decoration: const InputDecoration(
                        labelText: 'name',
                        hintText: 'name',
                      ),

                      onChanged: (val) {

                      },
                      validator: FormBuilderValidators.compose(
                          []),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 15),
                    FormBuilderDropdown<String>(
                      // autovalidate: true,
                      name: 'DeviceType',
                      decoration: const InputDecoration(
                        labelText: 'deviceType',
                        hintText: 'deviceType',
                      ),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: DeviceTypes
                          .map((dt) => DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        value: dt.value,
                        child: Text(dt.text),
                      ))
                          .toList(),
                      onChanged: (val) {

                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                    const SizedBox(height: 15),

                    FormBuilderTextField(

                      autovalidateMode: AutovalidateMode.always,
                      name: 'timeout',
                      decoration: const InputDecoration(
                        labelText: 'timeout',
                        hintText: 'timeout',
                      ),
                      onChanged: (val) {

                      },
                      validator: FormBuilderValidators.compose(
                          []),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 15),
                    FormBuilderDropdown<String>(
                      // autovalidate: true,
                      name: 'identityType',
                      decoration: const InputDecoration(
                        labelText: 'IdentityType',
                        hintText: 'IdentityType',
                      ),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: IdentityTypes
                          .map((it) => DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        value: it.value,
                        child: Text(it.text),
                      )).toList()
                         ,
                      onChanged: (val) {

                      },
                      valueTransformer: (val) => val?.toString(),
                    ),


                  ],) ,
                ))));
  }

  _saveDevice(){

    if (this._formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_formKey.currentState?.value.toString() ?? '')));
    }
  }

  @override
  void initState() {

var profile=getUserProfile();
    getIt<Dio>()
        .get('${profile?.serverurl}/api/Devices/${this.DeviceId}')
        .then((device) {
      setState(() {
        this.deviceItem = DeviceDetailResult.fromJson(device.data).data;
      });
    });

  }
}