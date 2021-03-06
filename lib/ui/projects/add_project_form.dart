import 'dart:convert';
import 'dart:async';

import 'package:curbwheel/client/config_client.dart';
import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/ui/projects/project_config_card.dart';
import 'package:curbwheel/utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moor/moor.dart' as moor;
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connectivity/connectivity.dart';

var uuid = Uuid();

class AddProjectFormScreen extends StatefulWidget {
  final String initalProjectUrl;

  AddProjectFormScreen({Key key, @required this.initalProjectUrl})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _AddProjectFormScreenState(this.initalProjectUrl);
}

class _AddProjectFormScreenState extends State<AddProjectFormScreen> {
  ConnectivityResult _connectionStatus;
  CurbWheelDatabase _database;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  var _config;
  var _mapData;
  var _projectUrl;

  Future<bool> _isNewProject;

  final textFieldController = TextEditingController();

  _AddProjectFormScreenState(intialProjectUrl) {
    textFieldController.text = intialProjectUrl;
  }

  @override
  void initState() {
    super.initState();
    // TODO should this db init move to code within the widget tree?
    // per https://stackoverflow.com/questions/60363665/dependoninheritedelement-was-called-before-initstate-in-flutter
    _database = Provider.of<CurbWheelDatabase>(context, listen: false);
    _isNewProject = _checkIfNewProject();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result);
        break;
      default:
        setState(() => _connectionStatus = ConnectivityResult.none);
        break;
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    textFieldController.dispose();
    super.dispose();
  }

  Future<bool> _checkIfNewProject() async {
    if (_config == null) {
      return false;
    }
    try {
      List<Project> projectList =
          await _database.projectDao.findProjectById(_config.projectId);
      if (projectList.length > 0)
        return false;
      else
        return true;
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  _addProject() async {
    String projectId = uuid.v4();
    final _project = ProjectsCompanion(
        id: moor.Value(projectId),
        projectConfigUrl: moor.Value(_projectUrl),
        projectId: moor.Value(_config.projectId),
        name: moor.Value(_config.projectName),
        email: moor.Value(_config.email),
        organization: moor.Value(_config.organization));
    await _database.projectDao.insertProject(_project);
    await FileUtils.writeFile(
        _config.projectId, 'map.json', jsonEncode(_mapData.featureCollection));

    for (var featureType in _config.featureTypes) {
      var _feature = FeatureTypesCompanion(
        id: moor.Value(uuid.v4()),
        projectId: moor.Value(projectId),
        geometryType: moor.Value(featureType.geometryType),
        color: moor.Value(featureType.color),
        label: moor.Value(featureType.label),
        value: moor.Value(featureType.value),
      );
      await _database.featureTypeDao.insertFeature(_feature);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addProject,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          Center(
            child: TextFormField(
              controller: textFieldController,
              decoration:
                  InputDecoration(labelText: AppLocalizations.of(context).projectConfigurationUrl),
            ),
          ),
          DownloadButton(
              urlController: textFieldController,
              callback: (String url, var config, var mapData) {
                setState(() {
                  this._projectUrl = url;
                  this._config = config;
                  this._mapData = mapData;

                  _isNewProject = _checkIfNewProject();
                });
              },
              connectionStatus: _connectionStatus),
          _config != null
              ? ProjectConfigCard(
                  config: _config,
                  mapData: _mapData,
                )
              : Text(""),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: FutureBuilder<bool>(
                future: _isNewProject,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (_config != null && snapshot.data != null) {
                    if (snapshot.data) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          onPrimary: Colors.white,
                        ),
                        onPressed: () {
                          _addProject();
                        },
                        child: Text(AppLocalizations.of(context).addProject,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      );
                    } else
                      return Text(
                          AppLocalizations.of(context).alreadyImportedWarning);
                  } else
                    return Text("");
                }),
          ),
        ]),
      ),
    );
  }
}

typedef void DownloadCallback(
  String url,
  var config,
  var mapData,
);

class DownloadButton extends StatefulWidget {
  final TextEditingController urlController;
  final DownloadCallback callback;
  final ConnectivityResult connectionStatus;

  DownloadButton(
      {Key key,
      @required this.urlController,
      this.callback,
      this.connectionStatus})
      : super(key: key);

  @override
  _DownloadButtonState createState() => _DownloadButtonState(
      urlController: this.urlController, callback: this.callback);
}

class _DownloadButtonState extends State<DownloadButton> {
  var _loading = false;
  TextEditingController urlController;
  final DownloadCallback callback;

  _DownloadButtonState({this.urlController, this.callback});

  _fetch() async {
    final config = await ConfigClient().getConfig(urlController.text);
    final mapDataJson = await ConfigClient().getMapData(config);
    if (config != null && config.projectId != null) {
      setState(() {
        callback(urlController.text, config, mapDataJson);
      });
    } else
      throw Exception(AppLocalizations.of(context).unableToRetrieveProject);
  }

  @override
  build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          // prevent concurrent loads
          if (_loading == false) {
            setState(() {
              _loading = true;
            });
            try {
              await _fetch();
            } catch (exception) {
              print(widget.connectionStatus);
              String message =
                  AppLocalizations.of(context).unableToRetrieveProject;
              if (widget.connectionStatus == ConnectivityResult.none) {
                message = AppLocalizations.of(context).noConnectivity;
              }
              final snackBar = SnackBar(
                content:
                    Text(AppLocalizations.of(context).unableToRetrieveProject),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

            setState(() {
              _loading = false;
            });
          }
        },
        style: TextButton.styleFrom(
          primary: Colors.black,
          padding: EdgeInsets.all(10.0),
        ),
        child: Row(
          children: _loading
              ? <Widget>[
                  Spinner(icon: Icons.refresh),
                  Text(AppLocalizations.of(context).downloading)
                ]
              : <Widget>[
                  Icon(Icons.refresh),
                  Text(AppLocalizations.of(context).downloadBtn)
                ],
        ));
  }
}

class Spinner extends StatefulWidget {
  final IconData icon;
  final Duration duration;

  const Spinner({
    Key key,
    @required this.icon,
    this.duration = const Duration(milliseconds: 1800),
  }) : super(key: key);

  @override
  _SpinnerState createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Widget _child;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..repeat();
    _child = Icon(widget.icon);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: _child,
    );
  }
}
