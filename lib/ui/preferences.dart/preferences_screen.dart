import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final _deviceNameTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future _deviceName =
        _getDeviceNameValue(_deviceNameTextFieldController);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
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
                          labelText: 'Device name'),
                    );
                  }),
              RaisedButton(
                onPressed: () async =>
                    {await _setValues(_deviceNameTextFieldController)},
                color: Colors.blue,
                child: Text("Save"),
              )
            ],
          ),
        )
        )
        );
  }

  Future _getDeviceNameValue(deviceNameTextFieldController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('deviceName');
    deviceNameTextFieldController.text = stringValue;
  }

  Future _setValues(deviceNameTextFieldController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _deviceName = _deviceNameTextFieldController.text;
    await prefs.setString('deviceName', _deviceName);
  }
}
