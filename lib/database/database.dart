import 'span_dao.dart';
import 'project_dao.dart';
import 'survey_dao.dart';
import 'survey_item_dao.dart';
import 'point_dao.dart';
import 'feature_dao.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'database.g.dart';

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get projectConfigUrl => text()();
  TextColumn get projectId => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get organization => text()();
}

class Surveys extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer()();
  TextColumn get shStRefId => text()();
  TextColumn get streetName => text()();
  RealColumn get length => real()();
  TextColumn get startStreetName => text()();
  TextColumn get endStreetName => text()();
  TextColumn get direction => text()();
  TextColumn get side => text()();
}

class SurveyItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surveyId => integer()();
  IntColumn get childId => integer().nullable()();
  TextColumn get type => text()();
  //TextColumn get gps => text().nullable()();
}

class Spans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surveyId => integer()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  RealColumn get start => real()();
  RealColumn get stop => real()();
  BoolColumn get complete => boolean()();
}

class Points extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get photoId => integer()();
  TextColumn get type => text()();
  RealColumn get position => real()();
}

class Features extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer()();
  TextColumn get geometryType => text()(); // 'point' or 'line'
  TextColumn get color => text()(); // string of color hex code
  TextColumn get label => text()(); // label to be displayed in app
  TextColumn get value => text()(); // CurbLR feature type if using
}

class SurveyItemWithPointsSpans {
  SurveyItemWithPointsSpans(this.surveyItem, this.point, this.span);

  final SurveyItem surveyItem;
  final Point point;
  final Span span;
}



@UseMoor(tables: [
  Projects,
  Features,
  Surveys,
  SurveyItems,
  Spans,
  Points,
], daos: [
  ProjectDao,
  FeatureDao,
  SurveyDao,
  SurveyItemDao,
  SpanDao,
  PointDao,
])
class CurbWheelDatabase extends _$CurbWheelDatabase {
  CurbWheelDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'curb-wheel-db.sqlite'));

  @override
  int get schemaVersion => 1;

  // in the database class, we can then load the category for each entry
  Stream<List<SurveyItemWithPointsSpans>> surveyItemWithPointsSpans() {
    final query = select(surveyItems).join([
      leftOuterJoin(points, (points.id.equalsExp(surveyItems.childId) & surveyItems.type.equals("point"))),
      leftOuterJoin(spans, (spans.id.equalsExp(surveyItems.childId) & surveyItems.type.equals("line"))),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return SurveyItemWithPointsSpans(
          row.readTable(surveyItems),
          row.readTable(points),
          row.readTable(spans),
        );
      }).toList();
    });

    // see next section on how to parse the result
  }
}
