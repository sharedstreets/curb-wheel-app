import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'point_dao.g.dart';

@UseDao(tables: [SurveyPoints])
class SurveyPointDao extends DatabaseAccessor<CurbWheelDatabase>
    with _$SurveyPointDaoMixin {
  SurveyPointDao(CurbWheelDatabase db) : super(db);

  Future<List<SurveyPoint>> getAllPoints() => select(surveyPoints).get();

  Stream<List<SurveyPoint>> watchAllPoints() => select(surveyPoints).watch();

  Future<List<SurveyPoint>> getPointsBySurveyItemId(String surveyItemId) =>
      select(surveyPoints).get();

  Future insertPoint(SurveyPointsCompanion surveyPoint) =>
      into(surveyPoints).insert(surveyPoint);

  Future updatePoint(SurveyPoint surveyPoint) =>
      update(surveyPoints).replace(surveyPoint);

  Future deletePoint(SurveyPoint surveyPoint) =>
      delete(surveyPoints).delete(surveyPoint);
}
