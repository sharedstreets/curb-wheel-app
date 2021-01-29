import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/database/models.dart';
import 'package:curbwheel/ui/shared/utils.dart';
import 'package:curbwheel/ui/wheel/wheel_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FeatureSelectScreenArguments {
  final Project project;
  final Survey survey;
  final double position;
  final List<ListItem> listItems;

  FeatureSelectScreenArguments(
      this.project, this.survey, this.position, this.listItems);
}

class FeatureSelectScreen extends StatefulWidget {
  static const routeName = '/feature-select';

  @override
  _FeatureSelectScreenState createState() => _FeatureSelectScreenState();
}

class _FeatureSelectScreenState extends State<FeatureSelectScreen> {
  CurbWheelDatabase _database;

  @override
  Widget build(BuildContext context) {
    _database = Provider.of<CurbWheelDatabase>(context);
    final FeatureSelectScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    final Project project = args.project;
    final Survey survey = args.survey;
    final double position = args.position;
    final List<ListItem> listItems = args.listItems;
    Future<List<Feature>> features =
        _database.featureDao.getAllFeaturesByProject(survey.projectId);

    return FutureBuilder<List<Feature>>(
        future: features,
        builder: (BuildContext context, AsyncSnapshot<List<Feature>> snapshot) {
          if (snapshot.hasData) {
            var features = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text("Select a feature type"),
              ),
              body: Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: ListView.builder(
                    itemCount: features.length,
                    itemBuilder: (context, index) {
                      return FeatureCard(features[index], project, survey,
                          position, listItems);
                    }),
              ),
            );
          } else {
            return Text("Loading features");
          }
        });
  }
}

class FeatureCard extends StatelessWidget {
  final Feature feature;
  final Project project;
  final Survey survey;
  final double position;
  final List<ListItem> listItems;

  FeatureCard(
      this.feature, this.project, this.survey, this.position, this.listItems);

  @override
  Widget build(BuildContext context) {
    onPressFeatureCard() {
      var listItem = ListItem(
          surveyId: survey.id,
          featureId: feature.id,
          geometryType: feature.geometryType,
          name: feature.name,
          color: feature.color,
          span: SpanContainer(
            start: position,
            stop: position
          ),
          points: []);
      listItems.add(listItem);

      Navigator.pushNamedAndRemoveUntil(
          context, WheelScreen.routeName, ModalRoute.withName('/map'),
          arguments: WheelScreenArguments(project, survey, listItems));
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
                          child: Text(feature.name))
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}
