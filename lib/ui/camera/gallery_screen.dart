import 'dart:io';

import 'package:curbwheel/database/models.dart';

import '../../database/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GalleryScreenArguments {
  final String projectId;
  final String surveyId;
  final String surveyItemId;

  GalleryScreenArguments({this.projectId, this.surveyId, this.surveyItemId});
}

class GalleryScreen extends StatefulWidget {

  static const routeName = '/gallery';


  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    final GalleryScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    final String _projectId = args.projectId;
    final String _surveyId = args.surveyId;
    final String _surveyItemId = args.surveyItemId;
    CurbWheelDatabase _database = Provider.of<CurbWheelDatabase>(context);
    Stream<List<PhotoWithParents>> _photos;
    if (_projectId != null) {
      _photos = _database.photoDao.watchPhotosByProject(_projectId);
    } else if (_surveyId != null) {
      _photos = _database.photoDao.watchPhotosBySurvey(_surveyId);
    } else if (_surveyItemId != null) {
      _photos = _database.photoDao.watchPhotosBySurveyItem(_surveyItemId);
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
