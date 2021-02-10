import 'dart:io';
import 'dart:typed_data';

import 'package:curbwheel/ui/camera/camera_screen.dart';
import 'package:curbwheel/ui/wheel/wheel_screen.dart';
import 'package:provider/provider.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:uuid/uuid.dart';
import '../../database/database.dart';
import 'package:flutter/material.dart';

var uuid = Uuid();

class PreviewScreenArguments {
  final String surveyItemId;
  final String filePath;
  final double position;
  final String pointId;

  PreviewScreenArguments(this.surveyItemId, this.filePath,
      {this.position, this.pointId});
}

class PreviewScreen extends StatefulWidget {
  static const routeName = '/image-preview';

  final String surveyItemId;
  final String filePath;
  final double position;
  final String pointId;

  PreviewScreen(
      {this.surveyItemId, this.filePath, this.position, this.pointId});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    String _filePath = widget.filePath;
    double _position = widget.position;
    String _surveyItemId = widget.surveyItemId;
    String _pointId = widget.pointId;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Image.file(
                  File(widget.filePath),
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.black,
                  child: new Center(
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            getBytes().then((bytes) async {
                              var database = Provider.of<CurbWheelDatabase>(
                                  context,
                                  listen: false);
                              String pointId = uuid.v4();
                              SurveyPointsCompanion surveyPoint= SurveyPointsCompanion(
                                  id: moor.Value(pointId),
                                  surveyItemId: moor.Value(_surveyItemId),
                                  position: moor.Value(_position));
                              await database.surveyPointDao
                                  .insertPoint(surveyPoint);
                              await database.photoDao.insertPhoto(
                                  PhotosCompanion(
                                      id: moor.Value(uuid.v4()),
                                      pointId: moor.Value(pointId),
                                      file: moor.Value(_filePath)));
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ])),
                ),
              )
            ],
          ),
        ));
  }

  Future getBytes() async {
    Uint8List bytes = File(widget.filePath).readAsBytesSync();
    return ByteData.view(bytes.buffer);
  }
}
