import 'package:curbwheel/ui/map/street_review_map_screen.dart';
import 'package:curbwheel/ui/map/street_select_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../../database/database.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    Key key,
    this.project,
  }) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    var _database = Provider.of<CurbWheelDatabase>(context);

    Future<List<Survey>> _surveys =
        _database.surveyDao.getAllSurveysByProjectId(project.id);
    return Card(
      child: InkWell(
        splashColor: Colors.white.withAlpha(100),
        onTap: () async {
          final location = Location();
          final hasPermissions = await location.hasPermission();

          if (hasPermissions != PermissionStatus.granted) {
            await location.requestPermission();
          }
          Navigator.pushNamed(context, StreetSelectMapScreen.routeName,
              arguments: StreetSelectMapScreenArguments(project));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                  child: Icon(Icons.map),
                  onTap: () {
                    Navigator.pushNamed(
                        context, StreetReviewMapScreen.routeName,
                        arguments: StreetReviewMapScreenArguments(project));
                  }),
              trailing: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () {
                  try {
                    _database.projectDao.deleteProject(project);
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              title: Text(
                project.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: FutureBuilder<List<Survey>>(
                  future: _surveys,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Survey>> snapshot) {
                    if (snapshot.data.length != null &&
                        snapshot.data.length > 0)
                      return Text(snapshot.data.length.toString() +
                          " streets surveyed");
                    else
                      return Text("Ready survey!");
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
