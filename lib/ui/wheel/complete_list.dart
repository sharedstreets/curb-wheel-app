import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/database/models.dart';
import 'package:curbwheel/ui/camera/gallery_screen.dart';
import 'package:curbwheel/utils/survey_utils.dart';
import 'package:flutter/material.dart';
import 'package:curbwheel/ui/shared/utils.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:progresso/progresso.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompleteList extends StatefulWidget {
  final SurveyManager surveyManager;
  final Survey survey;

  CompleteList(this.surveyManager, this.survey);

  @override
  _CompleteListState createState() => _CompleteListState();
}

class _CompleteListState extends State<CompleteList> {
  CurbWheelDatabase _database;
  Survey _survey;

  Future<void> _showDeleteDialog(ListItem listItem) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).deleteWarningTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context).deleteWarningBody),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(AppLocalizations.of(context).cancel),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
                child: Text(AppLocalizations.of(context).delete),
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
    _database = Provider.of<CurbWheelDatabase>(context);
    _survey = widget.survey;
    return Container(
        child: StreamBuilder(
            stream: _database.getListItemBySurveyId(_survey.id, true),
            builder: (context, AsyncSnapshot<List<ListItem>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0) {
                  return Center(
                      child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                              AppLocalizations.of(context).noCompleteItems,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20))));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return InactiveCard(
                          snapshot.data[index], _survey, _showDeleteDialog);
                    },
                  );
                }
              } else {
                return Text(AppLocalizations.of(context).noCompleteItems);
              }
            }));
  }
}

class InactiveCard extends StatefulWidget {
  final ListItem listItem;
  final Survey survey;
  final Function deleteCallback;

  InactiveCard(this.listItem, this.survey, this.deleteCallback);

  @override
  _InactiveCardState createState() => _InactiveCardState();
}

class _InactiveCardState extends State<InactiveCard> {
  @override
  Widget build(BuildContext context) {
    Function _deleteCallback = widget.deleteCallback;
    var _listItem = widget.listItem;
    var _max = widget.survey.mapLength;
    var _stop = _listItem.geometryType == 'line'
        ? _listItem.span.stop
        : _listItem.points[0].position;
    var _start = _listItem.geometryType == 'line'
        ? _listItem.span.start
        : _listItem.points[0].position;

    List<double> _points = _listItem.points.map((p) {
      return p.position;
    }).toList();
    final String assetName = _listItem.geometryType == 'line'
        ? 'assets/vector-line.svg'
        : 'assets/map-marker.svg';
    final String semanticsLabel =
        _listItem.geometryType == 'line' ? 'line type' : 'point type';
    final Widget svgIcon = SvgPicture.asset(assetName,
        color: Colors.black, semanticsLabel: semanticsLabel);
    var positionString;
    if (_listItem.geometryType == "line") {
      positionString = "${_start}m-${(_stop).toStringAsFixed(1)}m";
    } else {
      positionString = "${_start}m";
    }
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
                child: Row(children: [
                  svgIcon,
                  Text(_listItem.name),
                  Spacer(),
                ]),
              ),
              Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Progresso(
                      start: _start / _max,
                      progress: _stop / _max,
                      progressColor: colorConvert(_listItem.color),
                      progressStrokeCap: StrokeCap.round,
                      backgroundStrokeCap: StrokeCap.round,
                      points: _points)),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                  child: Text(positionString)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .viewPhotos))
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
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .delete))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                                  child: Divider(
                                      thickness: 1.0, color: Colors.grey),
                                ),
                                TextButton(
                                  onPressed: () => {Navigator.pop(context)},
                                  style: TextButton.styleFrom(
                                    primary: Colors.black,
                                    padding: EdgeInsets.all(10.0),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.close),
                                      Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .cancel))
                                    ],
                                  ),
                                ),
                              ],
                            ));
                  },
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
