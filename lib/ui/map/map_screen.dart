import 'package:curbwheel/database/survey_dao.dart';
import 'package:curbwheel/ui/wheel/incomplete_spans.dart';
import 'package:curbwheel/ui/wheel/wheel_screen.dart';
import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';
import '../../database/database.dart';

class MapScreenArguments {
  final Project project;

  MapScreenArguments(this.project);
}

/*
class MapScreen extends StatefulWidget {
  final Project project;

  const MapScreen({Key key, this.project}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //CurbWheelDatabase _database;
  @override
  Widget build(BuildContext context) {
    //_database = Provider.of<CurbWheelDatabase>(context);
    //Stream<List<Project>> _projects = _database.projectDao.watc();
    return Scaffold(appBar: AppBar(
        title: Text(
          widget.project.name,
          //style: TextStyle(color: Colors.white),
        ),
    ));
  }
}
*/

class MapScreen extends StatelessWidget {
  static const routeName = '/map';
  final Project project;

  CurbWheelDatabase _database;
  SurveyDao surveyDao;

  final List<Street> items = [
    Street("1234", "Dartmouth Dr. NE", "right"),
    Street("9876", "Street 2", "left")
  ];

  MapScreen({Key key, this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = "Select a street";

    List<SpanContainer> spans = [];

    _database = Provider.of<CurbWheelDatabase>(context);
    surveyDao = _database.surveyDao;

    final MapScreenArguments args = ModalRoute.of(context).settings.arguments;
    var project = args.project;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          var street = items[index];
          return ListTile(
            title: Text('${street.name}'),
            onTap: () async {
              var surveysCompanion = SurveysCompanion(
                  shStRefId: moor.Value(street.shStRefId),
                  streetName: moor.Value(street.name),
                  length: moor.Value(42),
                  startStreetName: moor.Value("Campus Blvd."),
                  endStreetName: moor.Value("Richmond Pl."),
                  direction: moor.Value("up"),
                  side: moor.Value(street.side));
              int surveyId = await surveyDao.insertSurvey(surveysCompanion);
              Survey survey = await surveyDao.getSurveyById(surveyId);
              Navigator.pushNamed(context, WheelScreen.routeName,
                  arguments: WheelScreenArguments(project, survey, spans));
            },
          );
        },
      ),
    );
  }
}

class Street {
  final String shStRefId;
  final String name;
  final String side;

  Street(this.shStRefId, this.name, this.side);
}
