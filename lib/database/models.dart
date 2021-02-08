import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class SurveyItemWithFeature {
  SurveyItemWithFeature(this.surveyItem, this.feature);

  final SurveyItem surveyItem;
  final FeatureType feature;
}

class ListItem {
  ListItem(
      {this.surveyId,
      this.surveyItemId,
      this.featureId,
      this.geometryType,
      this.color,
      this.name,
      this.span,
      this.points});

  final String surveyId;
  final String surveyItemId;
  final String featureId;
  final String geometryType; // line or point
  final String color;
  final String name;
  SpanContainer span;
  List<PointContainer> points;

  SurveyItemsCompanion toSurveyItemsCompanion() {
    return SurveyItemsCompanion(
        id: moor.Value(this.surveyItemId),
        surveyId: moor.Value(this.surveyId),
        featureId: moor.Value(this.featureId));
  }

  SurveySpansCompanion toSpansCompanion() {
    return SurveySpansCompanion(
        id: moor.Value(uuid.v4()),
        surveyItemId: moor.Value(this.surveyItemId),
        start: moor.Value(this.span.start),
        stop: moor.Value(this.span.stop));
  }

  List<SurveyPointsCompanion> toPointsCompanion() {
    List<SurveyPointsCompanion> pointsCompanions = [];
    for (PointContainer point in this.points) {
      pointsCompanions.add(SurveyPointsCompanion(
          id: moor.Value(uuid.v4()),
          surveyItemId: moor.Value(this.surveyItemId),
          position: moor.Value(point.position)));
    }
    return pointsCompanions;
  }
}

class PointContainer {
  PointContainer({this.surveyItemId, this.position});

  final String surveyItemId;
  final double position;
}

class SpanContainer {
  SpanContainer({this.surveyItemId, this.start, this.stop});

  final String surveyItemId;
  final double start;
  double stop;
}
