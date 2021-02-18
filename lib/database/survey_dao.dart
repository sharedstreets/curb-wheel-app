import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'survey_dao.g.dart';

@UseDao(tables: [Surveys])
class SurveyDao extends DatabaseAccessor<CurbWheelDatabase>
    with _$SurveyDaoMixin {
  SurveyDao(CurbWheelDatabase db) : super(db);

  Future<List<Survey>> getAllSurveys() => select(surveys).get();

  Future<List<Survey>> getAllSurveysByProjectId(String projectId) =>
      (select(surveys)..where((s) => s.projectId.equals(projectId))).get();

  Stream<List<Survey>> watchAllSurveys() => select(surveys).watch();

  Future<int> insertSurvey(SurveysCompanion survey) =>
      into(surveys).insert(survey);

  Future<Survey> getSurveyById(String id) =>
      (select(surveys)..where((s) => s.id.equals(id))).getSingle();

  Future updateSurvey(Survey survey) => update(surveys).replace(survey);

  Future deleteSurvey(Survey survey) => delete(surveys).delete(survey);
}
