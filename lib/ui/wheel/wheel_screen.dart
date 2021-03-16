import 'dart:async';

import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/database/models.dart';
import 'package:curbwheel/service/bluetooth_service.dart';
import 'package:curbwheel/ui/ble/ble_selector.dart';
import 'package:curbwheel/ui/features/features_screen.dart';
import 'package:curbwheel/ui/shared/utils.dart';
import 'package:curbwheel/utils/survey_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:progresso/progresso.dart';

import 'complete_list.dart';
import 'incomplete_list.dart';

class WheelScreenArguments {
  final Project project;
  final Survey survey;
  final ListItem listItem;

  WheelScreenArguments(this.project, this.survey, {this.listItem});
}

class WheelScreen extends StatefulWidget {
  static const routeName = '/wheel';
  final Project project;
  final Survey survey;
  final ListItem listItem;

  WheelScreen(this.project, this.survey, {this.listItem});

  @override
  _WheelScreenState createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen>
    with SingleTickerProviderStateMixin {
  ListItem listItem;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    this.listItem = widget.listItem;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Project _project = widget.project;
    Survey _survey = widget.survey;
    CurbWheelDatabase _database = Provider.of<CurbWheelDatabase>(context);
    WheelCounter _counter = Provider.of<WheelCounter>(context);
    double _currentWheelPosition = _counter.getForwardCounter() / 10;
    BleConnection _bleService = Provider.of<BleConnection>(context);

    SurveyManager _surveyManager = SurveyManager(_database);

    if (_bleService.currentWheel() == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showBluetoothAlertDialog(
            context, _survey, _surveyManager.deleteSurvey);
      });
    }
    if (this.listItem != null) {
      _database.surveyItemDao
          .insertSurveyItem(listItem.toSurveyItemsCompanion());
      if (this.listItem.geometryType == 'line') {
        _database.surveySpanDao.insertSpan(listItem.toSpansCompanion());
      } else {
        var points = listItem.toPointsCompanion();
        for (var p in points) {
          _database.surveyPointDao.insertPoint(p);
        }
      }
      setState(() => this.listItem = null);
    }

    Future<bool> _onWillPop() {
      if (_survey.complete == false) {
        return showBackWarningDialog(
                context, _survey, _surveyManager.deleteSurvey) ??
            false;
      } else {
        return Future.value(true);
      }
    }

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
            title: Text("Survey street",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            actions: [BleStatusButton()]),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
          onPressed: () => {
            Navigator.pushNamed(context, FeatureSelectScreen.routeName,
                arguments: FeatureSelectScreenArguments(
                    _project, _survey, _currentWheelPosition))
          },
        ),
        body: Column(
          children: [
            Container(
                child: Column(
              children: [
                WheelHeader(_currentWheelPosition, _project, _survey),
                StreamBuilder(
                    stream: _database.getListItemCounts(_survey.id),
                    builder: (_, AsyncSnapshot<Count> snapshot) {
                      int completeCount = 0;
                      int activeCount = 0;
                      if (snapshot.hasData) {
                        completeCount = snapshot.data.completeCount;
                        activeCount = snapshot.data.activeCount;
                      }
                      return Container(
                          height: 48,
                          color: Colors.white,
                          child: TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                              color: Colors.black,
                              width: 4.0,
                            ))),
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.black,
                            tabs: [
                              Tab(
                                text: 'Active features($activeCount)',
                              ),
                              Tab(
                                text: 'Completed features ($completeCount)',
                              ),
                            ],
                          ));
                    }),
              ],
            )),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  IncompleteList(
                      _surveyManager, _survey, _currentWheelPosition),
                  CompleteList(_survey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> showBackWarningDialog(
    BuildContext context, Survey survey, Function deleteCallback) {
  AlertDialog alert = AlertDialog(
    title: Text("Incomplete survey"),
    content: Text(
        "This survey is incomplete. Navigating back will delete the current progress, cancel to continue surveying and save your progress."),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("CANCEL"),
      ),
      TextButton(
        child: Text("GO BACK TO MAP"),
        onPressed: () async {
          await deleteCallback(survey);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      )
    ],
  );

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showBluetoothAlertDialog(
    BuildContext context, Survey survey, Function deleteCallback) {
  Widget okButton = TextButton(
    child: Text("Go to connection screen"),
    onPressed: () async {
      await deleteCallback(survey);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, BleListDisplay.routeName);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Bluetooth Not Connected"),
    content: Text(
        "You are not connected to a CurbWheel, go to the connection screen to find a nearby CurbWheel connection before surveying."),
    actions: [
      okButton,
    ],
  );

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class WheelHeader extends StatefulWidget {
  final double currentWheelPosition;
  final Project project;
  final Survey survey;

  WheelHeader(this.currentWheelPosition, this.project, this.survey);

  @override
  _WheelHeaderState createState() => _WheelHeaderState();
}

class _WheelHeaderState extends State<WheelHeader> {
  @override
  Widget build(BuildContext context) {
    CurbWheelDatabase _database = Provider.of<CurbWheelDatabase>(context);
    var _survey = widget.survey;
    var _currentMeasurement = widget.currentWheelPosition;
    var _max = widget.survey.mapLength;
    var _progress = _currentMeasurement / _max;
    Color _color = Colors.blue;

    if (_currentMeasurement / _max >= 0.98) {
      double _val = ((_currentMeasurement / _max) - 0.98) / (1 - 0.98);
      _val = _val > 1 ? 1.0 : _val;
      Color _colorValue = Color.lerp(Colors.orange, Colors.red, _val);
      _color = colorConvert(
          '#${_colorValue.toString().split('(0x')[1].split(')')[0]}');
      HapticFeedback.vibrate();
    }
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '${_survey.streetName}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () async {
                      var completeSurvey = _survey.copyWith(
                          measuredLength: _currentMeasurement,
                          complete: true,
                          endTimestamp: DateTime.now());
                      await _database.surveyDao.updateSurvey(completeSurvey);
                      Navigator.pop(context);
                    }),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: buildStreetDescription(
                  context,
                  getSideOfStreetFromString(_survey.side),
                  _survey.startStreetName,
                  _survey.endStreetName),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Progresso(
                progress: _progress,
                progressColor: _color,
                backgroundStrokeWidth: 10.0,
                progressStrokeCap: StrokeCap.round,
                backgroundStrokeCap: StrokeCap.round,
              ),
            ),
            Text(
                "Surveyed ${_currentMeasurement.toStringAsFixed(1)}m of ${_survey.mapLength.toStringAsFixed(1)}m"),
          ],
        ),
      ),
    );
  }
}
