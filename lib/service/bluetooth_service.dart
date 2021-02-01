import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:shared_preferences/shared_preferences.dart';

final WHEEL_SERVICE_UUID = new Guid("1381f6e7-12f9-4ad7-aa87-1c5d50fe03f9");
final FORWARD_UUID = new Guid("4365ec89-253c-49f4-b8a4-3ffe6ad73673");
final REVERSE_UUID = new Guid("0d7f503f-78ed-4c24-a9f3-271264661448");

enum WheelStatus { CONNECTING, CONNECTED, DISCONNECTED }

FlutterBlue _flutterBlue = FlutterBlue.instance;

class BleWheel {
  BluetoothDevice _device;
  BluetoothDeviceState _deviceState;

  StreamController<WheelStatus> _stateStreamController = new StreamController();

  StreamController<int> _forwardStreamController = new StreamController();
  StreamController<int> _revreseStreamController = new StreamController();

  BluetoothCharacteristic _forwardCharacteristic;
  BluetoothCharacteristic _revereseCharacteristic;

  bool _connectionFailed = false;

  BleWheel(BluetoothDevice device) {
    _device = device;
    _device.state.listen((event) {
      _deviceState = event;
      if (_deviceState == BluetoothDeviceState.disconnected)
        _stateStreamController.add(WheelStatus.DISCONNECTED);
    });
  }

  String getId() {
    return _device.id.id;
  }

  String getName() {
    return _device.name;
  }

  getUpdates(Function statusCallBack) {
    _stateStreamController.stream.listen(statusCallBack);
  }

  Future<void> connect() async {
    // skip if already connected to same device
    if (_device != null && isConnected()) {
      return;
    }

    _stateStreamController.add(WheelStatus.CONNECTING);

    // clean up connected/connecting device
    if (_device != null) {
      await _device.disconnect();
    }

    _connectionFailed = false;
    _forwardCharacteristic = null;
    _revereseCharacteristic = null;

    // fixing try/catch await bug in flutter_blue
    // per https://github.com/pauldemarco/flutter_blue/issues/299#issuecomment-521203753
    Future<bool> returnValue;
    await _device.connect(autoConnect: false).timeout(Duration(seconds: 5),
        onTimeout: () {
      print("unable to connect to: " + _device.name);
      _deviceState = BluetoothDeviceState.disconnected;
      _connectionFailed = true;
      _stateStreamController.add(WheelStatus.DISCONNECTED);
    }).then((data) {
      if (returnValue == null) {
        debugPrint('connection successful');
        returnValue = Future.value(true);
      }
    });

    if (!_connectionFailed) {
      List<BluetoothService> services = await _device.discoverServices();
      for (BluetoothService service in services) {
        if (service.uuid == WHEEL_SERVICE_UUID) {
          for (BluetoothCharacteristic characteristic
              in service.characteristics) {
            if (characteristic.uuid == FORWARD_UUID) {
              _forwardCharacteristic = characteristic;
            } else if (characteristic.uuid == REVERSE_UUID) {
              _revereseCharacteristic = characteristic;
            }
          }
        }
      }

      if (_forwardCharacteristic == null) {
        _connectionFailed = true;
        await _device.disconnect();
      }

      if (_revereseCharacteristic == null) {
        _connectionFailed = true;
        await _device.disconnect();
      }

      subscribeForwardCounter();
      subscribeRevreseCounter();

      _stateStreamController.add(WheelStatus.CONNECTED);
    }
  }

  disconnect() {
    _device.disconnect();
    _forwardCharacteristic = null;
    _revereseCharacteristic = null;
  }

  void subscribeForwardCounter() async {
    await _forwardCharacteristic.setNotifyValue(true);

    _forwardCharacteristic.value.listen((value) {
      int intVal = Uint8List.fromList(value.reversed.toList())
          .buffer
          .asByteData()
          .getUint32(0);
      _forwardStreamController.add(intVal);
    });
  }

  void subscribeRevreseCounter() async {
    await _revereseCharacteristic.setNotifyValue(true);

    _revereseCharacteristic.value.listen((value) {
      int intVal = Uint8List.fromList(value.reversed.toList())
          .buffer
          .asByteData()
          .getUint32(0);
      _revreseStreamController.add(intVal);
    });
  }

  bool isConnecting() {
    if (_deviceState != null &&
        (_deviceState == BluetoothDeviceState.connecting ||
            (_deviceState == BluetoothDeviceState.connected &&
                _forwardCharacteristic == null &&
                _revereseCharacteristic == null)))
      return true;
    else
      return false;
  }

  bool isConnected() {
    if (_deviceState != null &&
        _forwardCharacteristic != null &&
        _revereseCharacteristic != null &&
        _deviceState == BluetoothDeviceState.connected)
      return true;
    else
      return false;
  }

  bool connectionFailed() {
    if (_connectionFailed)
      return true;
    else
      return false;
  }
}

class BleConnection extends ChangeNotifier {
  List<BleWheel> _visbleWheels = [];
  BleWheel _currentWheel;

  StreamController<BleWheel> _wheelConnectionStreamController =
      new StreamController();

  String _previousWheelId;
  bool _isScanning;

  BleConnection() {
    _flutterBlue.isScanning.listen((event) {
      _isScanning = event;
    });

    _flutterBlue.scanResults.listen((results) async {
      for (ScanResult r in results) {
        BleWheel wheel = new BleWheel(r.device);

        bool newWheel = true;
        for (BleWheel w in _visbleWheels) {
          if (w.getId() == wheel.getId()) newWheel = false;
        }

        if (newWheel) {
          wheel._stateStreamController.stream
              .listen((WheelStatus status) async {
            if (status == WheelStatus.CONNECTED) {
              if (_currentWheel != null && _currentWheel != wheel)
                _currentWheel.disconnect();

              _currentWheel = wheel;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              _previousWheelId = wheel.getId();
              prefs.setString('previousWheelId', _previousWheelId);

              _wheelConnectionStreamController.add(wheel);
            }
            notifyListeners();
          });

          _visbleWheels.add(wheel);
          // autoconnect previously seen wheel
          if (_currentWheel == null && wheel.getId() == _previousWheelId) {
            wheel.connect();
          }
        }

        notifyListeners();
      }
    });

    initConnection();
  }

  initConnection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _previousWheelId = prefs.getString('previousWheelId');

    scan();
  }

  scan() async {
    try {
      // Start scanning

      // TODO need to confirm if this works to track scan state -- tracking isScanning stream?
      // need to eat "scan in progress" exceptions bc flutter blue doesn't reliably return scan state
      // https://github.com/pauldemarco/flutter_blue/issues/326
      if (_isScanning) {
        return;
      }

      await _flutterBlue.stopScan();

      _visbleWheels = [];
      _currentWheel = null;

      List<BluetoothDevice> connectedDevices =
          await _flutterBlue.connectedDevices;

      for (BluetoothDevice cd in connectedDevices) {
        cd.disconnect();
      }

      _flutterBlue.startScan(
          timeout: Duration(seconds: 4), withServices: [WHEEL_SERVICE_UUID]);
    } catch (e) {
      print(e);
    }
  }

  bool isCurrentDevice(BleWheel wheel) {
    if (_currentWheel == null)
      return false;
    else if (wheel.getId() == _currentWheel.getId())
      return true;
    else
      return false;
  }

  List<BleWheel> getVisibleWheels() {
    return _visbleWheels;
  }

  BleWheel currentWheel() {
    return _currentWheel;
  }

  @override
  void dispose() {
    super.dispose();
    if (_currentWheel != null) {
      _currentWheel.disconnect();
    }
    _flutterBlue.stopScan();
  }

  void clear() async {
    if (_currentWheel != null) {
      await _currentWheel.disconnect();
    }
    _currentWheel = null;
    notifyListeners();
  }
}

class WheelCounter extends ChangeNotifier {
  BleConnection _bleConnection;
  BleWheel _connectedWheel;

  int _forwardCounter = 0;
  int _reverseCounter = 0;

  int _forwardCounterOffset;
  int _revereseCounterOffset;

  updateConnection(BleConnection bleConnection) {
    if (bleConnection != null &&
        (_bleConnection == null || _bleConnection != bleConnection)) {
      _bleConnection = bleConnection;
      _bleConnection._wheelConnectionStreamController.stream
          .listen((BleWheel connnectedWheel) {
        if (_connectedWheel == null || _connectedWheel != connnectedWheel) {
          _forwardCounterOffset = null;
          _revereseCounterOffset = null;

          connnectedWheel._forwardStreamController.stream
              .listen(updateForwardCounter);

          connnectedWheel._revreseStreamController.stream
              .listen(updateReverseCounter);
        }
      });
    }
    return this;
  }

  updateForwardCounter(int counterValue) {
    if (_forwardCounterOffset == null) _forwardCounterOffset = counterValue;

    _forwardCounter += counterValue - _forwardCounterOffset;
    _forwardCounterOffset = counterValue;

    notifyListeners();
  }

  updateReverseCounter(int counterValue) {
    if (_revereseCounterOffset == null) _revereseCounterOffset = counterValue;

    _reverseCounter += counterValue - _revereseCounterOffset;
    _revereseCounterOffset = counterValue;

    notifyListeners();
  }

  getForwardCounter() {
    return _forwardCounter;
  }

  getReverseCounter() {
    return _reverseCounter;
  }
}
