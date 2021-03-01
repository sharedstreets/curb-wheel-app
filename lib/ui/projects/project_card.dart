import 'package:curbwheel/service/sync.dart';
import 'package:curbwheel/ui/map/street_review_map_screen.dart';
import 'package:curbwheel/ui/map/street_select_map_screen.dart';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
    ProjectSyncService sync = Provider.of<ProjectSyncService>(context);

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
              leading: Icon(Icons.location_city_sharp),
              trailing: GestureDetector(
                child: Icon(Icons.more_horiz),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(children: <Widget>[
                          ListTile(
                              title: Text(
                            project.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          GestureDetector(
                              child: ListTile(
                                  leading: Icon(Icons.list_alt),
                                  title: Text("Review completed surveys")),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.pushNamed(
                                    context, StreetReviewMapScreen.routeName,
                                    arguments: StreetReviewMapScreenArguments(
                                        project));
                              }),
                          GestureDetector(
                              onTap: () async {
                                Navigator.of(context).pop();

                                sync.syncProject(project);

                                // showDialog<void>(
                                //     context: context,
                                //     barrierDismissible:
                                //         false, // user must tap button!
                                //     builder: (BuildContext context) {
                                //       return AlertDialog(
                                //         title: Text('Project Syncing...'),
                                //         content: Consumer<ProjectSyncService>(
                                //             builder:
                                //                 (context, syncService, child) {
                                //           return ListView(
                                //             children: [
                                //               Row(
                                //                 children: [
                                //                   CircularProgressIndicator(),
                                //                   Text(
                                //                       syncService.status != null
                                //                           ? syncService.status
                                //                               .currentStatus
                                //                           : "")
                                //                 ],
                                //               ),
                                //               Row(
                                //                 children: [
                                //                   Text(syncService.status !=
                                //                               null &&
                                //                           syncService.status
                                //                                   .currentFile !=
                                //                               null
                                //                       ? syncService
                                //                               .status.completeFiles
                                //                               .toString() +
                                //                           " / " +
                                //                           syncService
                                //                               .status.totalFiles
                                //                               .toString() +
                                //                           syncService.status
                                //                               .currentFile
                                //                       : "")
                                //                 ],
                                //               )
                                //             ],
                                //           );
                                //         }),
                                //         actions: <Widget>[
                                //           TextButton(
                                //             child: Text('Ok'),
                                //             onPressed: () {
                                //               Navigator.of(context).pop();
                                //             },
                                //           ),
                                //         ],
                                //       );
                                //     });
                              },
                              child: ListTile(
                                  leading: Icon(Icons.sync_alt),
                                  title: Text("Sync data"))),
                          GestureDetector(
                              child: ListTile(
                                  leading: Icon(Icons.delete_forever),
                                  title: Text("Delete project")),
                              onTap: () {
                                // set up the buttons

                                Widget cancelButton = FlatButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                );
                                Widget continueButton = FlatButton(
                                  child: Text("Delete"),
                                  onPressed: () async {
                                    try {
                                      await _database.projectDao
                                          .deleteProject(project);
                                    }  catch (exception, stackTrace) {
                                      await Sentry.captureException(
                                        exception,
                                        stackTrace: stackTrace,
                                      );
                                    }
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                );

                                AlertDialog alert = AlertDialog(
                                  title: Text("Delete Project"),
                                  content: Text(
                                      "Are you sure you want to perminately delete this project and all related data from this phone?"),
                                  actions: [
                                    cancelButton,
                                    continueButton,
                                  ],
                                );

                                // show the dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              }),
                        ]);
                      });
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
                    if (snapshot.data != null &&
                        snapshot.data.length != null &&
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
