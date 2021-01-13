import 'span_dao.dart';
import 'project_dao.dart';
import 'survey_dao.dart';
import 'point_dao.dart';
import 'feature_dao.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'database.g.dart';

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get projectId => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get organization => text()();
}

class Surveys extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get shStRefId => text()();
  TextColumn get side => text()();
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
  TextColumn get geometryType => text()();
  TextColumn get color => text()();
  TextColumn get label => text()();
  TextColumn get value => text()();
}

@UseMoor(tables: [
  Projects,
  Features,
  Surveys,
  Spans,
  Points
], daos: [
  ProjectDao,
  FeatureDao,
  SurveyDao,
  SpanDao,
  PointDao,
])
class CurbWheelDatabase extends _$CurbWheelDatabase {
  CurbWheelDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'curb-wheel-db.sqlite'));

  @override
  int get schemaVersion => 1;
}
