import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'feature_type_dao.g.dart';

@UseDao(tables: [FeatureTypes])
class FeatureTypeDao extends DatabaseAccessor<CurbWheelDatabase> with _$FeatureTypeDaoMixin {
  FeatureTypeDao(CurbWheelDatabase db) : super(db);

  Future<List<FeatureType>> getAllFeatures() => select(featureTypes).get();

  Stream<List<FeatureType>> watchAllFeatures() => select(featureTypes).watch();

  Future<List<FeatureType>> getAllFeaturesByProject(String projectId) => (select(featureTypes)..where((f) => f.projectId.equals(projectId))).get();

  Stream<List<FeatureType>> watchAllFeaturesByProject(String projectId) => (select(featureTypes)..where((f) => f.projectId.equals(projectId))).watch();

  Future insertFeature(FeatureTypesCompanion featureType) => into(featureTypes).insert(featureType);

  Future updateFeature(FeatureType featureType) => update(featureTypes).replace(featureType);

  Future deleteFeature(FeatureType featureType) => delete(featureTypes).delete(featureType);
}