import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final _deviceNameTextFieldController = TextEditingController();
  final _bleConnectionTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future _deviceName = _getDeviceNameValue(_deviceNameTextFieldController);
    Future _bleConnection = _getBleConnectionValue(_bleConnectionTextFieldController);
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).settings,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
            child: Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Column(
            children: [
              FutureBuilder<dynamic>(
                  future: _deviceName,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return TextFormField(
                      controller: _deviceNameTextFieldController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context).deviceName),
                    );
                  }),
                  SizedBox(height: 16),
                  FutureBuilder<dynamic>(
                  future: _bleConnection,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return TextFormField(
                      enableInteractiveSelection: false,
                      focusNode: new AlwaysDisabledFocusNode(),
                      readOnly: true,
                      controller: _bleConnectionTextFieldController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context).defaultBleConnection),
                    );
                  }),
              ElevatedButton(
                onPressed: () async =>
                    {await _setValues(_deviceNameTextFieldController)},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        onPrimary: Colors.white,
                      ),
                child: Text(AppLocalizations.of(context).save),
              )
            ],
          ),
        )));
  }

  Future _getDeviceNameValue(TextEditingController deviceNameTextFieldController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('deviceName');
    deviceNameTextFieldController.text = stringValue;
  }

  Future _getBleConnectionValue(TextEditingController bleConnectionTextFieldController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('previousWheelId');
    bleConnectionTextFieldController.text = stringValue;
  }

  Future _setValues(deviceNameTextFieldController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _deviceName = _deviceNameTextFieldController.text;
    await prefs.setString('deviceName', _deviceName);
  }
}


class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}