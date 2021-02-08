import 'package:curbwheel/service/models.dart';
import 'package:flutter/material.dart';

class ProjectConfigCard extends StatelessWidget {
  final Config config;
  final mapData;
  const ProjectConfigCard({Key key, this.config, this.mapData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(config.featureTypes);

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
              subtitle: config.organization != null
                  ? Text(config.organization)
                  : Text(""),
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
                          style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(""),
                      FeatureTypeList(config)
                    ]))
          ],
        ),
      ),
    );
  }
}

class FeatureTypeList extends StatelessWidget {
  final Config config;

  FeatureTypeList(this.config);

  @override
  Widget build(BuildContext context) {
    List<Widget> featureTypeList = [];
    featureTypeList.add(Text("Feature types:"));
    for (var featureType in config.featureTypes) {
      featureTypeList.add(
        Text(
          "\u2022 ${featureType.label}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: featureTypeList
      ),
    );
  }
}
