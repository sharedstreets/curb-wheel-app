import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'point_dao.g.dart';

@UseDao(tables: [Points])
class PointDao extends DatabaseAccessor<CurbWheelDatabase> with _$PointDaoMixin {
  PointDao(CurbWheelDatabase db) : super(db);

  Future<List<Point>> getAllPoints() => select(points).get();

  Stream<List<Point>> watchAllPoints() => select(points).watch();

  Future insertPoint(PointsCompanion point) => into(points).insert(point);

  Future updatePoint(Point point) => update(points).replace(point);

  Future deletePoint(Point point) => delete(points).delete(point);
}