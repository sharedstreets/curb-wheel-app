import 'package:flutter/material.dart';
import '../../database/database.dart';
import '../map/map_screen.dart';

class ProjectConfigCard extends StatelessWidget {
  final config;
  final mapData;
  const ProjectConfigCard({Key key, this.config, this.mapData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                config.projectName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(config.organization),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Primary contact:"),
                      Text(config.email,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(""),
                      Text("Map data:"),
                      Text(
                          mapData.featureCollection.features.length.toString() +
                              " segments",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]))
          ],
        ),
      ),
    );
  }
}
