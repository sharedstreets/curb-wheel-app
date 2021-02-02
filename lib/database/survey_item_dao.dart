import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'survey_item_dao.g.dart';

@UseDao(tables: [SurveyItems])
class SurveyItemDao extends DatabaseAccessor<CurbWheelDatabase>
    with _$SurveyItemDaoMixin {
  SurveyItemDao(CurbWheelDatabase db) : super(db);

  Future<List<SurveyItem>> getAllSurveyItems() => select(surveyItems).get();

  Stream<List<SurveyItem>> watchAllSurveyItems() => select(surveyItems).watch();

  Stream<List<SurveyItem>> watchAllSurveyItemsBySurvey(int surveyId) =>
      (select(surveyItems)..where((s) => s.surveyId.equals(surveyId))).watch();

  Future<int> insertSurveyItem(SurveyItemsCompanion surveyItem) =>
      into(surveyItems).insert(surveyItem);

  Future<SurveyItem> getSurveyItemsById(int id) =>
      (select(surveyItems)..where((s) => s.id.equals(id))).getSingle();

  Future updateSurveyItems(SurveyItem surveyItem) =>
      update(surveyItems).replace(surveyItem);

  Future deleteSurveyItems(SurveyItem surveyItem) =>
      delete(surveyItems).delete(surveyItem);
}