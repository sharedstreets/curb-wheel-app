import 'package:curbwheel/database/models.dart';
import 'package:rxdart/rxdart.dart';

import 'survey_span_dao.dart';
import 'project_dao.dart';
import 'survey_dao.dart';
import 'survey_item_dao.dart';
import 'survey_point_dao.dart';
import 'photo_dao.dart';
import 'feature_type_dao.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'database.g.dart';

class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get projectConfigUrl => text()();
  TextColumn get projectId => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get organization => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Surveys extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text()();
  TextColumn get shStRefId => text()();
  TextColumn get streetName => text()();
  RealColumn get length => real()();
  TextColumn get startStreetName => text()();
  TextColumn get endStreetName => text()();
  TextColumn get direction => text()();
  TextColumn get side => text()();
  BoolColumn get complete => boolean().nullable()();
  DateTimeColumn get endTimestamp => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SurveyItems extends Table {
  TextColumn get id => text()();
  TextColumn get surveyId => text()();
  TextColumn get featureId => text()();
  BoolColumn get complete => boolean()();
  //TextColumn get gps => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SurveySpans extends Table {
  TextColumn get id => text()();
  TextColumn get surveyItemId => text()();
  RealColumn get start => real()();
  RealColumn get stop => real()();

  @override
  Set<Column> get primaryKey => {id};
}

class SurveyPoints extends Table {
  TextColumn get id => text()();
  TextColumn get surveyItemId => text().nullable()();
  RealColumn get position => real()();

  @override
  Set<Column> get primaryKey => {id};
}

class Photos extends Table {
  TextColumn get id => text()();
  TextColumn get pointId => text()();
  TextColumn get file => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class FeatureTypes extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text()();
  TextColumn get geometryType => text()(); // 'point' or 'line'
  TextColumn get color => text()(); // string of color hex code
  TextColumn get name => text()(); // label to be displayed in app

  @override
  Set<Column> get primaryKey => {id};
}

@UseMoor(tables: [
  Projects,
  FeatureTypes,
  Surveys,
  SurveyItems,
  SurveySpans,
  SurveyPoints,
  Photos,
], daos: [
  ProjectDao,
  FeatureTypeDao,
  SurveyDao,
  SurveyItemDao,
  SurveySpanDao,
  SurveyPointDao,
  PhotoDao
])
class CurbWheelDatabase extends _$CurbWheelDatabase {
  CurbWheelDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'curb-wheel-db.sqlite'));

  @override
  int get schemaVersion => 1;

  Stream<Count> getListItemCounts(String surveyId) {
    final surveyItemQuery =
        (select(surveyItems)..where((s) => s.surveyId.equals(surveyId)));
    final Stream<List<SurveyItem>> completeSurveyItemStream =
        surveyItemQuery.watch().map((rows) {
      return rows.where((item) => item.complete == true).toList();
    });
    final Stream<List<SurveyItem>> activeSurveyItemStream =
        surveyItemQuery.watch().map((rows) {
      return rows.where((item) => item.complete == false).toList();
    });
    return Rx.combineLatest2(completeSurveyItemStream, activeSurveyItemStream,
        (List<SurveyItem> a, List<SurveyItem> b) {
      Count count = Count(completeCount: a.length, activeCount: b.length);
      return count;
    });
  }

  Stream<List<ListItem>> getListItemBySurveyId(String surveyId, bool complete) {
    final query = (select(surveyItems).join([
      leftOuterJoin(
          featureTypes, featureTypes.id.equalsExp(surveyItems.featureId)),
      leftOuterJoin(
          surveySpans, surveySpans.surveyItemId.equalsExp(surveyItems.id)),
    ]));
    final Stream<List<SurveyItemWithFeature>> surveyItemWithFeatureStream =
        query.watch().map((rows) {
      var filtered = rows
          .map((row) {
            final surveyItemWithFeature = SurveyItemWithFeature(
              row.readTable(surveyItems),
              row.readTable(featureTypes),
            );
            return surveyItemWithFeature;
          })
          .where((item) => item.surveyItem.surveyId == surveyId)
          .where((item) => item.surveyItem.complete == complete)
          .toList();
      return filtered;
    });
    final pointsQuery = select(surveyPoints);
    final Stream<List<PointContainer>> pointsStream =
        pointsQuery.watch().map((rows) {
      return rows.map((row) {
        return PointContainer(
            id: row.id, surveyItemId: row.surveyItemId, position: row.position);
      }).toList();
    });

    final spanQuery = select(surveySpans);
    final Stream<List<SpanContainer>> spanStream =
        spanQuery.watch().map((rows) {
      return rows.map((row) {
        return SpanContainer(
            id: row.id,
            surveyItemId: row.surveyItemId,
            start: row.start,
            stop: row.stop);
      }).toList();
    });

    return Rx.combineLatest3(
        surveyItemWithFeatureStream, pointsStream, spanStream,
        (List<SurveyItemWithFeature> a, List<PointContainer> b,
            List<SpanContainer> c) {
      var combined = a.map((surveyItem) {
        String surveyItemId = surveyItem.surveyItem.id;
        final List<PointContainer> points =
            b?.where((point) => point.surveyItemId == surveyItemId)?.toList();

        if (surveyItem.feature.geometryType == "line") {
          final span =
              c?.where((span) => span.surveyItemId == surveyItemId)?.toList();
          final listItem = ListItem(
              surveyItemId: surveyItemId,
              surveyId: surveyItem.surveyItem.surveyId,
              geometryType: surveyItem.feature.geometryType,
              featureId: surveyItem.feature.id,
              color: surveyItem.feature.color,
              name: surveyItem.feature.name,
              span: span[0],
              points: points);
          return listItem;
        } else {
          final listItem = ListItem(
              surveyItemId: surveyItemId,
              surveyId: surveyItem.surveyItem.surveyId,
              geometryType: surveyItem.feature.geometryType,
              featureId: surveyItem.feature.id,
              color: surveyItem.feature.color,
              name: surveyItem.feature.name,
              points: points);
          return listItem;
        }
      }).toList();
      return combined;
    });
  }
}
