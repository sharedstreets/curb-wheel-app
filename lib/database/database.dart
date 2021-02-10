import 'package:curbwheel/database/models.dart';
import 'package:rxdart/rxdart.dart';

import 'span_dao.dart';
import 'project_dao.dart';
import 'survey_dao.dart';
import 'survey_item_dao.dart';
import 'point_dao.dart';
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
}

class SurveyItems extends Table {
  TextColumn get id => text()();
  TextColumn get surveyId => text()();
  TextColumn get featureId => text()();
  //TextColumn get gps => text().nullable()();
}

class SurveySpans extends Table {
  TextColumn get id => text()();
  TextColumn get surveyItemId => text()();
  RealColumn get start => real()();
  RealColumn get stop => real()();
}

class SurveyPoints extends Table {
  TextColumn get id => text()();
  TextColumn get surveyItemId => text().nullable()();
  RealColumn get position => real()();
}

class Photos extends Table {
  TextColumn get id => text()();
  TextColumn get pointId => text()();
  TextColumn get file => text()();
}

class FeatureTypes extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text()();
  TextColumn get geometryType => text()(); // 'point' or 'line'
  TextColumn get color => text()(); // string of color hex code
  TextColumn get name => text()(); // label to be displayed in app
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

  Stream<List<ListItem>> getListItemBySurveyId(String surveyId) {
    final query = (select(surveyItems).join([
      leftOuterJoin(featureTypes, featureTypes.id.equalsExp(surveyItems.featureId)),
      leftOuterJoin(surveySpans, surveySpans.surveyItemId.equalsExp(surveyItems.id)),
    ]));
    final Stream<List<SurveyItemWithFeature>> surveyItemWithFeatureStream =
        query.watch().map((rows) {
      return rows
          .map((row) {
            final surveyItemWithFeature = SurveyItemWithFeature(
              row.readTable(surveyItems),
              row.readTable(featureTypes),
            );
            return surveyItemWithFeature;
          })
          .where((item) => item.surveyItem.surveyId == surveyId)
          .toList();
    });
    final pointsQuery = select(surveyPoints);
    final Stream<List<PointContainer>> pointsStream =
        pointsQuery.watch().map((rows) {
      return rows.map((row) {
        return PointContainer(
            surveyItemId: row.surveyItemId, position: row.position);
      }).toList();
    });

    final spanQuery = select(surveySpans);
    final Stream<List<SpanContainer>> spanStream =
        spanQuery.watch().map((rows) {
      return rows.map((row) {
        return SpanContainer(
            surveyItemId: row.surveyItemId, start: row.start, stop: row.stop);
      }).toList();
    });

    return Rx.combineLatest3(
        surveyItemWithFeatureStream, pointsStream, spanStream,
        (List<SurveyItemWithFeature> a, List<PointContainer> b,
            List<SpanContainer> c) {
      return a.map((surveyItem) {
        var surveyItemId = surveyItem.surveyItem.id;
        final points =
            b?.where((point) => point.surveyItemId == surveyItemId)?.toList();
        final span =
            c?.where((span) => span.surveyItemId == surveyItemId)?.toList();
        final listItem = ListItem(
            surveyItemId: surveyItemId,
            geometryType: surveyItem.feature.geometryType,
            color: surveyItem.feature.color,
            name: surveyItem.feature.name,
            span: span[0],
            points: points);
        return listItem;
      }).toList();
    });
  }
}
