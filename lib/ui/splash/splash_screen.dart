import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;

import 'package:curbwheel/ui/projects/project_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Spoke {
  final int theta1;
  final int theta2;
  final List<int> offsets;
  final MaterialColor color;

  Spoke(this.theta1, this.theta2, this.offsets, this.color);
}

class SplashScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _MyPainterState createState() => _MyPainterState();
}

class _MyPainterState extends State<SplashScreen>
    with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    Tween<double> _rotationTween = Tween(begin: -math.pi, end: 4 * math.pi);

    animation = _rotationTween.animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    ))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        key: Key('gestureDetector'),
        behavior: HitTestBehavior.opaque,
        onTap: () => {
          controller.forward(),
          Timer(
              Duration(seconds: 2),
              () => {
                    controller.stop(),
                    Navigator.pushReplacementNamed(
                        context, ProjectListScreen.routeName)
                  })
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Text(
                "CurbWheel",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline1,
              )),
              Center(
                  child: Text(AppLocalizations.of(context).welcome,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle2,
              )),
              Expanded(
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, snapshot) {
                    return CustomPaint(
                      painter: ShapePainter(150, animation.value),
                      child: Container(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final double radius;
  final double radians;
  ShapePainter(this.radius, this.radians);

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);

    Paint grayBrush = new Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawLine(
        Offset(-(radius * math.cos(-radians)) + center.dx,
            (radius * math.sin(-radians)) + center.dy),
        Offset((radius * math.cos(-radians)) + center.dx,
            -(radius * math.sin(-radians)) + center.dy),
        grayBrush);
    canvas.drawLine(
        Offset(-(radius * math.cos(-radians + math.pi / 2)) + center.dx,
            (radius * math.sin(-radians + math.pi / 2)) + center.dy),
        Offset((radius * math.cos(-radians + math.pi / 2)) + center.dx,
            -(radius * math.sin(-radians + math.pi / 2)) + center.dy),
        grayBrush);

    final spokeValues = [
      Spoke(190, -100, [0, 1, 1, 0], Colors.red),
      Spoke(170, 100, [0, 1, -1, 0], Colors.yellow),
      Spoke(10, 80, [0, -1, -1, 0], Colors.blue),
      Spoke(-10, -80, [0, -1, 1, 0], Colors.grey),
    ];

    void drawSpoke(Spoke spoke) {
      Paint brush = Paint()
        ..color = spoke.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10.0;
      var anchorX1 = center.dx +
          math.sin(spoke.theta1 * (math.pi / 180)) * radius +
          (spoke.offsets[0] * 20);
      var anchorY1 = center.dy +
          math.cos(spoke.theta2 * (math.pi / 180)) * radius +
          (spoke.offsets[1] * 20);
      var x1 = math.cos(radians) * (anchorX1 - center.dx) -
          math.sin(radians) * (anchorY1 - center.dy) +
          center.dx;
      var y1 = math.sin(radians) * (anchorX1 - center.dx) +
          math.cos(radians) * (anchorY1 - center.dy) +
          center.dy;
      var anchorX2 = center.dx +
          math.sin(spoke.theta1 * (math.pi / 180)) * radius +
          (spoke.offsets[2] * 20);
      var anchorY2 = center.dy +
          math.cos(spoke.theta2 * (math.pi / 180)) * radius +
          (spoke.offsets[3] * 20);
      var x2 = math.cos(radians) * (anchorX2 - center.dx) -
          math.sin(radians) * (anchorY2 - center.dy) +
          center.dx;
      var y2 = math.sin(radians) * (anchorX2 - center.dx) +
          math.cos(radians) * (anchorY2 - center.dy) +
          center.dy;

      Path path = Path();
      path.moveTo(
          math.sin(-radians + spoke.theta1 * (math.pi / 180)) * radius +
              center.dx,
          math.cos(-radians + spoke.theta1 * (math.pi / 180)) * radius +
              center.dy);
      path.cubicTo(
          x1,
          y1,
          x2,
          y2,
          math.sin(-radians + spoke.theta2 * (math.pi / 180)) * radius +
              center.dx,
          math.cos(-radians + spoke.theta2 * (math.pi / 180)) * radius +
              center.dy);
      canvas.drawPath(path, brush);
    }

    for (final spoke in spokeValues) {
      drawSpoke(spoke);
    }

    Paint wheelBrush = new Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), radius, wheelBrush);

    Paint centerBrush = new Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 10;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), radius / 5, centerBrush);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
