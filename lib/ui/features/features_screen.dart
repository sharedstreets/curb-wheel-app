import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/ui/map/map_screen.dart';
import 'package:curbwheel/ui/wheel/wheel_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;

class FeatureSelectScreen extends StatefulWidget {
  final Project project;
  final Street street;
  final double position;
  final List<SpansCompanion> spans;

  FeatureSelectScreen(this.project, this.street, this.position, this.spans);

  @override
  _FeatureSelectScreenState createState() => _FeatureSelectScreenState();
}

class _FeatureSelectScreenState extends State<FeatureSelectScreen> {
  CurbWheelDatabase _database;
  List<Feature> features = [
    Feature(
        id: 1,
        color: "0054aa",
        label: "curb cut",
        geometryType: "line",
        value: "curb_cut",
        projectId: 1234),
    Feature(
        id: 1,
        color: "b80d00",
        label: "curb cut",
        geometryType: "line",
        value: "curb_cut",
        projectId: 1234)
  ];

  SpansCompanion createSpan(Feature feature) {
    return SpansCompanion(
        start: moor.Value(widget.position),
        type: moor.Value(feature.value),
        complete: moor.Value(false));
  }

  onPressFeatureCard(Feature feature) {
    var span = createSpan(feature);
    widget.spans.add(span);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WheelScreen(widget.project, widget.street)));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a feature type"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: ListView.builder(
            itemCount: features.length,
            itemBuilder: (context, index) {
              return FeatureCard(
                  features[index], onPressFeatureCard(features[index]));
            }),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final Feature feature;
  final Function callback;

  FeatureCard(this.feature, this.callback);

  @override
  Widget build(BuildContext context) {
    final String assetName = feature.geometryType == 'line'
        ? 'assets/vector-line.svg'
        : 'assets/map-marker.svg';
    final String semanticsLabel =
        feature.geometryType == 'line' ? 'line type' : 'point type';
    final Widget svgIcon = SvgPicture.asset(assetName,
        color: Colors.black, semanticsLabel: semanticsLabel);
    return GestureDetector(
        onTap: () {
          this.callback();
        },
        child: new Container(
          height: 56,
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[300])),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: colorConvert(feature.color),
                          ),
                          height: 48,
                          width: 10),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                        child: svgIcon,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: Text(feature.label))
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}

Color colorConvert(String color) {
  color = color.replaceAll("#", "");
  if (color.length == 6) {
    return Color(int.parse("0xFF" + color));
  } else if (color.length == 8) {
    return Color(int.parse("0x" + color));
  }
  return Color(0xFFFFFFFF);
}
