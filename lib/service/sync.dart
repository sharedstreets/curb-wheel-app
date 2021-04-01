import 'dart:convert';
import 'dart:io';

import 'package:curbwheel/ui/map/map_database.dart';
import 'package:curbwheel/utils/spatial_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turf/helpers.dart';
import 'package:curbwheel/database/database.dart';

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

class ProjectSyncStatus {
  Project project;
  String currentStatus;
  String currentFile;
  int totalFiles;
  int completeFiles;
  int failedFiles;
  bool syncInProgress;
}

class ProjectSyncService extends ChangeNotifier {
  ProjectMapDatastores _mapDatastore;
  CurbWheelDatabase _database;

  ProjectSyncStatus status;

  ProjectSyncService(BuildContext context) {
    _database = Provider.of<CurbWheelDatabase>(context, listen: false);
    _mapDatastore = Provider.of<ProjectMapDatastores>(context, listen: false);
  }

  syncProject(Project project) async {
    // to do add project FIFO queue with lock

    String uploadDir = 'projects/' + project.projectId + '/';
    String surveysPath = uploadDir + 'surveys/';
    String imagesPath = uploadDir + 'images/';

    ProjectMapDatastore projectMapData = _mapDatastore.getDatastore(project);
    MapData mapData = await projectMapData.mapData;

    List<Survey> surveys =
        await _database.surveyDao.getAllSurveysByProjectId(project.id);

    List<Photo> projectPhotos = [];

    status = ProjectSyncStatus();
    status.project = project;
    status.syncInProgress = true;
    status.totalFiles = 2 * surveys.length;
    status.completeFiles = 0;
    status.currentStatus = "Uploading JSON";
    notifyListeners();

    for (Survey survey in surveys) {
      List<Feature<LineString>> spanFeatures = [];
      List<Feature<Point>> pointFeatures = [];
      List<SurveyItem> items =
          await _database.surveyItemDao.getSurveyItemsBySurveyId(survey.id);

      Feature<LineString> visualizationFeature =
          mapData.getDirectionalGeomByRefId(survey.shStRefId);
      for (SurveyItem item in items) {
        FeatureType ft =
            await _database.featureTypeDao.getFeatureById(item.featureId);
        if (ft.geometryType == "line") {
          List<SurveySpan> spans =
              await _database.surveySpanDao.getSpansBySurveyItemId(item.id);

          for (SurveySpan span in spans) {
            Feature<LineString> spanFeature =
                lineSliceAlong(visualizationFeature, span.start, span.stop);

            Map<String, dynamic> properties = Map();

            properties['span_id'] = span.id;
            properties['survey_id'] = survey.id;
            properties['project_id'] = project.projectId;
            properties['shst_ref_id'] = survey.shStRefId;
            properties['map_len'] = survey.mapLength;
            properties['measured_len'] = survey.measuredLength;
            properties['side_of_street'] =
                survey.side == "SideOfStreet.Right" ? "right" : "left";

            properties['start'] = span.start;
            properties['stop'] = span.stop;

            properties['type'] = ft.value;
            properties['color'] = ft.color;
            spanFeature.properties = properties;

            properties['photos'] = [];

            // join not working in getPhotosBySurveyItemId so doing this manually
            List<SurveyPoint> spanPoints =
                await _database.surveyPointDao.getPointsBySurveyItemId(item.id);
            for (SurveyPoint spanPoint in spanPoints) {
              List<Photo> photos =
                  await _database.photoDao.getAllPhotosByPointId(spanPoint.id);
              for (Photo p in photos) {
                projectPhotos.add(p);
                properties['photos'].add(p.id);
              }
            }

            spanFeatures.add(spanFeature);
          }
        } else if (ft.geometryType == "point") {
          List<SurveyPoint> points =
              await _database.surveyPointDao.getPointsBySurveyItemId(item.id);
          for (SurveyPoint point in points) {
            Feature<Point> pointFeature = new Feature<Point>(
                geometry: along(visualizationFeature, point.position));

            Map<String, dynamic> properties = Map();

            properties['point_id'] = point.id;
            properties['survey_id'] = survey.id;
            properties['project_id'] = project.projectId;
            properties['shst_ref_id'] = survey.shStRefId;
            properties['map_len'] = survey.mapLength;
            properties['measured_len'] = survey.measuredLength;
            properties['side_of_street'] =
                survey.side == "SideOfStreet.Right" ? "right" : "left";

            properties['position'] = point.position;

            properties['type'] = ft.value;
            properties['color'] = ft.color;

            List<Photo> photos =
                await _database.photoDao.getAllPhotosByPointId(point.id);

            properties['photos'] = [];
            for (Photo p in photos) {
              projectPhotos.add(p);
              properties['photos'].add(p.id);
            }
            pointFeature.properties = properties;
            pointFeatures.add(pointFeature);
          }
        }
      }

      if (spanFeatures.length > 0) {
        status.currentFile = survey.id + '.spans.json';
        notifyListeners();

        FeatureCollection<LineString> spansFeatureCollection =
            new FeatureCollection<LineString>(features: spanFeatures);
        String surveySpansPath = surveysPath + survey.id + '.spans.json';
        String signedSurveySpansUrl = await getSignedUrl(surveySpansPath);

        http.Response r = await http.put(signedSurveySpansUrl,
            body: json.encode(spansFeatureCollection.toJson()));

        if (r.statusCode == 200) {
          status.completeFiles++;
          notifyListeners();
        } else {
          // todo handle retrys
          status.failedFiles++;
          notifyListeners();
        }
      }

      if (pointFeatures.length > 0) {
        status.currentFile = survey.id + '.points.json';
        notifyListeners();

        FeatureCollection<Point> pointsFeatureCollection =
            new FeatureCollection<Point>(features: pointFeatures);
        String surveyPointsPath = surveysPath + survey.id + '.points.json';
        String signedSurveyPointsUrl = await getSignedUrl(surveyPointsPath);

        http.Response r = await http.put(signedSurveyPointsUrl,
            body: json.encode(pointsFeatureCollection.toJson()));

        if (r.statusCode == 200) {
          status.completeFiles++;
          notifyListeners();
        } else {
          // todo handle retrys
          status.failedFiles++;
          notifyListeners();
        }
      }
      status.syncInProgress = false;
    }

    status.totalFiles = 2 * projectPhotos.length;
    status.completeFiles = 0;
    status.currentStatus = "Uploading photos";
    notifyListeners();

    for (Photo p in projectPhotos) {
      status.currentFile = p.id + '.png';
      notifyListeners();
      try {

      String imagePath = imagesPath + p.id + '.png';
      String signedImageUrl = await getSignedUrl(imagePath);

      http.Response r = await http.put(
        signedImageUrl,
        headers: {
          'Content-Type': 'image/png',
        },
        body: await File(p.file).readAsBytes(),
      );

      if (r.statusCode == 200) {
        status.completeFiles++;
        notifyListeners();
      } else {
        // todo handle retrys
        status.failedFiles++;
        notifyListeners();
      } }
      catch(Exception e) {
        throw e;  
      }
    }
    status.currentStatus = "Sync complete";
    notifyListeners();
  }
}
