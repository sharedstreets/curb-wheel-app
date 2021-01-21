import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/ui/wheel/wheel_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:provider/provider.dart';

class FeatureSelectScreenArguments {
  final Project project;
  final Survey survey;
  final double position;
  final List<SpansCompanion> spans;

  FeatureSelectScreenArguments(
      this.project, this.survey, this.position, this.spans);
}

class FeatureSelectScreen extends StatefulWidget {
  static const routeName = '/feature-select';

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
        id: 2,
        color: "b80d00",
        label: "curb cut",
        geometryType: "line",
        value: "curb_cut",
        projectId: 1234)
  ];

  @override
  Widget build(BuildContext context) {
    _database = Provider.of<CurbWheelDatabase>(context);
    final FeatureSelectScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    final Project project = args.project;
    final Survey survey = args.survey;
    final double position = args.position;
    final List<SpansCompanion> spans = args.spans;

    return Scaffold(
      appBar: AppBar(
        title: Text("Select a feature type"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: ListView.builder(
            itemCount: features.length,
            itemBuilder: (context, index) {
              return FeatureCard(features[index], project, survey, position, spans);
            }),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final Feature feature;
  final Project project;
  final Survey survey;
  final double position;
  final List<SpansCompanion> spans;

  FeatureCard(this.feature, this.project, this.survey, this.position, this.spans);

  @override
  Widget build(BuildContext context) {
    onPressFeatureCard() {
      var span = SpansCompanion(
          start: moor.Value(position),
          type: moor.Value(feature.value),
          complete: moor.Value(false));
      spans.add(span);

      Navigator.pushNamedAndRemoveUntil(
          context, WheelScreen.routeName, ModalRoute.withName('/map'),
          arguments: WheelScreenArguments(project, survey, spans));
    }

    final String assetName = feature.geometryType == 'line'
        ? 'assets/vector-line.svg'
        : 'assets/map-marker.svg';
    final String semanticsLabel =
        feature.geometryType == 'line' ? 'line type' : 'point type';
    final Widget svgIcon = SvgPicture.asset(assetName,
        color: Colors.black, semanticsLabel: semanticsLabel);
    return GestureDetector(
        onTap: () {
          onPressFeatureCard();
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
