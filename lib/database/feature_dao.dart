import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'feature_dao.g.dart';

@UseDao(tables: [Features])
class FeatureDao extends DatabaseAccessor<CurbWheelDatabase> with _$FeatureDaoMixin {
  FeatureDao(CurbWheelDatabase db) : super(db);

  Future<List<Feature>> getAllFeatures() => select(features).get();

  Stream<List<Feature>> watchAllFeatures() => select(features).watch();

  Future<List<Feature>> getAllFeaturesByProject(int projectId) => (select(features)..where((f) => f.projectId.equals(projectId))).get();

  Stream<List<Feature>> watchAllFeaturesByProject(int projectId) => (select(features)..where((f) => f.projectId.equals(projectId))).watch();

  Future insertFeature(FeaturesCompanion feature) => into(features).insert(feature);

  Future updateFeature(Feature feature) => update(features).replace(feature);

  Future deleteFeature(Feature feature) => delete(features).delete(feature);
}