import 'database.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Count {
  final int completeCount;
  final int activeCount;

  Count({this.completeCount, this.activeCount});
}

class PhotoWithParents {
  final Photo photo;
  final SurveyPoint point;
  final SurveyItem surveyItem;
  final Survey survey;
  final Project project;

  PhotoWithParents(
      {this.photo, this.point, this.surveyItem, this.survey, this.project});
}

class SurveyItemWithFeature {
  SurveyItemWithFeature(this.surveyItem, this.feature);

  final SurveyItem surveyItem;
  final FeatureType feature;
}

class ListItem {
  final String surveyId;
  final String surveyItemId;
  final String featureId;
  final String geometryType; // line or point
  final String color;
  final String name;
  SpanContainer span;
  List<PointContainer> points;
  bool complete;

  ListItem(
      {this.surveyId,
      this.surveyItemId,
      this.featureId,
      this.geometryType,
      this.color,
      this.name,
      this.span,
      this.points,
      this.complete = false});

  SurveyItemsCompanion toSurveyItemsCompanion() {
    return SurveyItemsCompanion(
        id: moor.Value(this.surveyItemId),
        surveyId: moor.Value(this.surveyId),
        featureId: moor.Value(this.featureId),
        complete: moor.Value(this.complete));
  }

  SurveyItem toSurveyItem() {
    return SurveyItem(
        id: this.surveyItemId,
        surveyId: this.surveyId,
        featureId: this.featureId,
        complete: this.complete);
  }

  SurveySpansCompanion toSpansCompanion() {
    return SurveySpansCompanion(
        id: moor.Value(this.span.id),
        surveyItemId: moor.Value(this.surveyItemId),
        start: moor.Value(this.span.start),
        stop: moor.Value(this.span.stop));
  }

  SurveySpan toSurveySpan() {
    return SurveySpan(
        id: this.span.id,
        surveyItemId: this.surveyItemId,
        start: this.span.start,
        stop: this.span.stop);
  }

  List<SurveyPointsCompanion> toPointsCompanion() {
    List<SurveyPointsCompanion> pointsCompanions = [];
    for (PointContainer point in this.points) {
      pointsCompanions.add(SurveyPointsCompanion(
          id: moor.Value(point.id),
          surveyItemId: moor.Value(this.surveyItemId),
          position: moor.Value(point.position)));
    }
    return pointsCompanions;
  }
}

class PointContainer {
  String id;
  final String surveyItemId;
  final double position;

  PointContainer({this.id, this.surveyItemId, this.position});
}

class SpanContainer {
  String id;
  final String surveyItemId;
  final double start;
  double stop;

  SpanContainer({this.id, this.surveyItemId, this.start, this.stop});
}
