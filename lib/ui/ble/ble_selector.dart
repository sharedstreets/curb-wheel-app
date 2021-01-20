import 'dart:async';

import 'package:curbwheel/service/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

class BleStatusButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BleConnection>(builder: (context, connection, child) {
      return IconButton(
        icon: const Icon(Icons.bluetooth),
        color:
            Provider.of<BleConnection>(context, listen: false).currentWheel() !=
                        null &&
                    Provider.of<BleConnection>(context, listen: false)
                        .currentWheel()
                        .isConnected()
                ? Colors.green
                : Colors.red,
        tooltip: 'Bluetooth',
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => BleListDisplay()));
        },
      );
    });
  }
}

class BleListDisplay extends StatefulWidget {
  @override
  State createState() => new _BleDeviceList();
}

class _BleDeviceList extends State<BleListDisplay> {
  BleWheel _pendingWheel;

  @override
  void initState() {
    super.initState();
    //Provider.of<BleConnection>(context).scan();
  }

  @override
  void dispose() {
    super.dispose();
    print("disposing of ble list...");
  }

  void _displaySnackBar(BuildContext context, {@required String error}) {
    final snackBar = SnackBar(content: Text(error));
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Widget getDevices() {
    return Consumer<BleConnection>(builder: (context, connection, child) {
      if (connection.getVisibleWheels().length > 0) {
        return ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            padding: const EdgeInsets.all(8),
            itemCount: connection.getVisibleWheels().length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(onTap: () {
                _pendingWheel = connection.getVisibleWheels()[index];
                connection.getVisibleWheels()[index].connect();
              }, child: new Builder(builder: (BuildContext context) {
                var color;
                var child = Row(children: []);

                child.children.add(Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                        '${connection.getVisibleWheels()[index].getName()}',
                        style: TextStyle(fontWeight: FontWeight.bold))));

                if (connection
                    .isCurrentDevice(connection.getVisibleWheels()[index])) {
                  if (connection.currentWheel().isConnected()) {
                    _pendingWheel = null;
                    color = Colors.green[400];

                    child.children.add(new Consumer<WheelCounter>(
                        builder: (context, counter, child) {
                      return Text(
                        "(" +
                            Provider.of<WheelCounter>(context)
                                .getForwardCounter()
                                .toString() +
                            " | " +
                            Provider.of<WheelCounter>(context)
                                .getReverseCounter()
                                .toString() +
                            ")",
                      );
                    }));
                  } else if (connection.currentWheel().isConnecting()) {
                    color = Colors.orange[400];
                  } else if (connection.currentWheel().connectionFailed()) {
                    _pendingWheel = null;
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        _displaySnackBar(context,
                            error: "Unable to connect to: " +
                                connection
                                    .getVisibleWheels()[index]
                                    .getName()));
                    color = Colors.blue[200];
                  } else
                    color = Colors.blue[200];

                  if (_pendingWheel != null &&
                      _pendingWheel.getId ==
                          connection.getVisibleWheels()[index].getId)
                    child.children.insert(
                        0,
                        Padding(
                            padding: EdgeInsets.all(6.0),
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            )));
                } else {
                  color = Colors.blue[200];
                }

                return Container(height: 50, color: color, child: child);
              }));
            });
      } else {
        return Center(
            child: Text(
          'Scanning for devices...',
        ));
      }
    });
  }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(
            'Connect Wheel',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: getDevices());
  }
}
