// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Project extends DataClass implements Insertable<Project> {
  final int id;
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
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Project(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
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
      map['id'] = Variable<int>(id);
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
      id: serializer.fromJson<int>(json['id']),
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
      'id': serializer.toJson<int>(id),
      'projectConfigUrl': serializer.toJson<String>(projectConfigUrl),
      'projectId': serializer.toJson<String>(projectId),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'organization': serializer.toJson<String>(organization),
    };
  }

  Project copyWith(
          {int id,
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
  final Value<int> id;
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
    this.id = const Value.absent(),
    @required String projectConfigUrl,
    @required String projectId,
    @required String name,
    @required String email,
    @required String organization,
  })  : projectConfigUrl = Value(projectConfigUrl),
        projectId = Value(projectId),
        name = Value(name),
        email = Value(email),
        organization = Value(organization);
  static Insertable<Project> custom({
    Expression<int> id,
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
      {Value<int> id,
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
      map['id'] = Variable<int>(id.value);
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
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
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

class Feature extends DataClass implements Insertable<Feature> {
  final int id;
  final int projectId;
  final String geometryType;
  final String color;
  final String label;
  final String value;
  Feature(
      {@required this.id,
      @required this.projectId,
      @required this.geometryType,
      @required this.color,
      @required this.label,
      @required this.value});
  factory Feature.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Feature(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      projectId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}project_id']),
      geometryType: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}geometry_type']),
      color:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}color']),
      label:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}label']),
      value:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}value']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<int>(projectId);
    }
    if (!nullToAbsent || geometryType != null) {
      map['geometry_type'] = Variable<String>(geometryType);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  FeaturesCompanion toCompanion(bool nullToAbsent) {
    return FeaturesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      geometryType: geometryType == null && nullToAbsent
          ? const Value.absent()
          : Value(geometryType),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      label:
          label == null && nullToAbsent ? const Value.absent() : Value(label),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
    );
  }

  factory Feature.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Feature(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      geometryType: serializer.fromJson<String>(json['geometryType']),
      color: serializer.fromJson<String>(json['color']),
      label: serializer.fromJson<String>(json['label']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'geometryType': serializer.toJson<String>(geometryType),
      'color': serializer.toJson<String>(color),
      'label': serializer.toJson<String>(label),
      'value': serializer.toJson<String>(value),
    };
  }

  Feature copyWith(
          {int id,
          int projectId,
          String geometryType,
          String color,
          String label,
          String value}) =>
      Feature(
        id: id ?? this.id,
        projectId: projectId ?? this.projectId,
        geometryType: geometryType ?? this.geometryType,
        color: color ?? this.color,
        label: label ?? this.label,
        value: value ?? this.value,
      );
  @override
  String toString() {
    return (StringBuffer('Feature(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('geometryType: $geometryType, ')
          ..write('color: $color, ')
          ..write('label: $label, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          projectId.hashCode,
          $mrjc(geometryType.hashCode,
              $mrjc(color.hashCode, $mrjc(label.hashCode, value.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Feature &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.geometryType == this.geometryType &&
          other.color == this.color &&
          other.label == this.label &&
          other.value == this.value);
}

class FeaturesCompanion extends UpdateCompanion<Feature> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<String> geometryType;
  final Value<String> color;
  final Value<String> label;
  final Value<String> value;
  const FeaturesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.geometryType = const Value.absent(),
    this.color = const Value.absent(),
    this.label = const Value.absent(),
    this.value = const Value.absent(),
  });
  FeaturesCompanion.insert({
    this.id = const Value.absent(),
    @required int projectId,
    @required String geometryType,
    @required String color,
    @required String label,
    @required String value,
  })  : projectId = Value(projectId),
        geometryType = Value(geometryType),
        color = Value(color),
        label = Value(label),
        value = Value(value);
  static Insertable<Feature> custom({
    Expression<int> id,
    Expression<int> projectId,
    Expression<String> geometryType,
    Expression<String> color,
    Expression<String> label,
    Expression<String> value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (geometryType != null) 'geometry_type': geometryType,
      if (color != null) 'color': color,
      if (label != null) 'label': label,
      if (value != null) 'value': value,
    });
  }

  FeaturesCompanion copyWith(
      {Value<int> id,
      Value<int> projectId,
      Value<String> geometryType,
      Value<String> color,
      Value<String> label,
      Value<String> value}) {
    return FeaturesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      geometryType: geometryType ?? this.geometryType,
      color: color ?? this.color,
      label: label ?? this.label,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (geometryType.present) {
      map['geometry_type'] = Variable<String>(geometryType.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeaturesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('geometryType: $geometryType, ')
          ..write('color: $color, ')
          ..write('label: $label, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $FeaturesTable extends Features with TableInfo<$FeaturesTable, Feature> {
  final GeneratedDatabase _db;
  final String _alias;
  $FeaturesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _projectIdMeta = const VerificationMeta('projectId');
  GeneratedIntColumn _projectId;
  @override
  GeneratedIntColumn get projectId => _projectId ??= _constructProjectId();
  GeneratedIntColumn _constructProjectId() {
    return GeneratedIntColumn(
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

  final VerificationMeta _labelMeta = const VerificationMeta('label');
  GeneratedTextColumn _label;
  @override
  GeneratedTextColumn get label => _label ??= _constructLabel();
  GeneratedTextColumn _constructLabel() {
    return GeneratedTextColumn(
      'label',
      $tableName,
      false,
    );
  }

  final VerificationMeta _valueMeta = const VerificationMeta('value');
  GeneratedTextColumn _value;
  @override
  GeneratedTextColumn get value => _value ??= _constructValue();
  GeneratedTextColumn _constructValue() {
    return GeneratedTextColumn(
      'value',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, projectId, geometryType, color, label, value];
  @override
  $FeaturesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'features';
  @override
  final String actualTableName = 'features';
  @override
  VerificationContext validateIntegrity(Insertable<Feature> instance,
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
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label'], _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value'], _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Feature map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Feature.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $FeaturesTable createAlias(String alias) {
    return $FeaturesTable(_db, alias);
  }
}

class Survey extends DataClass implements Insertable<Survey> {
  final int id;
  final String shStRefId;
  final String streetName;
  final double length;
  final String startStreetName;
  final String endStreetName;
  final String direction;
  final String side;
  Survey(
      {@required this.id,
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
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    return Survey(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
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
      map['id'] = Variable<int>(id);
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
      id: serializer.fromJson<int>(json['id']),
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
      'id': serializer.toJson<int>(id),
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
          {int id,
          String shStRefId,
          String streetName,
          double length,
          String startStreetName,
          String endStreetName,
          String direction,
          String side}) =>
      Survey(
        id: id ?? this.id,
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
          shStRefId.hashCode,
          $mrjc(
              streetName.hashCode,
              $mrjc(
                  length.hashCode,
                  $mrjc(
                      startStreetName.hashCode,
                      $mrjc(endStreetName.hashCode,
                          $mrjc(direction.hashCode, side.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Survey &&
          other.id == this.id &&
          other.shStRefId == this.shStRefId &&
          other.streetName == this.streetName &&
          other.length == this.length &&
          other.startStreetName == this.startStreetName &&
          other.endStreetName == this.endStreetName &&
          other.direction == this.direction &&
          other.side == this.side);
}

class SurveysCompanion extends UpdateCompanion<Survey> {
  final Value<int> id;
  final Value<String> shStRefId;
  final Value<String> streetName;
  final Value<double> length;
  final Value<String> startStreetName;
  final Value<String> endStreetName;
  final Value<String> direction;
  final Value<String> side;
  const SurveysCompanion({
    this.id = const Value.absent(),
    this.shStRefId = const Value.absent(),
    this.streetName = const Value.absent(),
    this.length = const Value.absent(),
    this.startStreetName = const Value.absent(),
    this.endStreetName = const Value.absent(),
    this.direction = const Value.absent(),
    this.side = const Value.absent(),
  });
  SurveysCompanion.insert({
    this.id = const Value.absent(),
    @required String shStRefId,
    @required String streetName,
    @required double length,
    @required String startStreetName,
    @required String endStreetName,
    @required String direction,
    @required String side,
  })  : shStRefId = Value(shStRefId),
        streetName = Value(streetName),
        length = Value(length),
        startStreetName = Value(startStreetName),
        endStreetName = Value(endStreetName),
        direction = Value(direction),
        side = Value(side);
  static Insertable<Survey> custom({
    Expression<int> id,
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
      {Value<int> id,
      Value<String> shStRefId,
      Value<String> streetName,
      Value<double> length,
      Value<String> startStreetName,
      Value<String> endStreetName,
      Value<String> direction,
      Value<String> side}) {
    return SurveysCompanion(
      id: id ?? this.id,
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
      map['id'] = Variable<int>(id.value);
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
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
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

class Span extends DataClass implements Insertable<Span> {
  final int id;
  final int surveyId;
  final String name;
  final String type;
  final double start;
  final double stop;
  final bool complete;
  Span(
      {@required this.id,
      @required this.surveyId,
      @required this.name,
      @required this.type,
      @required this.start,
      @required this.stop,
      @required this.complete});
  factory Span.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Span(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      surveyId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}survey_id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
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
    if (!nullToAbsent || surveyId != null) {
      map['survey_id'] = Variable<int>(surveyId);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
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

  SpansCompanion toCompanion(bool nullToAbsent) {
    return SpansCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      surveyId: surveyId == null && nullToAbsent
          ? const Value.absent()
          : Value(surveyId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      start:
          start == null && nullToAbsent ? const Value.absent() : Value(start),
      stop: stop == null && nullToAbsent ? const Value.absent() : Value(stop),
      complete: complete == null && nullToAbsent
          ? const Value.absent()
          : Value(complete),
    );
  }

  factory Span.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Span(
      id: serializer.fromJson<int>(json['id']),
      surveyId: serializer.fromJson<int>(json['surveyId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
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
      'surveyId': serializer.toJson<int>(surveyId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'start': serializer.toJson<double>(start),
      'stop': serializer.toJson<double>(stop),
      'complete': serializer.toJson<bool>(complete),
    };
  }

  Span copyWith(
          {int id,
          int surveyId,
          String name,
          String type,
          double start,
          double stop,
          bool complete}) =>
      Span(
        id: id ?? this.id,
        surveyId: surveyId ?? this.surveyId,
        name: name ?? this.name,
        type: type ?? this.type,
        start: start ?? this.start,
        stop: stop ?? this.stop,
        complete: complete ?? this.complete,
      );
  @override
  String toString() {
    return (StringBuffer('Span(')
          ..write('id: $id, ')
          ..write('surveyId: $surveyId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
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
          surveyId.hashCode,
          $mrjc(
              name.hashCode,
              $mrjc(
                  type.hashCode,
                  $mrjc(start.hashCode,
                      $mrjc(stop.hashCode, complete.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Span &&
          other.id == this.id &&
          other.surveyId == this.surveyId &&
          other.name == this.name &&
          other.type == this.type &&
          other.start == this.start &&
          other.stop == this.stop &&
          other.complete == this.complete);
}

class SpansCompanion extends UpdateCompanion<Span> {
  final Value<int> id;
  final Value<int> surveyId;
  final Value<String> name;
  final Value<String> type;
  final Value<double> start;
  final Value<double> stop;
  final Value<bool> complete;
  const SpansCompanion({
    this.id = const Value.absent(),
    this.surveyId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.start = const Value.absent(),
    this.stop = const Value.absent(),
    this.complete = const Value.absent(),
  });
  SpansCompanion.insert({
    this.id = const Value.absent(),
    @required int surveyId,
    @required String name,
    @required String type,
    @required double start,
    @required double stop,
    @required bool complete,
  })  : surveyId = Value(surveyId),
        name = Value(name),
        type = Value(type),
        start = Value(start),
        stop = Value(stop),
        complete = Value(complete);
  static Insertable<Span> custom({
    Expression<int> id,
    Expression<int> surveyId,
    Expression<String> name,
    Expression<String> type,
    Expression<double> start,
    Expression<double> stop,
    Expression<bool> complete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surveyId != null) 'survey_id': surveyId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (start != null) 'start': start,
      if (stop != null) 'stop': stop,
      if (complete != null) 'complete': complete,
    });
  }

  SpansCompanion copyWith(
      {Value<int> id,
      Value<int> surveyId,
      Value<String> name,
      Value<String> type,
      Value<double> start,
      Value<double> stop,
      Value<bool> complete}) {
    return SpansCompanion(
      id: id ?? this.id,
      surveyId: surveyId ?? this.surveyId,
      name: name ?? this.name,
      type: type ?? this.type,
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
    if (surveyId.present) {
      map['survey_id'] = Variable<int>(surveyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
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
    return (StringBuffer('SpansCompanion(')
          ..write('id: $id, ')
          ..write('surveyId: $surveyId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('start: $start, ')
          ..write('stop: $stop, ')
          ..write('complete: $complete')
          ..write(')'))
        .toString();
  }
}

class $SpansTable extends Spans with TableInfo<$SpansTable, Span> {
  final GeneratedDatabase _db;
  final String _alias;
  $SpansTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _surveyIdMeta = const VerificationMeta('surveyId');
  GeneratedIntColumn _surveyId;
  @override
  GeneratedIntColumn get surveyId => _surveyId ??= _constructSurveyId();
  GeneratedIntColumn _constructSurveyId() {
    return GeneratedIntColumn(
      'survey_id',
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

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedTextColumn _type;
  @override
  GeneratedTextColumn get type => _type ??= _constructType();
  GeneratedTextColumn _constructType() {
    return GeneratedTextColumn(
      'type',
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
      [id, surveyId, name, type, start, stop, complete];
  @override
  $SpansTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'spans';
  @override
  final String actualTableName = 'spans';
  @override
  VerificationContext validateIntegrity(Insertable<Span> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('survey_id')) {
      context.handle(_surveyIdMeta,
          surveyId.isAcceptableOrUnknown(data['survey_id'], _surveyIdMeta));
    } else if (isInserting) {
      context.missing(_surveyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
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
  Span map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Span.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SpansTable createAlias(String alias) {
    return $SpansTable(_db, alias);
  }
}

class Point extends DataClass implements Insertable<Point> {
  final int id;
  final int photoId;
  final String type;
  final double position;
  Point(
      {@required this.id,
      @required this.photoId,
      @required this.type,
      @required this.position});
  factory Point.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    return Point(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      photoId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}photo_id']),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      position: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}position']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || photoId != null) {
      map['photo_id'] = Variable<int>(photoId);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || position != null) {
      map['position'] = Variable<double>(position);
    }
    return map;
  }

  PointsCompanion toCompanion(bool nullToAbsent) {
    return PointsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      photoId: photoId == null && nullToAbsent
          ? const Value.absent()
          : Value(photoId),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
    );
  }

  factory Point.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Point(
      id: serializer.fromJson<int>(json['id']),
      photoId: serializer.fromJson<int>(json['photoId']),
      type: serializer.fromJson<String>(json['type']),
      position: serializer.fromJson<double>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'photoId': serializer.toJson<int>(photoId),
      'type': serializer.toJson<String>(type),
      'position': serializer.toJson<double>(position),
    };
  }

  Point copyWith({int id, int photoId, String type, double position}) => Point(
        id: id ?? this.id,
        photoId: photoId ?? this.photoId,
        type: type ?? this.type,
        position: position ?? this.position,
      );
  @override
  String toString() {
    return (StringBuffer('Point(')
          ..write('id: $id, ')
          ..write('photoId: $photoId, ')
          ..write('type: $type, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(photoId.hashCode, $mrjc(type.hashCode, position.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Point &&
          other.id == this.id &&
          other.photoId == this.photoId &&
          other.type == this.type &&
          other.position == this.position);
}

class PointsCompanion extends UpdateCompanion<Point> {
  final Value<int> id;
  final Value<int> photoId;
  final Value<String> type;
  final Value<double> position;
  const PointsCompanion({
    this.id = const Value.absent(),
    this.photoId = const Value.absent(),
    this.type = const Value.absent(),
    this.position = const Value.absent(),
  });
  PointsCompanion.insert({
    this.id = const Value.absent(),
    @required int photoId,
    @required String type,
    @required double position,
  })  : photoId = Value(photoId),
        type = Value(type),
        position = Value(position);
  static Insertable<Point> custom({
    Expression<int> id,
    Expression<int> photoId,
    Expression<String> type,
    Expression<double> position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (photoId != null) 'photo_id': photoId,
      if (type != null) 'type': type,
      if (position != null) 'position': position,
    });
  }

  PointsCompanion copyWith(
      {Value<int> id,
      Value<int> photoId,
      Value<String> type,
      Value<double> position}) {
    return PointsCompanion(
      id: id ?? this.id,
      photoId: photoId ?? this.photoId,
      type: type ?? this.type,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (photoId.present) {
      map['photo_id'] = Variable<int>(photoId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (position.present) {
      map['position'] = Variable<double>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PointsCompanion(')
          ..write('id: $id, ')
          ..write('photoId: $photoId, ')
          ..write('type: $type, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $PointsTable extends Points with TableInfo<$PointsTable, Point> {
  final GeneratedDatabase _db;
  final String _alias;
  $PointsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _photoIdMeta = const VerificationMeta('photoId');
  GeneratedIntColumn _photoId;
  @override
  GeneratedIntColumn get photoId => _photoId ??= _constructPhotoId();
  GeneratedIntColumn _constructPhotoId() {
    return GeneratedIntColumn(
      'photo_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedTextColumn _type;
  @override
  GeneratedTextColumn get type => _type ??= _constructType();
  GeneratedTextColumn _constructType() {
    return GeneratedTextColumn(
      'type',
      $tableName,
      false,
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
  List<GeneratedColumn> get $columns => [id, photoId, type, position];
  @override
  $PointsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'points';
  @override
  final String actualTableName = 'points';
  @override
  VerificationContext validateIntegrity(Insertable<Point> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('photo_id')) {
      context.handle(_photoIdMeta,
          photoId.isAcceptableOrUnknown(data['photo_id'], _photoIdMeta));
    } else if (isInserting) {
      context.missing(_photoIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
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
  Point map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Point.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PointsTable createAlias(String alias) {
    return $PointsTable(_db, alias);
  }
}

abstract class _$CurbWheelDatabase extends GeneratedDatabase {
  _$CurbWheelDatabase(QueryExecutor e)
      : super(SqlTypeSystem.defaultInstance, e);
  $ProjectsTable _projects;
  $ProjectsTable get projects => _projects ??= $ProjectsTable(this);
  $FeaturesTable _features;
  $FeaturesTable get features => _features ??= $FeaturesTable(this);
  $SurveysTable _surveys;
  $SurveysTable get surveys => _surveys ??= $SurveysTable(this);
  $SpansTable _spans;
  $SpansTable get spans => _spans ??= $SpansTable(this);
  $PointsTable _points;
  $PointsTable get points => _points ??= $PointsTable(this);
  ProjectDao _projectDao;
  ProjectDao get projectDao =>
      _projectDao ??= ProjectDao(this as CurbWheelDatabase);
  FeatureDao _featureDao;
  FeatureDao get featureDao =>
      _featureDao ??= FeatureDao(this as CurbWheelDatabase);
  SurveyDao _surveyDao;
  SurveyDao get surveyDao =>
      _surveyDao ??= SurveyDao(this as CurbWheelDatabase);
  SpanDao _spanDao;
  SpanDao get spanDao => _spanDao ??= SpanDao(this as CurbWheelDatabase);
  PointDao _pointDao;
  PointDao get pointDao => _pointDao ??= PointDao(this as CurbWheelDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [projects, features, surveys, spans, points];
}
