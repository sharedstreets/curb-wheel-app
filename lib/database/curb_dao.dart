import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'curb_dao.g.dart';

@UseDao(tables: [Curbs])
class CurbDao extends DatabaseAccessor<CurbWheelDatabase> with _$CurbDaoMixin {
  CurbDao(CurbWheelDatabase db) : super(db);

  Future<List<Curb>> getAllCurbs() => select(curbs).get();

  Stream<List<Curb>> watchAllCurbs() => select(curbs).watch();

  Stream<List<Curb>> watchCurbsByStreetSide(String shStRefId, String side) =>
      (select(curbs)..where((c) => c.shStRefId.equals(shStRefId))..where((c) => c.side.equals(side))).watch();

  Future insertItem(Curb curb) => into(curbs).insert(curb);

  Future updateItem(Curb curb) => update(curbs).replace(curb);

  Future deleteItem(Curb curb) => delete(curbs).delete(curb);
}