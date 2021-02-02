// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return Config(
    projectId: json['projectId'] as String,
    projectName: json['projectName'] as String,
    email: json['email'] as String,
    mapData: json['mapData'] as String,
    organization: json['organization'] as String,
    featureTypes: (json['featureTypes'] as List)
        .map((e) => FeatureType.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'projectId': instance.projectId,
      'projectName': instance.projectName,
      'email': instance.email,
      'mapData': instance.mapData,
      'organization': instance.organization,
      'featureTypes': instance.featureTypes,
    };

FeatureType _$FeatureTypeFromJson(Map<String, dynamic> json) {
  return FeatureType(
    geometryType: json['geometryType'] as String,
    color: json['color'] as String,
    label: json['label'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$FeatureTypeToJson(FeatureType instance) =>
    <String, dynamic>{
      'geometryType': instance.geometryType,
      'color': instance.color,
      'label': instance.label,
      'value': instance.value,
    };
