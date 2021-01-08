import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'project_dao.g.dart';

@UseDao(tables: [Projects])
class ProjectDao extends DatabaseAccessor<CurbWheelDatabase> with _$ProjectDaoMixin {
  ProjectDao(CurbWheelDatabase db) : super(db);

  Future<List<Project>> getAllProjects() => select(projects).get();

  Stream<List<Project>> watchAllProjects() => select(projects).watch();

  Future insertProject(ProjectsCompanion project) => into(projects).insert(project);

  Future updateProject(Project project) => update(projects).replace(project);

  Future deleteProject(Project project) => delete(projects).delete(project);
}