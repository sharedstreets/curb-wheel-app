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
    await _database.surveyItemDao.deleteSurveyItem(surveyItem);
    List<SurveySpan> spans =
        await _database.surveySpanDao.getSpansBySurveyItemId(surveyItem.id);
    for (SurveySpan span in spans) {
      await _database.surveySpanDao.deleteSpan(span);
    }
    List<SurveyPoint> points =
        await _database.surveyPointDao.getPointsBySurveyItemId(surveyItem.id);
    for (SurveyPoint point in points) {
      await _database.surveyPointDao.deletePoint(point);
    }
    List<Photo> photos =
        await _database.photoDao.getPhotosBySurveyItemId(surveyItem.id);
    for (Photo photo in photos) {
      await _database.photoDao.deletePhoto(photo);
      File file = File(photo.file);
      file.deleteSync();
    }
  }
}
