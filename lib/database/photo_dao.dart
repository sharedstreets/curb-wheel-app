import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'photo_dao.g.dart';

@UseDao(tables: [Photos])
class PhotoDao extends DatabaseAccessor<CurbWheelDatabase> with _$PhotoDaoMixin {
  PhotoDao(CurbWheelDatabase db) : super(db);

  Future<List<Photo>> getAllPhotos() => select(photos).get();

  Stream<List<Photo>> watchAllPhotos() => select(photos).watch();

  Future insertPhoto(PhotosCompanion photo) => into(photos).insert(photo);

  Future updatePhoto(Photo photo) => update(photos).replace(photo);

  Future deletePhoto(Photo photo) => delete(photos).delete(photo);
}