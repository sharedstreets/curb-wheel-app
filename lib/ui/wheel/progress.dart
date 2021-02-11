import 'package:flutter/material.dart';
/*
class CurbSpan extends StatefulWidget {
  final double start;
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double progressStrokeWidth;
  final double backgroundStrokeWidth;
  final List<double> points;

  CurbSpan(
      {Key key,
      this.start = 0,
      this.progress,
      this.progressColor = Colors.blue,
      this.backgroundColor = Colors.grey,
      this.progressStrokeWidth = 10.0,
      this.backgroundStrokeWidth = 5.0,
      this.points
      })
      : super(key: key);

  @override
  _CurbSpanState createState() => _CurbSpanState();
}

class _CurbSpanState extends State<CurbSpan> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        foregroundPainter: ProgressPainter(
            progress: widget.progress,
            start: widget.start,
            progressColor: widget.progressColor,
            backgroundColor: widget.backgroundColor,
            progressStrokeWidth: widget.progressStrokeWidth,
            backgroundStrokeWidth: widget.backgroundStrokeWidth,
            points: widget.points),
        child: Center());
  }
}

class ProgressBar extends StatefulWidget {
  final double progress;

  ProgressBar({Key key, this.progress}) : super(key: key);

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        foregroundPainter: ProgressPainter(
            progress: widget.progress,
            start: 0.0,
            progressColor: Colors.blue,
            backgroundColor: Colors.grey,
            progressStrokeWidth: 10.0,
            backgroundStrokeWidth: 10.0),
        child: Center());
  }
}

class ProgressPainter extends CustomPainter {
  final Paint _paintBackground = new Paint();
  final Paint _paintProgress = new Paint();
  final Paint _paintPoint = new Paint();
  final Paint _paintPointCenter = new Paint();
  final Color backgroundColor;
  final Color progressColor;
  final double start;
  final double progress;
  final double progressStrokeWidth;
  final double backgroundStrokeWidth;
  final List<double> points;

  ProgressPainter(
      {this.start,
      this.progress,
      this.progressColor,
      this.backgroundColor,
      this.progressStrokeWidth,
      this.backgroundStrokeWidth,
      this.points}) {
    _paintBackground.color = backgroundColor;
    _paintBackground.style = PaintingStyle.stroke;
    _paintBackground.strokeWidth = backgroundStrokeWidth;
    _paintBackground.strokeCap = StrokeCap.round;
    _paintProgress.color = progressColor;
    _paintProgress.style = PaintingStyle.stroke;
    _paintProgress.strokeWidth = progressStrokeWidth;
    _paintProgress.strokeCap = StrokeCap.round;
    _paintPoint.color = progressColor;
    _paintPoint.style = PaintingStyle.fill;
    _paintPointCenter.color = Colors.white;
    _paintPointCenter.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final startOffset = Offset(0.0, size.height / 2);
    final endOffset = Offset(size.width, size.height / 2);
    canvas.drawLine(startOffset, endOffset, _paintBackground);
    final xStart = size.width * start;
    var cappedProgress = progress;
    if (progress > 1) {
      cappedProgress = 1.0;
    }
    var xProgress = size.width * cappedProgress;
    final progressStart = Offset(xStart, size.height / 2);
    canvas.drawLine(
        progressStart, Offset(xProgress, size.height / 2), _paintProgress);
    for (var point in points) {
      var pointPos = size.width * point;
      final pointX = Offset(pointPos, size.height / 2);
      canvas.drawCircle(pointX, progressStrokeWidth * 0.75, _paintPoint);
      canvas.drawCircle(pointX, progressStrokeWidth * 0.25,  _paintPointCenter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final old = oldDelegate as ProgressPainter;
    return old.progress != this.progress ||
        old.start != this.start ||
        old.progressColor != this.progressColor ||
        old.backgroundColor != this.backgroundColor ||
        old.progressStrokeWidth != this.progressStrokeWidth ||
        old.backgroundStrokeWidth != this.backgroundStrokeWidth;
  }
}
*/

class ProgressBar extends StatefulWidget {
  final double start;
  //final double min;
  final double max;
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double progressStrokeWidth;
  final double backgroundStrokeWidth;
  final List<double> points;

  ProgressBar(
      {Key key,
      this.start = 0,
      //this.min = 0,
      this.max = 1,
      this.progress,
      this.progressColor = Colors.blue,
      this.backgroundColor = Colors.grey,
      this.progressStrokeWidth = 10.0,
      this.backgroundStrokeWidth = 5.0,
      this.points = const []})
      : super(key: key);

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        foregroundPainter: ProgressBarPainter(
            progress: widget.progress,
            start: widget.start,
            max: widget.max,
            //min: widget.min,
            progressColor: widget.progressColor,
            backgroundColor: widget.backgroundColor,
            progressStrokeWidth: widget.progressStrokeWidth,
            backgroundStrokeWidth: widget.backgroundStrokeWidth,
            points: widget.points),
        child: Center());
  }
}

class ProgressBarPainter extends CustomPainter {
  final Paint _paintBackground = new Paint();
  final Paint _paintProgress = new Paint();
  final Paint _paintPoint = new Paint();
  final Paint _paintPointCenter = new Paint();
  final Color backgroundColor;
  final Color progressColor;
  final double start;
  final double min;
  final double max;
  final double progress;
  final double progressStrokeWidth;
  final double backgroundStrokeWidth;
  final List<double> points;

  ProgressBarPainter(
      {this.start,
      this.min,
      this.max,
      this.progress,
      this.progressColor,
      this.backgroundColor,
      this.progressStrokeWidth,
      this.backgroundStrokeWidth,
      this.points}) {
    _paintBackground.color = backgroundColor;
    _paintBackground.style = PaintingStyle.stroke;
    _paintBackground.strokeCap = StrokeCap.round;
    _paintBackground.strokeWidth = backgroundStrokeWidth;
    _paintProgress.color = progressColor;
    _paintProgress.style = PaintingStyle.stroke;
    _paintProgress.strokeCap = StrokeCap.round;
    _paintProgress.strokeWidth = progressStrokeWidth;
    _paintPoint.color = progressColor;
    _paintPoint.style = PaintingStyle.fill;
    _paintPointCenter.color = Colors.white;
    _paintPointCenter.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final startOffset = Offset(0.0, size.height / 2);
    final endOffset = Offset(size.width, size.height / 2);
    canvas.drawLine(startOffset, endOffset, _paintBackground);
    final xStart = size.width * start / max;
    var precentProgress = progress / max;
    var cappedPercentProgress = precentProgress;
    if (precentProgress > 1) {
      cappedPercentProgress = 1.0;
    }
    var xProgress = size.width * cappedPercentProgress;
    final progressStart = Offset(xStart, size.height / 2);
    canvas.drawLine(
        progressStart, Offset(xProgress, size.height / 2), _paintProgress);
    for (var point in points) {
      var pointPos = size.width * (point / max);
      final pointX = Offset(pointPos, size.height / 2);
      canvas.drawCircle(pointX, progressStrokeWidth * 0.75, _paintPoint);
      canvas.drawCircle(pointX, progressStrokeWidth * 0.25, _paintPointCenter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final old = oldDelegate as ProgressBarPainter;
    return old.progress != this.progress ||
        old.start != this.start ||
        old.progressColor != this.progressColor ||
        old.backgroundColor != this.backgroundColor ||
        old.progressStrokeWidth != this.progressStrokeWidth ||
        old.backgroundStrokeWidth != this.backgroundStrokeWidth;
  }
}
