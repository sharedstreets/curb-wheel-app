import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;

class SurveyItemWithFeature {
  SurveyItemWithFeature(this.surveyItem, this.feature);

  final SurveyItem surveyItem;
  final Feature feature;
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

  final int surveyId;
  final int surveyItemId;
  final int featureId;
  final String geometryType; // line or point
  final String color;
  final String name;
  final SpanContainer span;
  final List<PointContainer> points;

  SurveyItemsCompanion toSurveyItemsCompanion() {
    return SurveyItemsCompanion(
        surveyId: moor.Value(this.surveyId),
        featureId: moor.Value(this.featureId));
  }

  SpansCompanion toSpansCompanion(int surveyItemId) {
    return SpansCompanion(
        surveyItemId: moor.Value(surveyItemId),
        start: moor.Value(this.span.start),
        stop: moor.Value(this.span.stop));
  }

  List<PointsCompanion> toPointsCompanion(int surveyItemId, int spanId) {
    List<PointsCompanion> pointsCompanions = [];
    for (PointContainer point in this.points) {
      pointsCompanions.add(PointsCompanion(
          surveyItemId: moor.Value(surveyItemId),
          position: moor.Value(point.position)));
    }
    return pointsCompanions;
  }
}

class PointContainer {
  PointContainer({this.surveyItemId, this.position});

  final int surveyItemId;
  final double position;
}

class SpanContainer {
  SpanContainer({this.surveyItemId, this.start, this.stop});

  final int surveyItemId;
  final double start;
  double stop;

}
