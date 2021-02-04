import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';


@JsonSerializable(nullable: false)
class Config {
  final String projectId;
  final String projectName;
  final String email;
  final String mapData;
  final String organization;
  final List<FeatureType> featureTypes;

  Config(
      {this.projectId,
      this.projectName,
      this.email,
      this.mapData,
      this.organization,
      this.featureTypes});

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json); 
}

@JsonSerializable(nullable: false)
class FeatureType {
  final String geometryType;
  final String color;
  final String label;
  final String value;

  FeatureType({this.geometryType, this.color, this.label, this.value});

  factory FeatureType.fromJson(Map<String, dynamic> json) => _$FeatureTypeFromJson(json);
}