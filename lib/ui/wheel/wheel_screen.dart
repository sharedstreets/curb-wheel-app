import 'dart:async';

import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/database/models.dart';
import 'package:curbwheel/service/bluetooth_service.dart';
import 'package:curbwheel/ui/ble/ble_selector.dart';
import 'package:curbwheel/ui/features/features_screen.dart';
import 'package:curbwheel/ui/map/street_select_map_screen.dart';
import 'package:curbwheel/ui/shared/utils.dart';
import 'package:curbwheel/ui/wheel/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'complete_list.dart';
import 'incomplete_list.dart';

enum PhotoOptions { addPhoto, noPhoto }

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
  CurbWheelDatabase _database;
  WheelCounter _counter;
  List<ListItem> incompleteSpans;
  ListItem listItem;
  Project _project;
  Survey _survey;
  double _currentWheelPosition;
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
    _project = widget.project;
    _survey = widget.survey;
    _database = Provider.of<CurbWheelDatabase>(context);
    _counter = Provider.of<WheelCounter>(context);
    _currentWheelPosition = _counter.getForwardCounter() / 10;

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

    return Scaffold(
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
                WheelHeader(_currentWheelPosition, _survey),
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
                  IncompleteList(_survey, _currentWheelPosition),
                  CompleteList(_survey),
                ],
              ),
            ),
          ],
        ));
  }
}

class WheelHeader extends StatefulWidget {
  final double currentWheelPosition;
  final Survey survey;

  WheelHeader(this.currentWheelPosition, this.survey);

  @override
  _WheelHeaderState createState() => _WheelHeaderState();
}

class _WheelHeaderState extends State<WheelHeader> {
  @override
  Widget build(BuildContext context) {
    CurbWheelDatabase _database = Provider.of<CurbWheelDatabase>(context);
    var _survey = widget.survey;
    var _currentMeasurement = widget.currentWheelPosition;
    var _max = widget.survey.length;
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
                          complete: true, endTimestamp: DateTime.now());
                      await _database.surveyDao.updateSurvey(completeSurvey);
                    }),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: '',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text: _survey.side == SideOfStreet.Left.toString()
                            ? "Left side"
                            : "Right side",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " between "),
                    TextSpan(
                        text: '${_survey.startStreetName}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' and '),
                    TextSpan(
                        text: '${_survey.endStreetName}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: ProgressBar(
                progress: _currentMeasurement,
                max: _max,
                progressColor: _color,
                backgroundStrokeWidth: 10.0,
              ),
            ),
            Text(
                "Surveyed ${_currentMeasurement.toStringAsFixed(1)}m of ${_survey.length.toStringAsFixed(1)}m"),
          ],
        ),
      ),
    );
  }
}
