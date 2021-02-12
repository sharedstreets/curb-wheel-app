// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String projectConfigUrl;
  final String projectId;
  final String name;
  final String email;
  final String organization;
  Project(
      {@required this.id,
      @required this.projectConfigUrl,
      @required this.projectId,
      @required this.name,
      @required this.email,
      @required this.organization});
  factory Project.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return Project(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      projectConfigUrl: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}project_config_url']),
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
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || projectConfigUrl != null) {
      map['project_config_url'] = Variable<String>(projectConfigUrl);
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
      projectConfigUrl: projectConfigUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(projectConfigUrl),
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
      id: serializer.fromJson<String>(json['id']),
      projectConfigUrl: serializer.fromJson<String>(json['projectConfigUrl']),
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
      'id': serializer.toJson<String>(id),
      'projectConfigUrl': serializer.toJson<String>(projectConfigUrl),
      'projectId': serializer.toJson<String>(projectId),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'organization': serializer.toJson<String>(organization),
    };
  }

  Project copyWith(
          {String id,
          String projectConfigUrl,
          String projectId,
          String name,
          String email,
          String organization}) =>
      Project(
        id: id ?? this.id,
        projectConfigUrl: projectConfigUrl ?? this.projectConfigUrl,
        projectId: projectId ?? this.projectId,
        name: name ?? this.name,
        email: email ?? this.email,
        organization: organization ?? this.organization,
      );
  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('projectConfigUrl: $projectConfigUrl, ')
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
      $mrjc(
          projectConfigUrl.hashCode,
          $mrjc(
              projectId.hashCode,
              $mrjc(name.hashCode,
                  $mrjc(email.hashCode, organization.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.projectConfigUrl == this.projectConfigUrl &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.email == this.email &&
          other.organization == this.organization);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> projectConfigUrl;
  final Value<String> projectId;
  final Value<String> name;
  final Value<String> email;
  final Value<String> organization;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.projectConfigUrl = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.organization = const Value.absent(),
  });
  ProjectsCompanion.insert({
    @required String id,
    @required String projectConfigUrl,
    @required String projectId,
    @required String name,
    @required String email,
    @required String organization,
  })  : id = Value(id),
        projectConfigUrl = Value(projectConfigUrl),
        projectId = Value(projectId),
        name = Value(name),
        email = Value(email),
        organization = Value(organization);
  static Insertable<Project> custom({
    Expression<String> id,
    Expression<String> projectConfigUrl,
    Expression<String> projectId,
    Expression<String> name,
    Expression<String> email,
    Expression<String> organization,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectConfigUrl != null) 'project_config_url': projectConfigUrl,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (organization != null) 'organization': organization,
    });
  }

  ProjectsCompanion copyWith(
      {Value<String> id,
      Value<String> projectConfigUrl,
      Value<String> projectId,
      Value<String> name,
      Value<String> email,
      Value<String> organization}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      projectConfigUrl: projectConfigUrl ?? this.projectConfigUrl,
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
      map['id'] = Variable<String>(id.value);
    }
    if (projectConfigUrl.present) {
      map['project_config_url'] = Variable<String>(projectConfigUrl.value);
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
          ..write('projectConfigUrl: $projectConfigUrl, ')
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
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _projectConfigUrlMeta =
      const VerificationMeta('projectConfigUrl');
  GeneratedTextColumn _projectConfigUrl;
  @override
  GeneratedTextColumn get projectConfigUrl =>
      _projectConfigUrl ??= _constructProjectConfigUrl();
  GeneratedTextColumn _constructProjectConfigUrl() {
    return GeneratedTextColumn(
      'project_config_url',
      $tableName,
      false,
    );
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
      [id, projectConfigUrl, projectId, name, email, organization];
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
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_config_url')) {
      context.handle(
          _projectConfigUrlMeta,
          projectConfigUrl.isAcceptableOrUnknown(
              data['project_config_url'], _projectConfigUrlMeta));
    } else if (isInserting) {
      context.missing(_projectConfigUrlMeta);
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

class FeatureType extends DataClass implements Insertable<FeatureType> {
  final String id;
  final String projectId;
  final String geometryType;
  final String color;
  final String name;
  FeatureType(
      {@required this.id,
      @required this.projectId,
      @required this.geometryType,
      @required this.color,
      @required this.name});
  factory FeatureType.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return FeatureType(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      projectId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}project_id']),
      geometryType: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}geometry_type']),
      color:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}color']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    if (!nullToAbsent || geometryType != null) {
      map['geometry_type'] = Variable<String>(geometryType);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  FeatureTypesCompanion toCompanion(bool nullToAbsent) {
    return FeatureTypesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      geometryType: geometryType == null && nullToAbsent
          ? const Value.absent()
          : Value(geometryType),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory FeatureType.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return FeatureType(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      geometryType: serializer.fromJson<String>(json['geometryType']),
      color: serializer.fromJson<String>(json['color']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'geometryType': serializer.toJson<String>(geometryType),
      'color': serializer.toJson<String>(color),
      'name': serializer.toJson<String>(name),
    };
  }

  FeatureType copyWith(
          {String id,
          String projectId,
          String geometryType,
          String color,
          String name}) =>
      FeatureType(
        id: id ?? this.id,
        projectId: projectId ?? this.projectId,
        geometryType: geometryType ?? this.geometryType,
        color: color ?? this.color,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('FeatureType(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('geometryType: $geometryType, ')
          ..write('color: $color, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(projectId.hashCode,
          $mrjc(geometryType.hashCode, $mrjc(color.hashCode, name.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is FeatureType &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.geometryType == this.geometryType &&
          other.color == this.color &&
          other.name == this.name);
}

class FeatureTypesCompanion extends UpdateCompanion<FeatureType> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> geometryType;
  final Value<String> color;
  final Value<String> name;
  const FeatureTypesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.geometryType = const Value.absent(),
    this.color = const Value.absent(),
    this.name = const Value.absent(),
  });
  FeatureTypesCompanion.insert({
    @required String id,
    @required String projectId,
    @required String geometryType,
    @required String color,
    @required String name,
  })  : id = Value(id),
        projectId = Value(projectId),
        geometryType = Value(geometryType),
        color = Value(color),
        name = Value(name);
  static Insertable<FeatureType> custom({
    Expression<String> id,
    Expression<String> projectId,
    Expression<String> geometryType,
    Expression<String> color,
    Expression<String> name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (geometryType != null) 'geometry_type': geometryType,
      if (color != null) 'color': color,
      if (name != null) 'name': name,
    });
  }

  FeatureTypesCompanion copyWith(
      {Value<String> id,
      Value<String> projectId,
      Value<String> geometryType,
      Value<String> color,
      Value<String> name}) {
    return FeatureTypesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      geometryType: geometryType ?? this.geometryType,
      color: color ?? this.color,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (geometryType.present) {
      map['geometry_type'] = Variable<String>(geometryType.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeatureTypesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('geometryType: $geometryType, ')
          ..write('color: $color, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $FeatureTypesTable extends FeatureTypes
    with TableInfo<$FeatureTypesTable, FeatureType> {
  final GeneratedDatabase _db;
  final String _alias;
  $FeatureTypesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
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

  final VerificationMeta _geometryTypeMeta =
      const VerificationMeta('geometryType');
  GeneratedTextColumn _geometryType;
  @override
  GeneratedTextColumn get geometryType =>
      _geometryType ??= _constructGeometryType();
  GeneratedTextColumn _constructGeometryType() {
    return GeneratedTextColumn(
      'geometry_type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _colorMeta = const VerificationMeta('color');
  GeneratedTextColumn _color;
  @override
  GeneratedTextColumn get color => _color ??= _constructColor();
  GeneratedTextColumn _constructColor() {
    return GeneratedTextColumn(
      'color',
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

  @override
  List<GeneratedColumn> get $columns =>
      [id, projectId, geometryType, color, name];
  @override
  $FeatureTypesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'feature_types';
  @override
  final String actualTableName = 'feature_types';
  @override
  VerificationContext validateIntegrity(Insertable<FeatureType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id'], _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('geometry_type')) {
      context.handle(
          _geometryTypeMeta,
          geometryType.isAcceptableOrUnknown(
              data['geometry_type'], _geometryTypeMeta));
    } else if (isInserting) {
      context.missing(_geometryTypeMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color'], _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeatureType map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return FeatureType.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $FeatureTypesTable createAlias(String alias) {
    return $FeatureTypesTable(_db, alias);
  }
}

class Survey extends DataClass implements Insertable<Survey> {
  final String id;
  final String projectId;
  final String shStRefId;
  final String streetName;
  final double length;
  final String startStreetName;
  final String endStreetName;
  final String direction;
  final String side;
  Survey(
      {@required this.id,
      @required this.projectId,
      @required this.shStRefId,
      @required this.streetName,
      @required this.length,
      @required this.startStreetName,
      @required this.endStreetName,
      @required this.direction,
      @required this.side});
  factory Survey.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    return Survey(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      projectId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}project_id']),
      shStRefId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}sh_st_ref_id']),
      streetName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}street_name']),
      length:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}length']),
      startStreetName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}start_street_name']),
      endStreetName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}end_street_name']),
      direction: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}direction']),
      side: stringType.mapFromDatabaseResponse(data['${effectivePrefix}side']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    if (!nullToAbsent || shStRefId != null) {
      map['sh_st_ref_id'] = Variable<String>(shStRefId);
    }
    if (!nullToAbsent || streetName != null) {
      map['street_name'] = Variable<String>(streetName);
    }
    if (!nullToAbsent || length != null) {
      map['length'] = Variable<double>(length);
    }
    if (!nullToAbsent || startStreetName != null) {
      map['start_street_name'] = Variable<String>(startStreetName);
    }
    if (!nullToAbsent || endStreetName != null) {
      map['end_street_name'] = Variable<String>(endStreetName);
    }
    if (!nullToAbsent || direction != null) {
      map['direction'] = Variable<String>(direction);
    }
    if (!nullToAbsent || side != null) {
      map['side'] = Variable<String>(side);
    }
    return map;
  }

  SurveysCompanion toCompanion(bool nullToAbsent) {
    return SurveysCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      shStRefId: shStRefId == null && nullToAbsent
          ? const Value.absent()
          : Value(shStRefId),
      streetName: streetName == null && nullToAbsent
          ? const Value.absent()
          : Value(streetName),
      length:
          length == null && nullToAbsent ? const Value.absent() : Value(length),
      startStreetName: startStreetName == null && nullToAbsent
          ? const Value.absent()
          : Value(startStreetName),
      endStreetName: endStreetName == null && nullToAbsent
          ? const Value.absent()
          : Value(endStreetName),
      direction: direction == null && nullToAbsent
          ? const Value.absent()
          : Value(direction),
      side: side == null && nullToAbsent ? const Value.absent() : Value(side),
    );
  }

  factory Survey.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Survey(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      shStRefId: serializer.fromJson<String>(json['shStRefId']),
      streetName: serializer.fromJson<String>(json['streetName']),
      length: serializer.fromJson<double>(json['length']),
      startStreetName: serializer.fromJson<String>(json['startStreetName']),
      endStreetName: serializer.fromJson<String>(json['endStreetName']),
      direction: serializer.fromJson<String>(json['direction']),
      side: serializer.fromJson<String>(json['side']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'shStRefId': serializer.toJson<String>(shStRefId),
      'streetName': serializer.toJson<String>(streetName),
      'length': serializer.toJson<double>(length),
      'startStreetName': serializer.toJson<String>(startStreetName),
      'endStreetName': serializer.toJson<String>(endStreetName),
      'direction': serializer.toJson<String>(direction),
      'side': serializer.toJson<String>(side),
    };
  }

  Survey copyWith(
          {String id,
          String projectId,
          String shStRefId,
          String streetName,
          double length,
          String startStreetName,
          String endStreetName,
          String direction,
          String side}) =>
      Survey(
        id: id ?? this.id,
        projectId: projectId ?? this.projectId,
        shStRefId: shStRefId ?? this.shStRefId,
        streetName: streetName ?? this.streetName,
        length: length ?? this.length,
        startStreetName: startStreetName ?? this.startStreetName,
        endStreetName: endStreetName ?? this.endStreetName,
        direction: direction ?? this.direction,
        side: side ?? this.side,
      );
  @override
  String toString() {
    return (StringBuffer('Survey(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('shStRefId: $shStRefId, ')
          ..write('streetName: $streetName, ')
          ..write('length: $length, ')
          ..write('startStreetName: $startStreetName, ')
          ..write('endStreetName: $endStreetName, ')
          ..write('direction: $direction, ')
          ..write('side: $side')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          projectId.hashCode,
          $mrjc(
              shStRefId.hashCode,
              $mrjc(
                  streetName.hashCode,
                  $mrjc(
                      length.hashCode,
                      $mrjc(
                          startStreetName.hashCode,
                          $mrjc(endStreetName.hashCode,
                              $mrjc(direction.hashCode, side.hashCode)))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Survey &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.shStRefId == this.shStRefId &&
          other.streetName == this.streetName &&
          other.length == this.length &&
          other.startStreetName == this.startStreetName &&
          other.endStreetName == this.endStreetName &&
          other.direction == this.direction &&
          other.side == this.side);
}

class SurveysCompanion extends UpdateCompanion<Survey> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> shStRefId;
  final Value<String> streetName;
  final Value<double> length;
  final Value<String> startStreetName;
  final Value<String> endStreetName;
  final Value<String> direction;
  final Value<String> side;
  const SurveysCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.shStRefId = const Value.absent(),
    this.streetName = const Value.absent(),
    this.length = const Value.absent(),
    this.startStreetName = const Value.absent(),
    this.endStreetName = const Value.absent(),
    this.direction = const Value.absent(),
    this.side = const Value.absent(),
  });
  SurveysCompanion.insert({
    @required String id,
    @required String projectId,
    @required String shStRefId,
    @required String streetName,
    @required double length,
    @required String startStreetName,
    @required String endStreetName,
    @required String direction,
    @required String side,
  })  : id = Value(id),
        projectId = Value(projectId),
        shStRefId = Value(shStRefId),
        streetName = Value(streetName),
        length = Value(length),
        startStreetName = Value(startStreetName),
        endStreetName = Value(endStreetName),
        direction = Value(direction),
        side = Value(side);
  static Insertable<Survey> custom({
    Expression<String> id,
    Expression<String> projectId,
    Expression<String> shStRefId,
    Expression<String> streetName,
    Expression<double> length,
    Expression<String> startStreetName,
    Expression<String> endStreetName,
    Expression<String> direction,
    Expression<String> side,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (shStRefId != null) 'sh_st_ref_id': shStRefId,
      if (streetName != null) 'street_name': streetName,
      if (length != null) 'length': length,
      if (startStreetName != null) 'start_street_name': startStreetName,
      if (endStreetName != null) 'end_street_name': endStreetName,
      if (direction != null) 'direction': direction,
      if (side != null) 'side': side,
    });
  }

  SurveysCompanion copyWith(
      {Value<String> id,
      Value<String> projectId,
      Value<String> shStRefId,
      Value<String> streetName,
      Value<double> length,
      Value<String> startStreetName,
      Value<String> endStreetName,
      Value<String> direction,
      Value<String> side}) {
    return SurveysCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      shStRefId: shStRefId ?? this.shStRefId,
      streetName: streetName ?? this.streetName,
      length: length ?? this.length,
      startStreetName: startStreetName ?? this.startStreetName,
      endStreetName: endStreetName ?? this.endStreetName,
      direction: direction ?? this.direction,
      side: side ?? this.side,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (shStRefId.present) {
      map['sh_st_ref_id'] = Variable<String>(shStRefId.value);
    }
    if (streetName.present) {
      map['street_name'] = Variable<String>(streetName.value);
    }
    if (length.present) {
      map['length'] = Variable<double>(length.value);
    }
    if (startStreetName.present) {
      map['start_street_name'] = Variable<String>(startStreetName.value);
    }
    if (endStreetName.present) {
      map['end_street_name'] = Variable<String>(endStreetName.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (side.present) {
      map['side'] = Variable<String>(side.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurveysCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('shStRefId: $shStRefId, ')
          ..write('streetName: $streetName, ')
          ..write('length: $length, ')
          ..write('startStreetName: $startStreetName, ')
          ..write('endStreetName: $endStreetName, ')
          ..write('direction: $direction, ')
          ..write('side: $side')
          ..write(')'))
        .toString();
  }
}

class $SurveysTable extends Surveys with TableInfo<$SurveysTable, Survey> {
  final GeneratedDatabase _db;
  final String _alias;
  $SurveysTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
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

  final VerificationMeta _streetNameMeta = const VerificationMeta('streetName');
  GeneratedTextColumn _streetName;
  @override
  GeneratedTextColumn get streetName => _streetName ??= _constructStreetName();
  GeneratedTextColumn _constructStreetName() {
    return GeneratedTextColumn(
      'street_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lengthMeta = const VerificationMeta('length');
  GeneratedRealColumn _length;
  @override
  GeneratedRealColumn get length => _length ??= _constructLength();
  GeneratedRealColumn _constructLength() {
    return GeneratedRealColumn(
      'length',
      $tableName,
      false,
    );
  }

  final VerificationMeta _startStreetNameMeta =
      const VerificationMeta('startStreetName');
  GeneratedTextColumn _startStreetName;
  @override
  GeneratedTextColumn get startStreetName =>
      _startStreetName ??= _constructStartStreetName();
  GeneratedTextColumn _constructStartStreetName() {
    return GeneratedTextColumn(
      'start_street_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _endStreetNameMeta =
      const VerificationMeta('endStreetName');
  GeneratedTextColumn _endStreetName;
  @override
  GeneratedTextColumn get endStreetName =>
      _endStreetName ??= _constructEndStreetName();
  GeneratedTextColumn _constructEndStreetName() {
    return GeneratedTextColumn(
      'end_street_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _directionMeta = const VerificationMeta('direction');
  GeneratedTextColumn _direction;
  @override
  GeneratedTextColumn get direction => _direction ??= _constructDirection();
  GeneratedTextColumn _constructDirection() {
    return GeneratedTextColumn(
      'direction',
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

  @override
  List<GeneratedColumn> get $columns => [
        id,
        projectId,
        shStRefId,
        streetName,
        length,
        startStreetName,
        endStreetName,
        direction,
        side
      ];
  @override
  $SurveysTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'surveys';
  @override
  final String actualTableName = 'surveys';
  @override
  VerificationContext validateIntegrity(Insertable<Survey> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id'], _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('sh_st_ref_id')) {
      context.handle(
          _shStRefIdMeta,
          shStRefId.isAcceptableOrUnknown(
              data['sh_st_ref_id'], _shStRefIdMeta));
    } else if (isInserting) {
      context.missing(_shStRefIdMeta);
    }
    if (data.containsKey('street_name')) {
      context.handle(
          _streetNameMeta,
          streetName.isAcceptableOrUnknown(
              data['street_name'], _streetNameMeta));
    } else if (isInserting) {
      context.missing(_streetNameMeta);
    }
    if (data.containsKey('length')) {
      context.handle(_lengthMeta,
          length.isAcceptableOrUnknown(data['length'], _lengthMeta));
    } else if (isInserting) {
      context.missing(_lengthMeta);
    }
    if (data.containsKey('start_street_name')) {
      context.handle(
          _startStreetNameMeta,
          startStreetName.isAcceptableOrUnknown(
              data['start_street_name'], _startStreetNameMeta));
    } else if (isInserting) {
      context.missing(_startStreetNameMeta);
    }
    if (data.containsKey('end_street_name')) {
      context.handle(
          _endStreetNameMeta,
          endStreetName.isAcceptableOrUnknown(
              data['end_street_name'], _endStreetNameMeta));
    } else if (isInserting) {
      context.missing(_endStreetNameMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(_directionMeta,
          direction.isAcceptableOrUnknown(data['direction'], _directionMeta));
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('side')) {
      context.handle(
          _sideMeta, side.isAcceptableOrUnknown(data['side'], _sideMeta));
    } else if (isInserting) {
      context.missing(_sideMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Survey map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Survey.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SurveysTable createAlias(String alias) {
    return $SurveysTable(_db, alias);
  }
}

class SurveyItem extends DataClass implements Insertable<SurveyItem> {
  final String id;
  final String surveyId;
  final String featureId;
  final bool complete;
  SurveyItem(
      {@required this.id,
      @required this.surveyId,
      @required this.featureId,
      @required this.complete});
  factory SurveyItem.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return SurveyItem(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      surveyId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}survey_id']),
      featureId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}feature_id']),
      complete:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}complete']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || surveyId != null) {
      map['survey_id'] = Variable<String>(surveyId);
    }
    if (!nullToAbsent || featureId != null) {
      map['feature_id'] = Variable<String>(featureId);
    }
    if (!nullToAbsent || complete != null) {
      map['complete'] = Variable<bool>(complete);
    }
    return map;
  }

  SurveyItemsCompanion toCompanion(bool nullToAbsent) {
    return SurveyItemsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      surveyId: surveyId == null && nullToAbsent
          ? const Value.absent()
          : Value(surveyId),
      featureId: featureId == null && nullToAbsent
          ? const Value.absent()
          : Value(featureId),
      complete: complete == null && nullToAbsent
          ? const Value.absent()
          : Value(complete),
    );
  }

  factory SurveyItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SurveyItem(
      id: serializer.fromJson<String>(json['id']),
      surveyId: serializer.fromJson<String>(json['surveyId']),
      featureId: serializer.fromJson<String>(json['featureId']),
      complete: serializer.fromJson<bool>(json['complete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'surveyId': serializer.toJson<String>(surveyId),
      'featureId': serializer.toJson<String>(featureId),
      'complete': serializer.toJson<bool>(complete),
    };
  }

  SurveyItem copyWith(
          {String id, String surveyId, String featureId, bool complete}) =>
      SurveyItem(
        id: id ?? this.id,
        surveyId: surveyId ?? this.surveyId,
        featureId: featureId ?? this.featureId,
        complete: complete ?? this.complete,
      );
  @override
  String toString() {
    return (StringBuffer('SurveyItem(')
          ..write('id: $id, ')
          ..write('surveyId: $surveyId, ')
          ..write('featureId: $featureId, ')
          ..write('complete: $complete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(surveyId.hashCode, $mrjc(featureId.hashCode, complete.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is SurveyItem &&
          other.id == this.id &&
          other.surveyId == this.surveyId &&
          other.featureId == this.featureId &&
          other.complete == this.complete);
}

class SurveyItemsCompanion extends UpdateCompanion<SurveyItem> {
  final Value<String> id;
  final Value<String> surveyId;
  final Value<String> featureId;
  final Value<bool> complete;
  const SurveyItemsCompanion({
    this.id = const Value.absent(),
    this.surveyId = const Value.absent(),
    this.featureId = const Value.absent(),
    this.complete = const Value.absent(),
  });
  SurveyItemsCompanion.insert({
    @required String id,
    @required String surveyId,
    @required String featureId,
    @required bool complete,
  })  : id = Value(id),
        surveyId = Value(surveyId),
        featureId = Value(featureId),
        complete = Value(complete);
  static Insertable<SurveyItem> custom({
    Expression<String> id,
    Expression<String> surveyId,
    Expression<String> featureId,
    Expression<bool> complete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surveyId != null) 'survey_id': surveyId,
      if (featureId != null) 'feature_id': featureId,
      if (complete != null) 'complete': complete,
    });
  }

  SurveyItemsCompanion copyWith(
      {Value<String> id,
      Value<String> surveyId,
      Value<String> featureId,
      Value<bool> complete}) {
    return SurveyItemsCompanion(
      id: id ?? this.id,
      surveyId: surveyId ?? this.surveyId,
      featureId: featureId ?? this.featureId,
      complete: complete ?? this.complete,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (surveyId.present) {
      map['survey_id'] = Variable<String>(surveyId.value);
    }
    if (featureId.present) {
      map['feature_id'] = Variable<String>(featureId.value);
    }
    if (complete.present) {
      map['complete'] = Variable<bool>(complete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurveyItemsCompanion(')
          ..write('id: $id, ')
          ..write('surveyId: $surveyId, ')
          ..write('featureId: $featureId, ')
          ..write('complete: $complete')
          ..write(')'))
        .toString();
  }
}

class $SurveyItemsTable extends SurveyItems
    with TableInfo<$SurveyItemsTable, SurveyItem> {
  final GeneratedDatabase _db;
  final String _alias;
  $SurveyItemsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _surveyIdMeta = const VerificationMeta('surveyId');
  GeneratedTextColumn _surveyId;
  @override
  GeneratedTextColumn get surveyId => _surveyId ??= _constructSurveyId();
  GeneratedTextColumn _constructSurveyId() {
    return GeneratedTextColumn(
      'survey_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _featureIdMeta = const VerificationMeta('featureId');
  GeneratedTextColumn _featureId;
  @override
  GeneratedTextColumn get featureId => _featureId ??= _constructFeatureId();
  GeneratedTextColumn _constructFeatureId() {
    return GeneratedTextColumn(
      'feature_id',
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
  List<GeneratedColumn> get $columns => [id, surveyId, featureId, complete];
  @override
  $SurveyItemsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'survey_items';
  @override
  final String actualTableName = 'survey_items';
  @override
  VerificationContext validateIntegrity(Insertable<SurveyItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('survey_id')) {
      context.handle(_surveyIdMeta,
          surveyId.isAcceptableOrUnknown(data['survey_id'], _surveyIdMeta));
    } else if (isInserting) {
      context.missing(_surveyIdMeta);
    }
    if (data.containsKey('feature_id')) {
      context.handle(_featureIdMeta,
          featureId.isAcceptableOrUnknown(data['feature_id'], _featureIdMeta));
    } else if (isInserting) {
      context.missing(_featureIdMeta);
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
  SurveyItem map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SurveyItem.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SurveyItemsTable createAlias(String alias) {
    return $SurveyItemsTable(_db, alias);
  }
}

class SurveySpan extends DataClass implements Insertable<SurveySpan> {
  final String id;
  final String surveyItemId;
  final double start;
  final double stop;
  SurveySpan(
      {@required this.id,
      @required this.surveyItemId,
      @required this.start,
      @required this.stop});
  factory SurveySpan.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    return SurveySpan(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      surveyItemId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}survey_item_id']),
      start:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}start']),
      stop: doubleType.mapFromDatabaseResponse(data['${effectivePrefix}stop']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || surveyItemId != null) {
      map['survey_item_id'] = Variable<String>(surveyItemId);
    }
    if (!nullToAbsent || start != null) {
      map['start'] = Variable<double>(start);
    }
    if (!nullToAbsent || stop != null) {
      map['stop'] = Variable<double>(stop);
    }
    return map;
  }

  SurveySpansCompanion toCompanion(bool nullToAbsent) {
    return SurveySpansCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      surveyItemId: surveyItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(surveyItemId),
      start:
          start == null && nullToAbsent ? const Value.absent() : Value(start),
      stop: stop == null && nullToAbsent ? const Value.absent() : Value(stop),
    );
  }

  factory SurveySpan.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SurveySpan(
      id: serializer.fromJson<String>(json['id']),
      surveyItemId: serializer.fromJson<String>(json['surveyItemId']),
      start: serializer.fromJson<double>(json['start']),
      stop: serializer.fromJson<double>(json['stop']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'surveyItemId': serializer.toJson<String>(surveyItemId),
      'start': serializer.toJson<double>(start),
      'stop': serializer.toJson<double>(stop),
    };
  }

  SurveySpan copyWith(
          {String id, String surveyItemId, double start, double stop}) =>
      SurveySpan(
        id: id ?? this.id,
        surveyItemId: surveyItemId ?? this.surveyItemId,
        start: start ?? this.start,
        stop: stop ?? this.stop,
      );
  @override
  String toString() {
    return (StringBuffer('SurveySpan(')
          ..write('id: $id, ')
          ..write('surveyItemId: $surveyItemId, ')
          ..write('start: $start, ')
          ..write('stop: $stop')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(surveyItemId.hashCode, $mrjc(start.hashCode, stop.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is SurveySpan &&
          other.id == this.id &&
          other.surveyItemId == this.surveyItemId &&
          other.start == this.start &&
          other.stop == this.stop);
}

class SurveySpansCompanion extends UpdateCompanion<SurveySpan> {
  final Value<String> id;
  final Value<String> surveyItemId;
  final Value<double> start;
  final Value<double> stop;
  const SurveySpansCompanion({
    this.id = const Value.absent(),
    this.surveyItemId = const Value.absent(),
    this.start = const Value.absent(),
    this.stop = const Value.absent(),
  });
  SurveySpansCompanion.insert({
    @required String id,
    @required String surveyItemId,
    @required double start,
    @required double stop,
  })  : id = Value(id),
        surveyItemId = Value(surveyItemId),
        start = Value(start),
        stop = Value(stop);
  static Insertable<SurveySpan> custom({
    Expression<String> id,
    Expression<String> surveyItemId,
    Expression<double> start,
    Expression<double> stop,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surveyItemId != null) 'survey_item_id': surveyItemId,
      if (start != null) 'start': start,
      if (stop != null) 'stop': stop,
    });
  }

  SurveySpansCompanion copyWith(
      {Value<String> id,
      Value<String> surveyItemId,
      Value<double> start,
      Value<double> stop}) {
    return SurveySpansCompanion(
      id: id ?? this.id,
      surveyItemId: surveyItemId ?? this.surveyItemId,
      start: start ?? this.start,
      stop: stop ?? this.stop,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (surveyItemId.present) {
      map['survey_item_id'] = Variable<String>(surveyItemId.value);
    }
    if (start.present) {
      map['start'] = Variable<double>(start.value);
    }
    if (stop.present) {
      map['stop'] = Variable<double>(stop.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurveySpansCompanion(')
          ..write('id: $id, ')
          ..write('surveyItemId: $surveyItemId, ')
          ..write('start: $start, ')
          ..write('stop: $stop')
          ..write(')'))
        .toString();
  }
}

class $SurveySpansTable extends SurveySpans
    with TableInfo<$SurveySpansTable, SurveySpan> {
  final GeneratedDatabase _db;
  final String _alias;
  $SurveySpansTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _surveyItemIdMeta =
      const VerificationMeta('surveyItemId');
  GeneratedTextColumn _surveyItemId;
  @override
  GeneratedTextColumn get surveyItemId =>
      _surveyItemId ??= _constructSurveyItemId();
  GeneratedTextColumn _constructSurveyItemId() {
    return GeneratedTextColumn(
      'survey_item_id',
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

  @override
  List<GeneratedColumn> get $columns => [id, surveyItemId, start, stop];
  @override
  $SurveySpansTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'survey_spans';
  @override
  final String actualTableName = 'survey_spans';
  @override
  VerificationContext validateIntegrity(Insertable<SurveySpan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('survey_item_id')) {
      context.handle(
          _surveyItemIdMeta,
          surveyItemId.isAcceptableOrUnknown(
              data['survey_item_id'], _surveyItemIdMeta));
    } else if (isInserting) {
      context.missing(_surveyItemIdMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SurveySpan map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SurveySpan.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SurveySpansTable createAlias(String alias) {
    return $SurveySpansTable(_db, alias);
  }
}

class SurveyPoint extends DataClass implements Insertable<SurveyPoint> {
  final String id;
  final String surveyItemId;
  final double position;
  SurveyPoint({@required this.id, this.surveyItemId, @required this.position});
  factory SurveyPoint.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    return SurveyPoint(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      surveyItemId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}survey_item_id']),
      position: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}position']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || surveyItemId != null) {
      map['survey_item_id'] = Variable<String>(surveyItemId);
    }
    if (!nullToAbsent || position != null) {
      map['position'] = Variable<double>(position);
    }
    return map;
  }

  SurveyPointsCompanion toCompanion(bool nullToAbsent) {
    return SurveyPointsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      surveyItemId: surveyItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(surveyItemId),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
    );
  }

  factory SurveyPoint.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SurveyPoint(
      id: serializer.fromJson<String>(json['id']),
      surveyItemId: serializer.fromJson<String>(json['surveyItemId']),
      position: serializer.fromJson<double>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'surveyItemId': serializer.toJson<String>(surveyItemId),
      'position': serializer.toJson<double>(position),
    };
  }

  SurveyPoint copyWith({String id, String surveyItemId, double position}) =>
      SurveyPoint(
        id: id ?? this.id,
        surveyItemId: surveyItemId ?? this.surveyItemId,
        position: position ?? this.position,
      );
  @override
  String toString() {
    return (StringBuffer('SurveyPoint(')
          ..write('id: $id, ')
          ..write('surveyItemId: $surveyItemId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(
      $mrjc(id.hashCode, $mrjc(surveyItemId.hashCode, position.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is SurveyPoint &&
          other.id == this.id &&
          other.surveyItemId == this.surveyItemId &&
          other.position == this.position);
}

class SurveyPointsCompanion extends UpdateCompanion<SurveyPoint> {
  final Value<String> id;
  final Value<String> surveyItemId;
  final Value<double> position;
  const SurveyPointsCompanion({
    this.id = const Value.absent(),
    this.surveyItemId = const Value.absent(),
    this.position = const Value.absent(),
  });
  SurveyPointsCompanion.insert({
    @required String id,
    this.surveyItemId = const Value.absent(),
    @required double position,
  })  : id = Value(id),
        position = Value(position);
  static Insertable<SurveyPoint> custom({
    Expression<String> id,
    Expression<String> surveyItemId,
    Expression<double> position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surveyItemId != null) 'survey_item_id': surveyItemId,
      if (position != null) 'position': position,
    });
  }

  SurveyPointsCompanion copyWith(
      {Value<String> id, Value<String> surveyItemId, Value<double> position}) {
    return SurveyPointsCompanion(
      id: id ?? this.id,
      surveyItemId: surveyItemId ?? this.surveyItemId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (surveyItemId.present) {
      map['survey_item_id'] = Variable<String>(surveyItemId.value);
    }
    if (position.present) {
      map['position'] = Variable<double>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurveyPointsCompanion(')
          ..write('id: $id, ')
          ..write('surveyItemId: $surveyItemId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $SurveyPointsTable extends SurveyPoints
    with TableInfo<$SurveyPointsTable, SurveyPoint> {
  final GeneratedDatabase _db;
  final String _alias;
  $SurveyPointsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _surveyItemIdMeta =
      const VerificationMeta('surveyItemId');
  GeneratedTextColumn _surveyItemId;
  @override
  GeneratedTextColumn get surveyItemId =>
      _surveyItemId ??= _constructSurveyItemId();
  GeneratedTextColumn _constructSurveyItemId() {
    return GeneratedTextColumn(
      'survey_item_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _positionMeta = const VerificationMeta('position');
  GeneratedRealColumn _position;
  @override
  GeneratedRealColumn get position => _position ??= _constructPosition();
  GeneratedRealColumn _constructPosition() {
    return GeneratedRealColumn(
      'position',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, surveyItemId, position];
  @override
  $SurveyPointsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'survey_points';
  @override
  final String actualTableName = 'survey_points';
  @override
  VerificationContext validateIntegrity(Insertable<SurveyPoint> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('survey_item_id')) {
      context.handle(
          _surveyItemIdMeta,
          surveyItemId.isAcceptableOrUnknown(
              data['survey_item_id'], _surveyItemIdMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position'], _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SurveyPoint map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SurveyPoint.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SurveyPointsTable createAlias(String alias) {
    return $SurveyPointsTable(_db, alias);
  }
}

class Photo extends DataClass implements Insertable<Photo> {
  final String id;
  final String pointId;
  final String file;
  Photo({@required this.id, @required this.pointId, @required this.file});
  factory Photo.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return Photo(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      pointId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}point_id']),
      file: stringType.mapFromDatabaseResponse(data['${effectivePrefix}file']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || pointId != null) {
      map['point_id'] = Variable<String>(pointId);
    }
    if (!nullToAbsent || file != null) {
      map['file'] = Variable<String>(file);
    }
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      pointId: pointId == null && nullToAbsent
          ? const Value.absent()
          : Value(pointId),
      file: file == null && nullToAbsent ? const Value.absent() : Value(file),
    );
  }

  factory Photo.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Photo(
      id: serializer.fromJson<String>(json['id']),
      pointId: serializer.fromJson<String>(json['pointId']),
      file: serializer.fromJson<String>(json['file']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pointId': serializer.toJson<String>(pointId),
      'file': serializer.toJson<String>(file),
    };
  }

  Photo copyWith({String id, String pointId, String file}) => Photo(
        id: id ?? this.id,
        pointId: pointId ?? this.pointId,
        file: file ?? this.file,
      );
  @override
  String toString() {
    return (StringBuffer('Photo(')
          ..write('id: $id, ')
          ..write('pointId: $pointId, ')
          ..write('file: $file')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(pointId.hashCode, file.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Photo &&
          other.id == this.id &&
          other.pointId == this.pointId &&
          other.file == this.file);
}

class PhotosCompanion extends UpdateCompanion<Photo> {
  final Value<String> id;
  final Value<String> pointId;
  final Value<String> file;
  const PhotosCompanion({
    this.id = const Value.absent(),
    this.pointId = const Value.absent(),
    this.file = const Value.absent(),
  });
  PhotosCompanion.insert({
    @required String id,
    @required String pointId,
    @required String file,
  })  : id = Value(id),
        pointId = Value(pointId),
        file = Value(file);
  static Insertable<Photo> custom({
    Expression<String> id,
    Expression<String> pointId,
    Expression<String> file,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pointId != null) 'point_id': pointId,
      if (file != null) 'file': file,
    });
  }

  PhotosCompanion copyWith(
      {Value<String> id, Value<String> pointId, Value<String> file}) {
    return PhotosCompanion(
      id: id ?? this.id,
      pointId: pointId ?? this.pointId,
      file: file ?? this.file,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pointId.present) {
      map['point_id'] = Variable<String>(pointId.value);
    }
    if (file.present) {
      map['file'] = Variable<String>(file.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosCompanion(')
          ..write('id: $id, ')
          ..write('pointId: $pointId, ')
          ..write('file: $file')
          ..write(')'))
        .toString();
  }
}

class $PhotosTable extends Photos with TableInfo<$PhotosTable, Photo> {
  final GeneratedDatabase _db;
  final String _alias;
  $PhotosTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _pointIdMeta = const VerificationMeta('pointId');
  GeneratedTextColumn _pointId;
  @override
  GeneratedTextColumn get pointId => _pointId ??= _constructPointId();
  GeneratedTextColumn _constructPointId() {
    return GeneratedTextColumn(
      'point_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _fileMeta = const VerificationMeta('file');
  GeneratedTextColumn _file;
  @override
  GeneratedTextColumn get file => _file ??= _constructFile();
  GeneratedTextColumn _constructFile() {
    return GeneratedTextColumn(
      'file',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, pointId, file];
  @override
  $PhotosTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'photos';
  @override
  final String actualTableName = 'photos';
  @override
  VerificationContext validateIntegrity(Insertable<Photo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('point_id')) {
      context.handle(_pointIdMeta,
          pointId.isAcceptableOrUnknown(data['point_id'], _pointIdMeta));
    } else if (isInserting) {
      context.missing(_pointIdMeta);
    }
    if (data.containsKey('file')) {
      context.handle(
          _fileMeta, file.isAcceptableOrUnknown(data['file'], _fileMeta));
    } else if (isInserting) {
      context.missing(_fileMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Photo map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Photo.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(_db, alias);
  }
}

abstract class _$CurbWheelDatabase extends GeneratedDatabase {
  _$CurbWheelDatabase(QueryExecutor e)
      : super(SqlTypeSystem.defaultInstance, e);
  $ProjectsTable _projects;
  $ProjectsTable get projects => _projects ??= $ProjectsTable(this);
  $FeatureTypesTable _featureTypes;
  $FeatureTypesTable get featureTypes =>
      _featureTypes ??= $FeatureTypesTable(this);
  $SurveysTable _surveys;
  $SurveysTable get surveys => _surveys ??= $SurveysTable(this);
  $SurveyItemsTable _surveyItems;
  $SurveyItemsTable get surveyItems => _surveyItems ??= $SurveyItemsTable(this);
  $SurveySpansTable _surveySpans;
  $SurveySpansTable get surveySpans => _surveySpans ??= $SurveySpansTable(this);
  $SurveyPointsTable _surveyPoints;
  $SurveyPointsTable get surveyPoints =>
      _surveyPoints ??= $SurveyPointsTable(this);
  $PhotosTable _photos;
  $PhotosTable get photos => _photos ??= $PhotosTable(this);
  ProjectDao _projectDao;
  ProjectDao get projectDao =>
      _projectDao ??= ProjectDao(this as CurbWheelDatabase);
  FeatureTypeDao _featureTypeDao;
  FeatureTypeDao get featureTypeDao =>
      _featureTypeDao ??= FeatureTypeDao(this as CurbWheelDatabase);
  SurveyDao _surveyDao;
  SurveyDao get surveyDao =>
      _surveyDao ??= SurveyDao(this as CurbWheelDatabase);
  SurveyItemDao _surveyItemDao;
  SurveyItemDao get surveyItemDao =>
      _surveyItemDao ??= SurveyItemDao(this as CurbWheelDatabase);
  SurveySpanDao _surveySpanDao;
  SurveySpanDao get surveySpanDao =>
      _surveySpanDao ??= SurveySpanDao(this as CurbWheelDatabase);
  SurveyPointDao _surveyPointDao;
  SurveyPointDao get surveyPointDao =>
      _surveyPointDao ??= SurveyPointDao(this as CurbWheelDatabase);
  PhotoDao _photoDao;
  PhotoDao get photoDao => _photoDao ??= PhotoDao(this as CurbWheelDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        projects,
        featureTypes,
        surveys,
        surveyItems,
        surveySpans,
        surveyPoints,
        photos
      ];
}
