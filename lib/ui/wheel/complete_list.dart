import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/database/models.dart';
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
    return Container(
      child: Column(
        children: [
          CompletedListHeader(),
          StreamBuilder(
            stream: _database.getListItemBySurveyId(_survey.id),
            builder: (context, AsyncSnapshot<List<ListItem>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return InactiveCard(snapshot.data[index]);
                  },
                );
              } else {
                return Text("No items");
              }
            })
        ],
      ),
    );
  }
}


class CompletedListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Text("Completed Items", style: TextStyle(color: Colors.black,fontSize: 20)),
        Divider(color: Colors.grey)
      ],)
      
    );
  }
}

class InactiveCard extends StatefulWidget {
  final ListItem listItem;

  InactiveCard(this.listItem);

  @override
  _InactiveCardState createState() => _InactiveCardState();
}

class _InactiveCardState extends State<InactiveCard> {
  @override
  Widget build(BuildContext context) {
    var _listItem = widget.listItem;

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
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    child: Row(
                    children: [
                    svgIcon,
                    Text(_listItem.name),
                    Spacer(),
                  ]),
                  ),
                  Padding(
                      padding: EdgeInsets.all(2.0),
                      child: ProgressBar(
                          start: _listItem.span.start,
                          progress: _listItem.span.stop,
                          progressColor: colorConvert(_listItem.color),
                          points: [])), //_span.points)),
                  Text(
                      "${_listItem.span.start * 40}m-${(_listItem.span.stop * 40).toStringAsFixed(1)}m"),
                ],
              ),
            )));
  }
}
