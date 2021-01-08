// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Project extends DataClass implements Insertable<Project> {
  final int id;
  final String projectId;
  final String name;
  final String email;
  final String organization;
  Project(
      {@required this.id,
      @required this.projectId,
      @required this.name,
      @required this.email,
      @required this.organization});
  factory Project.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Project(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      projectId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}project_id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      email:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}email']),
      organization: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}organization']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || organization != null) {
      map['organization'] = Variable<String>(organization);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      organization: organization == null && nullToAbsent
          ? const Value.absent()
          : Value(organization),
    );
  }

  factory Project.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      organization: serializer.fromJson<String>(json['organization']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<String>(projectId),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'organization': serializer.toJson<String>(organization),
    };
  }

  Project copyWith(
          {int id,
          String projectId,
          String name,
          String email,
          String organization}) =>
      Project(
        id: id ?? this.id,
        projectId: projectId ?? this.projectId,
        name: name ?? this.name,
        email: email ?? this.email,
        organization: organization ?? this.organization,
      );
  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('organization: $organization')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(projectId.hashCode,
          $mrjc(name.hashCode, $mrjc(email.hashCode, organization.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.email == this.email &&
          other.organization == this.organization);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<int> id;
  final Value<String> projectId;
  final Value<String> name;
  final Value<String> email;
  final Value<String> organization;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.organization = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    @required String projectId,
    @required String name,
    @required String email,
    @required String organization,
  })  : projectId = Value(projectId),
        name = Value(name),
        email = Value(email),
        organization = Value(organization);
  static Insertable<Project> custom({
    Expression<int> id,
    Expression<String> projectId,
    Expression<String> name,
    Expression<String> email,
    Expression<String> organization,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (organization != null) 'organization': organization,
    });
  }

  ProjectsCompanion copyWith(
      {Value<int> id,
      Value<String> projectId,
      Value<String> name,
      Value<String> email,
      Value<String> organization}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      email: email ?? this.email,
      organization: organization ?? this.organization,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (organization.present) {
      map['organization'] = Variable<String>(organization.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('organization: $organization')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  final GeneratedDatabase _db;
  final String _alias;
  $ProjectsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _projectIdMeta = const VerificationMeta('projectId');
  GeneratedTextColumn _projectId;
  @override
  GeneratedTextColumn get projectId => _projectId ??= _constructProjectId();
  GeneratedTextColumn _constructProjectId() {
    return GeneratedTextColumn(
      'project_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _emailMeta = const VerificationMeta('email');
  GeneratedTextColumn _email;
  @override
  GeneratedTextColumn get email => _email ??= _constructEmail();
  GeneratedTextColumn _constructEmail() {
    return GeneratedTextColumn(
      'email',
      $tableName,
      false,
    );
  }

  final VerificationMeta _organizationMeta =
      const VerificationMeta('organization');
  GeneratedTextColumn _organization;
  @override
  GeneratedTextColumn get organization =>
      _organization ??= _constructOrganization();
  GeneratedTextColumn _constructOrganization() {
    return GeneratedTextColumn(
      'organization',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, projectId, name, email, organization];
  @override
  $ProjectsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'projects';
  @override
  final String actualTableName = 'projects';
  @override
  VerificationContext validateIntegrity(Insertable<Project> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id'], _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email'], _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('organization')) {
      context.handle(
          _organizationMeta,
          organization.isAcceptableOrUnknown(
              data['organization'], _organizationMeta));
    } else if (isInserting) {
      context.missing(_organizationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Project.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(_db, alias);
  }
}

class Curb extends DataClass implements Insertable<Curb> {
  final int id;
  final String name;
  final String shStRefId;
  final String side;
  final double start;
  final double stop;
  final bool complete;
  Curb(
      {@required this.id,
      @required this.name,
      @required this.shStRefId,
      @required this.side,
      @required this.start,
      @required this.stop,
      @required this.complete});
  factory Curb.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Curb(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      shStRefId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}sh_st_ref_id']),
      side: stringType.mapFromDatabaseResponse(data['${effectivePrefix}side']),
      start:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}start']),
      stop: doubleType.mapFromDatabaseResponse(data['${effectivePrefix}stop']),
      complete:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}complete']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || shStRefId != null) {
      map['sh_st_ref_id'] = Variable<String>(shStRefId);
    }
    if (!nullToAbsent || side != null) {
      map['side'] = Variable<String>(side);
    }
    if (!nullToAbsent || start != null) {
      map['start'] = Variable<double>(start);
    }
    if (!nullToAbsent || stop != null) {
      map['stop'] = Variable<double>(stop);
    }
    if (!nullToAbsent || complete != null) {
      map['complete'] = Variable<bool>(complete);
    }
    return map;
  }

  CurbsCompanion toCompanion(bool nullToAbsent) {
    return CurbsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      shStRefId: shStRefId == null && nullToAbsent
          ? const Value.absent()
          : Value(shStRefId),
      side: side == null && nullToAbsent ? const Value.absent() : Value(side),
      start:
          start == null && nullToAbsent ? const Value.absent() : Value(start),
      stop: stop == null && nullToAbsent ? const Value.absent() : Value(stop),
      complete: complete == null && nullToAbsent
          ? const Value.absent()
          : Value(complete),
    );
  }

  factory Curb.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Curb(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      shStRefId: serializer.fromJson<String>(json['shStRefId']),
      side: serializer.fromJson<String>(json['side']),
      start: serializer.fromJson<double>(json['start']),
      stop: serializer.fromJson<double>(json['stop']),
      complete: serializer.fromJson<bool>(json['complete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'shStRefId': serializer.toJson<String>(shStRefId),
      'side': serializer.toJson<String>(side),
      'start': serializer.toJson<double>(start),
      'stop': serializer.toJson<double>(stop),
      'complete': serializer.toJson<bool>(complete),
    };
  }

  Curb copyWith(
          {int id,
          String name,
          String shStRefId,
          String side,
          double start,
          double stop,
          bool complete}) =>
      Curb(
        id: id ?? this.id,
        name: name ?? this.name,
        shStRefId: shStRefId ?? this.shStRefId,
        side: side ?? this.side,
        start: start ?? this.start,
        stop: stop ?? this.stop,
        complete: complete ?? this.complete,
      );
  @override
  String toString() {
    return (StringBuffer('Curb(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shStRefId: $shStRefId, ')
          ..write('side: $side, ')
          ..write('start: $start, ')
          ..write('stop: $stop, ')
          ..write('complete: $complete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              shStRefId.hashCode,
              $mrjc(
                  side.hashCode,
                  $mrjc(start.hashCode,
                      $mrjc(stop.hashCode, complete.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Curb &&
          other.id == this.id &&
          other.name == this.name &&
          other.shStRefId == this.shStRefId &&
          other.side == this.side &&
          other.start == this.start &&
          other.stop == this.stop &&
          other.complete == this.complete);
}

class CurbsCompanion extends UpdateCompanion<Curb> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> shStRefId;
  final Value<String> side;
  final Value<double> start;
  final Value<double> stop;
  final Value<bool> complete;
  const CurbsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.shStRefId = const Value.absent(),
    this.side = const Value.absent(),
    this.start = const Value.absent(),
    this.stop = const Value.absent(),
    this.complete = const Value.absent(),
  });
  CurbsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required String shStRefId,
    @required String side,
    @required double start,
    @required double stop,
    @required bool complete,
  })  : name = Value(name),
        shStRefId = Value(shStRefId),
        side = Value(side),
        start = Value(start),
        stop = Value(stop),
        complete = Value(complete);
  static Insertable<Curb> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> shStRefId,
    Expression<String> side,
    Expression<double> start,
    Expression<double> stop,
    Expression<bool> complete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (shStRefId != null) 'sh_st_ref_id': shStRefId,
      if (side != null) 'side': side,
      if (start != null) 'start': start,
      if (stop != null) 'stop': stop,
      if (complete != null) 'complete': complete,
    });
  }

  CurbsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<String> shStRefId,
      Value<String> side,
      Value<double> start,
      Value<double> stop,
      Value<bool> complete}) {
    return CurbsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      shStRefId: shStRefId ?? this.shStRefId,
      side: side ?? this.side,
      start: start ?? this.start,
      stop: stop ?? this.stop,
      complete: complete ?? this.complete,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (shStRefId.present) {
      map['sh_st_ref_id'] = Variable<String>(shStRefId.value);
    }
    if (side.present) {
      map['side'] = Variable<String>(side.value);
    }
    if (start.present) {
      map['start'] = Variable<double>(start.value);
    }
    if (stop.present) {
      map['stop'] = Variable<double>(stop.value);
    }
    if (complete.present) {
      map['complete'] = Variable<bool>(complete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurbsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shStRefId: $shStRefId, ')
          ..write('side: $side, ')
          ..write('start: $start, ')
          ..write('stop: $stop, ')
          ..write('complete: $complete')
          ..write(')'))
        .toString();
  }
}

class $CurbsTable extends Curbs with TableInfo<$CurbsTable, Curb> {
  final GeneratedDatabase _db;
  final String _alias;
  $CurbsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _shStRefIdMeta = const VerificationMeta('shStRefId');
  GeneratedTextColumn _shStRefId;
  @override
  GeneratedTextColumn get shStRefId => _shStRefId ??= _constructShStRefId();
  GeneratedTextColumn _constructShStRefId() {
    return GeneratedTextColumn(
      'sh_st_ref_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _sideMeta = const VerificationMeta('side');
  GeneratedTextColumn _side;
  @override
  GeneratedTextColumn get side => _side ??= _constructSide();
  GeneratedTextColumn _constructSide() {
    return GeneratedTextColumn(
      'side',
      $tableName,
      false,
    );
  }

  final VerificationMeta _startMeta = const VerificationMeta('start');
  GeneratedRealColumn _start;
  @override
  GeneratedRealColumn get start => _start ??= _constructStart();
  GeneratedRealColumn _constructStart() {
    return GeneratedRealColumn(
      'start',
      $tableName,
      false,
    );
  }

  final VerificationMeta _stopMeta = const VerificationMeta('stop');
  GeneratedRealColumn _stop;
  @override
  GeneratedRealColumn get stop => _stop ??= _constructStop();
  GeneratedRealColumn _constructStop() {
    return GeneratedRealColumn(
      'stop',
      $tableName,
      false,
    );
  }

  final VerificationMeta _completeMeta = const VerificationMeta('complete');
  GeneratedBoolColumn _complete;
  @override
  GeneratedBoolColumn get complete => _complete ??= _constructComplete();
  GeneratedBoolColumn _constructComplete() {
    return GeneratedBoolColumn(
      'complete',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, shStRefId, side, start, stop, complete];
  @override
  $CurbsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'curbs';
  @override
  final String actualTableName = 'curbs';
  @override
  VerificationContext validateIntegrity(Insertable<Curb> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sh_st_ref_id')) {
      context.handle(
          _shStRefIdMeta,
          shStRefId.isAcceptableOrUnknown(
              data['sh_st_ref_id'], _shStRefIdMeta));
    } else if (isInserting) {
      context.missing(_shStRefIdMeta);
    }
    if (data.containsKey('side')) {
      context.handle(
          _sideMeta, side.isAcceptableOrUnknown(data['side'], _sideMeta));
    } else if (isInserting) {
      context.missing(_sideMeta);
    }
    if (data.containsKey('start')) {
      context.handle(
          _startMeta, start.isAcceptableOrUnknown(data['start'], _startMeta));
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('stop')) {
      context.handle(
          _stopMeta, stop.isAcceptableOrUnknown(data['stop'], _stopMeta));
    } else if (isInserting) {
      context.missing(_stopMeta);
    }
    if (data.containsKey('complete')) {
      context.handle(_completeMeta,
          complete.isAcceptableOrUnknown(data['complete'], _completeMeta));
    } else if (isInserting) {
      context.missing(_completeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Curb map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Curb.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CurbsTable createAlias(String alias) {
    return $CurbsTable(_db, alias);
  }
}

abstract class _$CurbWheelDatabase extends GeneratedDatabase {
  _$CurbWheelDatabase(QueryExecutor e)
      : super(SqlTypeSystem.defaultInstance, e);
  $ProjectsTable _projects;
  $ProjectsTable get projects => _projects ??= $ProjectsTable(this);
  $CurbsTable _curbs;
  $CurbsTable get curbs => _curbs ??= $CurbsTable(this);
  ProjectDao _projectDao;
  ProjectDao get projectDao =>
      _projectDao ??= ProjectDao(this as CurbWheelDatabase);
  CurbDao _curbDao;
  CurbDao get curbDao => _curbDao ??= CurbDao(this as CurbWheelDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [projects, curbs];
}
