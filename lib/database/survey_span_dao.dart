import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'survey_span_dao.g.dart';

@UseDao(tables: [SurveySpans])
class SurveySpanDao extends DatabaseAccessor<CurbWheelDatabase>
    with _$SurveySpanDaoMixin {
  SurveySpanDao(CurbWheelDatabase db) : super(db);

  Future<List<SurveySpan>> getAllSpans() => select(surveySpans).get();

  Stream<List<SurveySpan>> watchAllSpans() => select(surveySpans).watch();

  Future<SurveySpan> getById(String id) =>
      (select(surveySpans)..where((s) => s.id.equals(id))).getSingle();

  Future<List<SurveySpan>> getSpansBySurveyItemId(String surveyItemId) =>
      select(surveySpans).get();

  Future insertSpan(SurveySpansCompanion surveySpan) =>
      into(surveySpans).insert(surveySpan);

  Future updateSpan(SurveySpan surveySpan) =>
      update(surveySpans).replace(surveySpan);

  Future deleteSpan(SurveySpan surveySpan) =>
      delete(surveySpans).delete(surveySpan);
}
