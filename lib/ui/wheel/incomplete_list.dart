import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/ui/shared/utils.dart';
import 'package:curbwheel/ui/wheel/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:provider/provider.dart';

class SpanContainer {
  final int surveyId;
  final String name;
  final String type;
  final double start;
  final double stop;
  final String color;
  final bool complete;
  final List<double> points;

  SpanContainer(this.surveyId, this.name, this.type, this.start, this.stop,
      this.color, this.complete, this.points);

  SpansCompanion toCompanion() {
    return SpansCompanion(
        surveyId: moor.Value(this.surveyId),
        name: moor.Value(this.name),
        type: moor.Value(this.type),
        start: moor.Value(this.start),
        stop: moor.Value(this.stop),
        complete: moor.Value(this.complete));
  }
}

class IncompleteList extends StatefulWidget {
  final List<SpanContainer> spans;
  final double progress;

  IncompleteList(this.spans, this.progress);

  @override
  _IncompleteListState createState() => _IncompleteListState();
}

class _IncompleteListState extends State<IncompleteList> {
  CurbWheelDatabase _database;

  void _completeSpan(SpanContainer span) {
    print(span);
    _database.spanDao.insertSpan(span.toCompanion());
    setState(() => widget.spans.remove(span));
  }

  @override
  Widget build(BuildContext context) {
    _database = Provider.of<CurbWheelDatabase>(context);
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: widget.spans.isEmpty
          ? Center(child: Text('No spans yet'))
          : ListView.builder(
              shrinkWrap: true,
              itemCount: widget.spans.length,
              itemBuilder: (context, index) {
                return ActiveSpanCard(
                    widget.spans[index], widget.progress, _completeSpan);
              }),
    );
  }
}

class ActiveSpanCard extends StatefulWidget {
  final SpanContainer span;
  final double progress;
  final Function callback;

  ActiveSpanCard(this.span, this.progress, this.callback);

  @override
  _ActiveSpanCardState createState() => _ActiveSpanCardState();
}

class _ActiveSpanCardState extends State<ActiveSpanCard> {
  @override
  Widget build(BuildContext context) {
    var _progress = widget.progress;
    var _span = widget.span;
    var _callback = widget.callback;

    final String assetName = _span.type == 'line'
        ? 'assets/vector-line.svg'
        : 'assets/map-marker.svg';
    final String semanticsLabel =
        _span.type == 'line' ? 'line type' : 'point type';
    final Widget svgIcon = SvgPicture.asset(assetName,
        color: Colors.black, semanticsLabel: semanticsLabel);

    return Padding(
        padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(children: [
                    svgIcon,
                    Text(_span.name),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () => _callback(_span),
                    )
                  ]),
                  Padding(
                      padding: EdgeInsets.all(2.0),
                      child: ProgressBar(
                          start: _span.start,
                          progress: _progress,
                          progressColor: colorConvert(_span.color),
                          points: _span.points)),
                  Text(
                      "${_span.start * 40}m-${(_progress * 40).toStringAsFixed(1)}m"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(Icons.more_horiz), onPressed: () => {}),
                      IconButton(
                          icon: Icon(Icons.camera_alt), onPressed: () => {})
                    ],
                  )
                ],
              ),
            )));
  }
}
