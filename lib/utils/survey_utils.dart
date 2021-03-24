import 'dart:io';

import 'package:curbwheel/database/database.dart';

class SurveyManager {
  final CurbWheelDatabase _database;

  SurveyManager(this._database);

  deleteSurvey(Survey survey) async {
    List<SurveyItem> surveyItems =
        await _database.surveyItemDao.getSurveyItemsBySurveyId(survey.id);
    for (var surveyItem in surveyItems) {
      await deleteSurveyItem(surveyItem);
    }
    await _database.surveyDao.deleteSurvey(survey);
  }

  deleteSurveyItem(SurveyItem surveyItem) async {
    List<SurveyPoint> points =
        await _database.surveyPointDao.getPointsBySurveyItemId(surveyItem.id);

    for (SurveyPoint point in points) {
      await _database.surveyPointDao.deletePoint(point);
      // this is a hack because the joins in getPhotosBySurveyItemId doesnt seem to work...
      List<Photo> photos = await _database.photoDao.getAllPhotosByPointId(point.id);
      if (photos.isNotEmpty) {
        for (Photo photo in photos) {
          File file = File(photo.file);
          file.deleteSync();
          await _database.photoDao.deletePhoto(photo);
        }
      }
    }

    List<SurveySpan> spans =
        await _database.surveySpanDao.getSpansBySurveyItemId(surveyItem.id);

    for (SurveySpan span in spans) {
      await _database.surveySpanDao.deleteSpan(span);
    }
    await _database.surveyItemDao.deleteSurveyItem(surveyItem);
  }
}
