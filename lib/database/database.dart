import 'curb_dao.dart';
import 'project_dao.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'database.g.dart';

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get projectId => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get organization => text()();
}

class Curbs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get shStRefId => text()();
  TextColumn get side => text()();
  RealColumn get start => real()();
  RealColumn get stop => real()();
  BoolColumn get complete => boolean()();
}

@UseMoor(tables: [Projects, Curbs], daos: [ProjectDao, CurbDao])
class CurbWheelDatabase extends _$CurbWheelDatabase {
  CurbWheelDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'curb-wheel-db.sqlite'));

  @override
  int get schemaVersion => 1;
}
