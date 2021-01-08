import 'package:flutter/material.dart';
import '../../database/database.dart';
import '../map/map_screen.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    Key key,
    this.project,
  }) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            splashColor: Colors.white.withAlpha(100),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MapScreen(project:project)));
            },
                    child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text(project.name),
              subtitle: Text(project.organization),
            ),
           ],
          ),
          ),
          );
  }
}
