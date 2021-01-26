import 'dart:async';

import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/ui/wheel/progress.dart';
import 'package:flutter/material.dart';
import 'package:curbwheel/ui/shared/utils.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CompleteList extends StatefulWidget {
  final Survey survey;

  CompleteList(this.survey);

  @override
  _CompleteListState createState() => _CompleteListState();
}

class _CompleteListState extends State<CompleteList> {
  CurbWheelDatabase _database;
  Survey _survey;

  @override
  Widget build(BuildContext context) {
    _database = Provider.of<CurbWheelDatabase>(context);
    _survey = widget.survey;
    Future<List<Feature>> _features =
        _database.featureDao.getAllFeaturesByProject(_survey.projectId);

    return FutureBuilder<List<Feature>>(
        future: _features,
        builder: (BuildContext context, AsyncSnapshot<List<Feature>> snapshot) {
          if (snapshot.hasData) {
            var features = snapshot.data;
            print(features);
            return StreamBuilder(
                stream: _database.spanDao.watchSpansBySurvey(_survey),
                builder: (context, AsyncSnapshot<List<Span>> snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      print(snapshot.data[index]);
                      var color = features.where((feature) =>
                          (feature.label == snapshot.data[index].name));
                      print("color");
                      print(color);
                      return InactiveSpanCard(
                          snapshot.data[index], color.elementAt(0).color);
                    },
                  );
                });
          } else {
            return Text("FOO");
          }
        });
  }
}

class InactiveSpanCard extends StatefulWidget {
  final Span span;
  final String color;

  InactiveSpanCard(this.span, this.color);

  @override
  _InactiveSpanCardState createState() => _InactiveSpanCardState();
}

class _InactiveSpanCardState extends State<InactiveSpanCard> {
  @override
  Widget build(BuildContext context) {
    var _span = widget.span;
    var _color = widget.color;

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
                      onPressed: () => {},
                    )
                  ]),
                  Padding(
                      padding: EdgeInsets.all(2.0),
                      child: ProgressBar(
                          start: _span.start,
                          progress: _span.stop,
                          progressColor: colorConvert(_color),
                          points: [])), //_span.points)),
                  Text(
                      "${_span.start * 40}m-${(_span.stop * 40).toStringAsFixed(1)}m"),
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
