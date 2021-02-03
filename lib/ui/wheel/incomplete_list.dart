import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/database/models.dart';
import 'package:curbwheel/ui/shared/utils.dart';
import 'package:curbwheel/ui/wheel/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class IncompleteList extends StatefulWidget {
  final List<ListItem> listItems;
  final double progress;

  IncompleteList(this.listItems, this.progress);

  @override
  _IncompleteListState createState() => _IncompleteListState();
}

class _IncompleteListState extends State<IncompleteList> {
  CurbWheelDatabase _database;

  void _completeItem(ListItem listItem, double progress) async {
    List<PointsCompanion> pointsCompanions;
    int surveyItemId = await _database.surveyItemDao
        .insertSurveyItem(listItem.toSurveyItemsCompanion());
    if (listItem.geometryType == 'line') {
      listItem.span.stop = progress;
      int spanId = await _database.spanDao
          .insertSpan(listItem.toSpansCompanion(surveyItemId));
      pointsCompanions = listItem.toPointsCompanion(surveyItemId, spanId);
    } else {
      pointsCompanions = listItem.toPointsCompanion(surveyItemId, null);
    }
    for (var pointsCompanion in pointsCompanions) {
      await _database.pointDao.insertPoint(pointsCompanion);
    }
    setState(() => widget.listItems.remove(listItem));
  }

  @override
  Widget build(BuildContext context) {
    _database = Provider.of<CurbWheelDatabase>(context);
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: widget.listItems.isEmpty
          ? Center(
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('No active items',
                      style: TextStyle(color: Colors.black, fontSize: 20))))
          : ListView.builder(
              shrinkWrap: true,
              itemCount: widget.listItems.length,
              itemBuilder: (context, index) {
                return ActiveCard(
                    widget.listItems[index], widget.progress, _completeItem);
              }),
    );
  }
}

class ActiveCard extends StatefulWidget {
  final ListItem listItem;
  final double progress;
  final Function callback;

  ActiveCard(this.listItem, this.progress, this.callback);

  @override
  _ActiveCardState createState() => _ActiveCardState();
}

class _ActiveCardState extends State<ActiveCard> {
  @override
  Widget build(BuildContext context) {
    var _progress = widget.progress;
    var _listItem = widget.listItem;
    var _callback = widget.callback;

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
                      onPressed: () => _callback(_listItem, _progress),
                    )
                  ]),
                  Padding(
                      padding: EdgeInsets.all(2.0),
                      child: ProgressBar(
                          start: _listItem.span.start,
                          progress: _progress,
                          progressColor: colorConvert(_listItem.color),
                          points: _listItem.points
                              .map((p) => p.position)
                              .toList())),
                  Text(
                      "${_listItem.span.start * 40}m-${(_progress * 40).toStringAsFixed(1)}m"),
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
