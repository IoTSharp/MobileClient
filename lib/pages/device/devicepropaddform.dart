import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../models/const/deviceconst.dart';
import '../../widgets/customfloatingactionbutton/customfloatingactionbuttonlocation.dart';

class DevicePropAddForm extends StatefulWidget{
  DevicePropAddForm({required this.DeviceId});
  final String DeviceId;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DevicePropAddFormState(DeviceId: DeviceId);
  }


}

class _DevicePropAddFormState extends State<DevicePropAddForm>{
  final _formKey = GlobalKey<FormBuilderState>();


  _DevicePropAddFormState({required this.DeviceId});
  final String DeviceId;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  return Scaffold(
      appBar: AppBar(title: const Text('属性增加')),
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
                child: Column( children: [
                  const SizedBox(height: 15),

                  FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name: 'keyName',
                    decoration: const InputDecoration(
                      labelText: 'keyName',
                      hintText: 'keyName',
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
                    name: 'type',
                    decoration: const InputDecoration(
                      labelText: 'DateType',
                      hintText: 'DateType',
                    ),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                    items: DataTypes
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
                  FormBuilderDropdown<String>(
                    // autovalidate: true,
                    name: 'dataSide',
                    decoration: const InputDecoration(
                      labelText: 'DataSide',
                      hintText: 'DataSide',
                    ),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                    items: DataSides
                        .map((ds) => DropdownMenuItem(
                      alignment: AlignmentDirectional.center,
                      value: ds.value,
                      child: Text(ds.text),
                    ))
                        .toList(),
                    onChanged: (val) {
                    },
                    valueTransformer: (val) => val?.toString(),
                  ),
                ],) ,
              ))));
  }



  _saveDeviceProp(){

    if (this._formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_formKey.currentState?.value.toString() ?? '')));
    }
  }
}