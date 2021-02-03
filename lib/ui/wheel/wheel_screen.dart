import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/database/models.dart';
import 'package:curbwheel/service/bluetooth_service.dart';
import 'package:curbwheel/ui/features/features_screen.dart';
import 'package:curbwheel/ui/wheel/progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'complete_list.dart';
import 'incomplete_list.dart';

class WheelScreenArguments {
  final Project project;
  final Survey survey;
  final List<ListItem> incompleteSpans;
  final bool newFeature;

  WheelScreenArguments(this.project, this.survey, this.incompleteSpans,
      {this.newFeature = false});
}

class WheelScreen extends StatefulWidget {
  static const routeName = '/wheel';

  @override
  _WheelScreenState createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  CurbWheelDatabase _database;
  WheelCounter _counter;
  List<Span> completeSpans;
  double _progress;
  double streetLength = 40;

  @override
  Widget build(BuildContext context) {
    final WheelScreenArguments args = ModalRoute.of(context).settings.arguments;
    final Project project = args.project;
    final Survey survey = args.survey;
    final List<ListItem> incompleteSpans = args.incompleteSpans;
    _database = Provider.of<CurbWheelDatabase>(context);
    _counter = Provider.of<WheelCounter>(context);
    _progress = _counter.getForwardCounter() / 10 / streetLength;
    return Scaffold(
      appBar: AppBar(
        title: Text("Surveying"),
      ),
      body: Container(
        color: Color(0xFFEFEFEF),
        child: Column(
          children: [
            WheelHeader(_progress, survey),
            Expanded(
                child: Column(
              children: [
                IncompleteList(incompleteSpans, _progress),
                CompleteList(survey),
              ],
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
        onPressed: () => {
          Navigator.pushNamed(context, FeatureSelectScreen.routeName,
              arguments: FeatureSelectScreenArguments(
                  project, survey, _progress, incompleteSpans))
        },
      ),
    );
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
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 32.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_survey.streetName}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                IconButton(icon: Icon(Icons.check), onPressed: () => {}),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: 'Between ',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
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
                backgroundStrokeWidth: 10.0,
              ),
            ),
            Text(
                "Surveyed ${(_progress * 40).toStringAsFixed(1)}m of ${_survey.length}m"),
          ],
        ),
      ),
    );
  }
}
