import 'dart:io';

import 'package:curbwheel/database/models.dart';

import '../../database/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GalleryScreenArguments {
  final Project project;
  final Survey survey;
  final SurveyItem surveyItem;

  GalleryScreenArguments({this.project, this.survey, this.surveyItem});
}

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    final GalleryScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    final Project _project = args.project;
    final Survey _survey = args.survey;
    final SurveyItem _surveyItem = args.surveyItem;
    CurbWheelDatabase _database = Provider.of<CurbWheelDatabase>(context);
    Stream<List<PhotoWithParents>> _photos;
    if (_project != null) {
      _photos = _database.photoDao.watchPhotosByProject(_project);
    } else if (_survey != null) {
      _photos = _database.photoDao.watchPhotosBySurvey(_survey);
    } else if (_surveyItem != null) {
      _photos = _database.photoDao.watchPhotosBySurveyItem(_surveyItem);
    } else {
      _photos = _database.photoDao.watchAllPhotos();
    }
    return Scaffold(
      appBar: AppBar(title: Text("Photos")),
      body: StreamBuilder(
        stream: _photos,
        builder: (context, AsyncSnapshot<List<PhotoWithParents>> snapshot) {
          return Column(
            children: <Widget>[
              Expanded(
                child: GridView.builder(
                    itemCount: snapshot.data.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return new GestureDetector(
                        child: new Card(
                          elevation: 5.0,
                          child: Image.file(
                            File(snapshot.data[index].photo.file),
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}
