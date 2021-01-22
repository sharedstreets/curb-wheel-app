import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/ui/features/features_screen.dart';
import 'package:curbwheel/ui/wheel/progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'incomplete_spans.dart';

class WheelScreenArguments {
  final Project project;
  final Survey survey;
  final List<SpanContainer> incompleteSpans;

  WheelScreenArguments(this.project, this.survey, this.incompleteSpans);
}

class WheelScreen extends StatefulWidget {
  static const routeName = '/wheel';

  @override
  _WheelScreenState createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  CurbWheelDatabase _database;
  List<Span> completeSpans;

  @override
  Widget build(BuildContext context) {
    final WheelScreenArguments args = ModalRoute.of(context).settings.arguments;
    final Project project = args.project;
    final Survey survey = args.survey;
    final List<SpanContainer> incompleteSpans = args.incompleteSpans;

    _database = Provider.of<CurbWheelDatabase>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Surveying"),
      ),
      body: Container(
        color: Color(0xFFEFEFEF),
        child: Column(
          children: [
            WheelHeader(0.5, survey),
            Expanded(child: IncompleteSpans(incompleteSpans, 0.2))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
        onPressed: () => {
          Navigator.pushNamed(context, FeatureSelectScreen.routeName,
              arguments: FeatureSelectScreenArguments(
                  project, survey, 0.0, incompleteSpans))
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
          padding: EdgeInsets.fromLTRB(16.0,8.0,16.0,32.0),
          child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_survey.streetName}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                IconButton(icon: Icon(Icons.check), onPressed: ()=>{}),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                  text: TextSpan(
                    text: 'Between ',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(text: '${_survey.startStreetName}', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' and '),
                      TextSpan(text: '${_survey.endStreetName}', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(8,8,8,8),
              child: ProgressBar(
                progress: 0.5,
                backgroundStrokeWidth: 10.0,
              ),
            ),
            Text("Surveyed ${(_progress * 40).toStringAsFixed(1)}m of ${_survey.length}m"),
          ],
        ),
        ),
        );
  }
}

class SpanList extends StatefulWidget {
  @override
  _SpanListState createState() => _SpanListState();
}

class _SpanListState extends State<SpanList> {
  List<Span> spans;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: spans.length,
        itemBuilder: (context, index) {
          var span = spans[index];
          return Card(child: Text(span.name));
        });
  }
}
