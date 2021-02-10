import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/database/models.dart';
import 'package:curbwheel/service/bluetooth_service.dart';
import 'package:curbwheel/ui/ble/ble_selector.dart';
import 'package:curbwheel/ui/features/features_screen.dart';
import 'package:curbwheel/ui/map/street_select_map_screen.dart';
import 'package:curbwheel/ui/wheel/progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'complete_list.dart';
import 'incomplete_list.dart';

enum PhotoOptions { addPhoto, noPhoto }

class WheelScreenArguments {
  final Project project;
  final Survey survey;
  final List<ListItem> incompleteSpans;
  final ListItem listItem;

  WheelScreenArguments(this.project, this.survey, this.incompleteSpans,
      {this.listItem});
}

class WheelScreen extends StatefulWidget {
  static const routeName = '/wheel';
  final Project project;
  final Survey survey;
  final List<ListItem> incompleteSpans;
  final ListItem listItem;

  WheelScreen(this.project, this.survey, this.incompleteSpans, {this.listItem});

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
  double _progress;
  double streetLength = 40;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    print("WHEEL INIT STATE");
    _tabController = TabController(length: 2, vsync: this);
    this.listItem = widget.listItem;
    this.incompleteSpans = widget.incompleteSpans;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<void> _photoDialog(incompleteSpans, listItem) async {
    switch (await showDialog<PhotoOptions>(
        useRootNavigator: false,
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, PhotoOptions.addPhoto);
                  Navigator.pop(context);
                },
                child: const Text('Add a photo'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, PhotoOptions.addPhoto);
                  Navigator.pop(context);
                },
                child: const Text('Continue surveying'),
              ),
            ],
          );
        })) {
      case PhotoOptions.addPhoto:
        this.incompleteSpans.add(this.listItem);
        setState(() => this.listItem = null);
        setState(() => this.incompleteSpans = incompleteSpans);
        break;
      case PhotoOptions.noPhoto:
        this.incompleteSpans.add(this.listItem);
        setState(() => this.listItem = null);
        setState(() => this.incompleteSpans = incompleteSpans);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("WHEEL BUILD");

    _project = widget.project;
    _survey = widget.survey;
    _database = Provider.of<CurbWheelDatabase>(context);
    _counter = Provider.of<WheelCounter>(context);
    _progress = _counter.getForwardCounter() / 10 / streetLength;


    if (this.listItem != null) {
      this.incompleteSpans.add(this.listItem);
      setState(() => this.listItem = null);
      setState(() => this.incompleteSpans = incompleteSpans);
      /*
      Future.delayed(
          Duration.zero, () => _photoDialog(incompleteSpans, listItem));
      */
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
                    _project, _survey, incompleteSpans, _progress))
          },
        ),
        body: Column(
          children: [
            Container(
                child: Column(
              children: [
                WheelHeader(_progress, _survey),
                StreamBuilder(
                    stream: _database.getListItemBySurveyId(_survey.id),
                    builder: (_, AsyncSnapshot<List<ListItem>> snapshot) {
                      int completeLength = 0;
                      if (snapshot.hasData) {
                        completeLength = snapshot.data.length;
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
                                text:
                                    'Active features(${incompleteSpans.length})',
                              ),
                              Tab(
                                text: 'Completed features ($completeLength)',
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
                  IncompleteList(_survey.id, this.incompleteSpans, _progress),
                  CompleteList(_survey),
                ],
              ),
            ),
          ],
        ));
  }
}

class WheelHeader extends StatefulWidget {
  final double progress;
  final Survey survey;

  WheelHeader(this.progress, this.survey);

  @override
  _WheelHeaderState createState() => _WheelHeaderState();
}

class _WheelHeaderState extends State<WheelHeader> {
  @override
  Widget build(BuildContext context) {
    var _progress = widget.progress;
    var _survey = widget.survey;

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
                IconButton(icon: Icon(Icons.check), onPressed: () => {}),
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
                progress: _progress,
                progressColor: Color(0xff667ad2),
                backgroundStrokeWidth: 10.0,
              ),
            ),
            Text(
                "Surveyed ${(_progress * 40).toStringAsFixed(1)}m of ${_survey.length.toStringAsFixed(1)}m"),
          ],
        ),
      ),
    );
  }
}
