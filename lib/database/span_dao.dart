import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'span_dao.g.dart';

@UseDao(tables: [Spans])
class SpanDao extends DatabaseAccessor<CurbWheelDatabase> with _$SpanDaoMixin {
  SpanDao(CurbWheelDatabase db) : super(db);

  Future<List<Span>> getAllSpans() => select(spans).get();

  Stream<List<Span>> watchAllSpans() => select(spans).watch();

  Stream<List<Span>> watchSpansBySurvey(Survey survey) =>
      (select(spans)..where((s) => s.surveyId.equals(survey.id))).watch();

  Future insertSpan(SpansCompanion span) => into(spans).insert(span);

  Future updateSpan(Span span) => update(spans).replace(span);

  Future deleteSpan(Span span) => delete(spans).delete(span);
}