import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'survey_point_dao.g.dart';

@UseDao(tables: [SurveyPoints, SurveyItems, Surveys])
class SurveyPointDao extends DatabaseAccessor<CurbWheelDatabase>
    with _$SurveyPointDaoMixin {
  SurveyPointDao(CurbWheelDatabase db) : super(db);

  Future<List<SurveyPoint>> getAllPoints() => select(surveyPoints).get();

  Stream<List<SurveyPoint>> watchAllPoints() => select(surveyPoints).watch();

  Future insertPoint(SurveyPointsCompanion surveyPoint) =>
      into(surveyPoints).insert(surveyPoint);

  Future updatePoint(SurveyPoint surveyPoint) =>
      update(surveyPoints).replace(surveyPoint);

  Future deletePoint(SurveyPoint surveyPoint) =>
      delete(surveyPoints).delete(surveyPoint);

  Future<List<SurveyPoint>> getPointsBySurveyItemId(String surveyItemId) =>
      (select(surveyPoints)
            ..where((sp) => sp.surveyItemId.equals(surveyItemId)))
          .get();

  Future<List<SurveyPoint>> getPointsBySurveyId(String surveyId) =>
      (select(surveyPoints)
            ..where((t) => surveys.id.equals(surveyId))
            ..join([
              innerJoin(surveyItems,
                  surveyItems.id.equalsExp(surveyPoints.surveyItemId)),
              innerJoin(surveys, surveys.id.equalsExp(surveyItems.surveyId))
            ]))
          .get();

  Future<List<SurveyPoint>> getPointsByProjectId(String projectId) =>
      (select(surveyPoints)
            ..where((t) => surveys.projectId.equals(projectId))
            ..join([
              innerJoin(surveyItems,
                  surveyItems.id.equalsExp(surveyPoints.surveyItemId)),
              innerJoin(surveys, surveys.id.equalsExp(surveyItems.surveyId))
            ]))
          .get();
}
