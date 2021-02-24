import 'dart:convert';
import 'dart:io';

import 'package:curbwheel/ui/map/map_database.dart';
import 'package:curbwheel/ui/map/street_review_map_screen.dart';
import 'package:curbwheel/ui/map/street_select_map_screen.dart';
import 'package:curbwheel/utils/spatial_utils.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:turf/helpers.dart';
import '../../database/database.dart';

import 'package:http/http.dart' as http;

const SIGNED_UPLOAD_URL =
    'https://zzkcv3z5xd.execute-api.us-east-1.amazonaws.com/dev';

getSignedUrl(uploadPath) async {
  dynamic body = json.encode({"key": uploadPath});

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var uploadUrlResponse =
      await http.post(SIGNED_UPLOAD_URL, headers: headers, body: body);
  var response = jsonDecode(uploadUrlResponse.body);
  return response['url'];
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    Key key,
    this.project,
  }) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    var _database = Provider.of<CurbWheelDatabase>(context);

    Future<List<Survey>> _surveys =
        _database.surveyDao.getAllSurveysByProjectId(project.id);
    return Card(
      child: InkWell(
        splashColor: Colors.white.withAlpha(100),
        onTap: () async {
          final location = Location();
          final hasPermissions = await location.hasPermission();

          if (hasPermissions != PermissionStatus.granted) {
            await location.requestPermission();
          }
          Navigator.pushNamed(context, StreetSelectMapScreen.routeName,
              arguments: StreetSelectMapScreenArguments(project));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.location_city_sharp),
              trailing: GestureDetector(
                child: Icon(Icons.more_horiz),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(children: <Widget>[
                          ListTile(
                              title: Text(
                            project.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          GestureDetector(
                              child: ListTile(
                                  leading: Icon(Icons.list_alt),
                                  title: Text("Review completed surveys")),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.pushNamed(
                                    context, StreetReviewMapScreen.routeName,
                                    arguments: StreetReviewMapScreenArguments(
                                        project));
                              }),
                          GestureDetector(
                              onTap: () async {
                                Navigator.of(context).pop();

                                String uploadDir =
                                    'projects/' + project.projectId + '/';
                                String surveysPath = uploadDir + 'surveys/';
                                String imagesPath = uploadDir + 'surveys/';

                                ProjectMapDatastore projectMapData =
                                    Provider.of<ProjectMapDatastores>(context,
                                            listen: false)
                                        .getDatastore(project);
                                MapData mapData = await projectMapData.mapData;

                                List<Survey> surveys = await _database.surveyDao
                                    .getAllSurveysByProjectId(project.id);
                                for (Survey survey in surveys) {
                                  List<Feature<LineString>> spanFeatures =
                                      List();
                                  List<Feature<LineString>> pointFeatures =
                                      List();
                                  List<SurveyItem> items = await _database
                                      .surveyItemDao
                                      .getSurveyItemsBySurveyId(survey.id);

                                  Feature<LineString> visualizationFeature =
                                      mapData.getDirectionalGeomByRefId(
                                          survey.shStRefId);
                                  for (SurveyItem item in items) {
                                    FeatureType ft = await _database
                                        .featureTypeDao
                                        .getFeatureById(item.featureId);
                                    if (ft.geometryType == "line") {
                                      List<SurveySpan> spans = await _database
                                          .surveySpanDao
                                          .getSpansBySurveyItemId(item.id);

                                      for (SurveySpan span in spans) {
                                        Feature<LineString> spanFeature =
                                            lineSliceAlong(visualizationFeature,
                                                span.start, span.stop);

                                        Map<String, dynamic> properties = Map();

                                        properties['span_id'] = span.id;
                                        properties['survey_id'] = survey.id;
                                        properties['project_id'] =
                                            survey.projectId;
                                        properties['shst_ref_id'] =
                                            survey.shStRefId;
                                        properties['map_len'] =
                                            survey.mapLength;
                                        properties['measured_len'] =
                                            survey.measuredLength;
                                        properties['side_of_street'] =
                                            survey.side == "SideOfStreet.Right"
                                                ? "right"
                                                : "left";

                                        properties['start'] = span.start;
                                        properties['stop'] = span.stop;

                                        properties['type'] = ft.name;
                                        properties['color'] = ft.color;
                                        spanFeature.properties = properties;

                                        spanFeatures.add(spanFeature);
                                      }
                                    } else if (ft.geometryType == "point") {
                                      List<SurveyPoint> points = await _database
                                          .surveyPointDao
                                          .getPointsBySurveyItemId(item.id);
                                      for (SurveyPoint point in points) {
                                        Feature<LineString> pointFeature =
                                            along(visualizationFeature,
                                                point.position);

                                        Map<String, dynamic> properties = Map();

                                        properties['point_id'] = point.id;
                                        properties['survey_id'] = survey.id;
                                        properties['project_id'] =
                                            survey.projectId;
                                        properties['shst_ref_id'] =
                                            survey.shStRefId;
                                        properties['map_len'] =
                                            survey.mapLength;
                                        properties['measured_len'] =
                                            survey.measuredLength;
                                        properties['side_of_street'] =
                                            survey.side == "SideOfStreet.Right"
                                                ? "right"
                                                : "left";

                                        properties['position'] = point.position;

                                        properties['type'] = ft.name;
                                        properties['color'] = ft.color;

                                        List<Photo> photos = await _database
                                            .photoDao
                                            .getAllPhotosByPointId(point.id);

                                        if (photos.length > 0) {
                                          properties['photos'] =
                                              photos.map((p) {
                                            return p.id;
                                          });
                                        }
                                        pointFeature.properties = properties;
                                        pointFeatures.add(pointFeature);
                                      }
                                    }
                                  }

                                  if (spanFeatures.length > 0) {
                                    FeatureCollection<LineString>
                                        spansFeatureCollection =
                                        new FeatureCollection<LineString>(
                                            features: spanFeatures);
                                    String surveySpansPath =
                                        surveysPath + survey.id + '.spans.json';
                                    String signedSurveySpansUrl =
                                        await getSignedUrl(surveySpansPath);

                                    http.put(signedSurveySpansUrl,
                                        body: json.encode(
                                            spansFeatureCollection.toJson()));
                                  }

                                  if (pointFeatures.length > 0) {
                                    FeatureCollection<LineString>
                                        pointsFeatureCollection =
                                        new FeatureCollection<LineString>(
                                            features: pointFeatures);
                                    String surveyPointsPath = surveysPath +
                                        survey.id +
                                        '.points.json';
                                    String signedSurveyPointsUrl =
                                        await getSignedUrl(surveyPointsPath);

                                    http.put(signedSurveyPointsUrl,
                                        body: json.encode(
                                            pointsFeatureCollection.toJson()));
                                  }

                                  List<Photo> photos =
                                      await _database.photoDao.getAllPhotos();

                                  for (Photo p in photos) {
                                    String imagePath =
                                        imagesPath + p.id + '.jpg';
                                    String signedImageUrl =
                                        await getSignedUrl(imagePath);

                                    var response = await http.put(
                                      signedImageUrl,
                                      headers: {
                                        'Content-Type': 'image/jpeg',
                                      },
                                      body: await File(p.file).readAsBytes(),
                                    );
                                  }
                                }

                                // showDialog<void>(
                                //     context: context,
                                //     barrierDismissible:
                                //         false, // user must tap button!
                                //     builder: (BuildContext context) {
                                //       return AlertDialog(
                                //         title: Text('Project Sync'),
                                //         content: SingleChildScrollView(
                                //           child: ListBody(
                                //             children: <Widget>[
                                //               Text('Project synced'),
                                //             ],
                                //           ),
                                //         ),
                                //         actions: <Widget>[
                                //           TextButton(
                                //             child: Text('Ok'),
                                //             onPressed: () {
                                //               Navigator.of(context).pop();
                                //             },
                                //           ),
                                //         ],
                                //       );
                                //     });
                              },
                              child: ListTile(
                                  leading: Icon(Icons.sync_alt),
                                  title: Text("Sync data"))),
                          GestureDetector(
                              child: ListTile(
                                  leading: Icon(Icons.delete_forever),
                                  title: Text("Delete project")),
                              onTap: () {
                                // set up the buttons

                                Widget cancelButton = FlatButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                );
                                Widget continueButton = FlatButton(
                                  child: Text("Delete"),
                                  onPressed: () {
                                    try {
                                      _database.projectDao
                                          .deleteProject(project);
                                    } catch (e) {
                                      print(e);
                                    }
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                );

                                AlertDialog alert = AlertDialog(
                                  title: Text("Delete Project"),
                                  content: Text(
                                      "Are you sure you want to perminately delete this project and all related data from this phone?"),
                                  actions: [
                                    cancelButton,
                                    continueButton,
                                  ],
                                );

                                // show the dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              }),
                        ]);
                      });
                },
              ),
              title: Text(
                project.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: FutureBuilder<List<Survey>>(
                  future: _surveys,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Survey>> snapshot) {
                    if (snapshot.data != null &&
                        snapshot.data.length != null &&
                        snapshot.data.length > 0)
                      return Text(snapshot.data.length.toString() +
                          " streets surveyed");
                    else
                      return Text("Ready survey!");
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
