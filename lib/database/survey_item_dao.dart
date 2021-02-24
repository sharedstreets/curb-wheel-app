import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'survey_item_dao.g.dart';

@UseDao(tables: [SurveyItems])
class SurveyItemDao extends DatabaseAccessor<CurbWheelDatabase>
    with _$SurveyItemDaoMixin {
  SurveyItemDao(CurbWheelDatabase db) : super(db);

  Future<List<SurveyItem>> getAllSurveyItems() => select(surveyItems).get();

  Stream<List<SurveyItem>> watchAllSurveyItems() => select(surveyItems).watch();

  Stream<List<SurveyItem>> watchAllSurveyItemsBySurvey(String surveyId) =>
      (select(surveyItems)..where((s) => s.surveyId.equals(surveyId))).watch();

  Future<int> insertSurveyItem(SurveyItemsCompanion surveyItem) =>
      into(surveyItems).insert(surveyItem);

  Future<List<SurveyItem>> getSurveyItemsBySurveyId(String id) =>
      (select(surveyItems)..where((s) => s.surveyId.equals(id))).get();

  Future<SurveyItem> getSurveyItemsById(String id) =>
      (select(surveyItems)..where((s) => s.id.equals(id))).getSingle();

  Future updateSurveyItem(SurveyItem surveyItem) =>
      update(surveyItems).replace(surveyItem);

  Future deleteSurveyItem(SurveyItem surveyItem) =>
      delete(surveyItems).delete(surveyItem);
}
