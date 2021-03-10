import 'dart:io';

import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/database/models.dart';
import 'package:curbwheel/ui/camera/camera_screen.dart';
import 'package:curbwheel/ui/camera/gallery_screen.dart';
import 'package:curbwheel/ui/shared/utils.dart';
import 'package:curbwheel/utils/survey_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progresso/progresso.dart';
import 'package:provider/provider.dart';

class IncompleteList extends StatefulWidget {
  final SurveyManager surveyManager;
  final Survey survey;
  final double currentWheelPosition;

  IncompleteList(this.surveyManager, this.survey, this.currentWheelPosition);

  @override
  _IncompleteListState createState() => _IncompleteListState();
}

class _IncompleteListState extends State<IncompleteList> {
  CurbWheelDatabase _database;

  void _completeItem(ListItem listItem, double _wheelCounter) async {
    if (listItem.geometryType == 'line') {
      listItem.span.stop = _wheelCounter;
    }

    listItem.complete = true;
    SurveyItem surveyItem = listItem.toSurveyItem();
    await _database.surveyItemDao.updateSurveyItem(surveyItem);
    if (listItem.geometryType == 'line') {
      SurveySpan currentSpan = listItem.toSurveySpan();
      await _database.surveySpanDao.updateSpan(currentSpan);
    }
  }

  Future<void> _showDeleteDialog(ListItem listItem) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete item?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this survey item?'),
                Text('This cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
                child: Text('Delete'),
                onPressed: () {
                  widget.surveyManager
                      .deleteSurveyItem(listItem.toSurveyItem());
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Survey _survey = widget.survey;

    _database = Provider.of<CurbWheelDatabase>(context);
    return Container(
        child: StreamBuilder(
            stream: _database.getListItemBySurveyId(_survey.id, false),
            builder: (context, AsyncSnapshot<List<ListItem>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0) {
                  return Center(
                      child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('No active items',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20))));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ActiveCard(
                          _survey,
                          snapshot.data[index],
                          widget.currentWheelPosition,
                          _completeItem,
                          _showDeleteDialog);
                    },
                  );
                }
              } else {
                return Text("No data");
              }
            }));
  }
}

class ActiveCard extends StatefulWidget {
  final Survey survey;
  final ListItem listItem;
  final double currentWheelPosition;
  final Function completeCallback;
  final Function deleteCallback;

  ActiveCard(this.survey, this.listItem, this.currentWheelPosition,
      this.completeCallback, this.deleteCallback);

  @override
  _ActiveCardState createState() => _ActiveCardState();
}

class _ActiveCardState extends State<ActiveCard> {
  @override
  Widget build(BuildContext context) {
    ListItem _listItem = widget.listItem;
    Function _completeCallback = widget.completeCallback;
    Function _deleteCallback = widget.deleteCallback;

    var _start = _listItem.geometryType == "line"
        ? _listItem.span.start
        : _listItem.points[0].position;
    var _wheelPosition = _listItem.geometryType == "line"
        ? widget.currentWheelPosition
        : _listItem.points[0].position;
    var _max = widget.survey.mapLength;
    var _progress = _wheelPosition / _max;
    var _points = _listItem.points.map((p) => p.position).toList();

    final String assetName = _listItem.geometryType == 'line'
        ? 'assets/vector-line.svg'
        : 'assets/map-marker.svg';
    final String semanticsLabel =
        _listItem.geometryType == 'line' ? 'line type' : 'point type';
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
                    Text(_listItem.name),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () => _completeCallback(
                          _listItem, widget.currentWheelPosition),
                    )
                  ]),
                  Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Progresso(
                          start: _start / _max,
                          progress: _progress,
                          progressColor: colorConvert(_listItem.color),
                          progressStrokeCap: StrokeCap.round,
                          backgroundStrokeCap: StrokeCap.round,
                          pointColor: colorConvert(_listItem.color),
                          points: _points)
                    ),
                  _listItem.geometryType == "line"
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                          child: Text(
                              "${(_start).toStringAsFixed(1)}m-${(_wheelPosition).toStringAsFixed(1)}m"))
                      : Padding(
                          padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                          child: Text("${(_start).toStringAsFixed(1)}m")),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.more_horiz),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Wrap(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            svgIcon,
                                            Text(_listItem.name),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => {
                                          Navigator.pushNamed(
                                              context, GalleryScreen.routeName,
                                              arguments: GalleryScreenArguments(
                                                  surveyItemId:
                                                      _listItem.surveyItemId))
                                        },
                                        style: TextButton.styleFrom(
                                          primary: Colors.black,
                                          padding: EdgeInsets.all(10.0),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.image_sharp),
                                            Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text("View photos"))
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          return _deleteCallback(_listItem);
                                        },
                                        style: TextButton.styleFrom(
                                          primary: Colors.black,
                                          padding: EdgeInsets.all(10.0),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.delete),
                                            Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text("Delete"))
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            8.0, 0.0, 8.0, 0.0),
                                        child: Divider(
                                            thickness: 1.0, color: Colors.grey),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            {Navigator.pop(context)},
                                        style: TextButton.styleFrom(
                                          primary: Colors.black,
                                          padding: EdgeInsets.all(10.0),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.close),
                                            Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text("Cancel"))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ));
                        },
                      ),
                      IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () => {
                                Navigator.pushNamed(
                                    context, CameraScreen.routeName,
                                    arguments: CameraScreenArguments(
                                        surveyItemId: _listItem.surveyItemId,
                                        position: widget.currentWheelPosition))
                              })
                    ],
                  )
                ],
              ),
            )));
  }
}

class ItemBottomSheet extends StatelessWidget {
  final SurveyItem surveyItem;

  ItemBottomSheet(this.surveyItem);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
