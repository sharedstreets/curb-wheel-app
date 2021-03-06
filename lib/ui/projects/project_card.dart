import 'package:curbwheel/service/sync.dart';
import 'package:curbwheel/ui/map/street_review_map_screen.dart';
import 'package:curbwheel/ui/map/street_select_map_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:qr_flutter/qr_flutter.dart';

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

    Stream<List<Survey>> _surveys =
        _database.surveyDao.getAllSurveysByProjectIdStream(project.id);
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
              trailing: TextButton(
                child: Icon(Icons.more_horiz),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(children: <Widget>[
                          ListTile(
                              subtitle: Text("ID: " + project.projectId),
                              title: Text(
                                project.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          GestureDetector(
                              child: ListTile(
                                  leading: Icon(Icons.share),
                                  title: Text(AppLocalizations.of(context)
                                      .shareProject)),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext contex) =>
                                        AlertDialog(
                                            title: Text(
                                              AppLocalizations.of(context)
                                                  .shareProject,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: Container(
                                                height: 300,
                                                width: 300,
                                                child:
                                                    Column(children: <Widget>[
                                                  Expanded(
                                                      child: QrImage(
                                                    data: project
                                                        .projectConfigUrl,
                                                    version: QrVersions.auto,
                                                    size: 300.0,
                                                  )),
                                                  TextButton(
                                                      onPressed: () {
                                                        Clipboard.setData(
                                                            new ClipboardData(
                                                                text: project
                                                                    .projectConfigUrl));
                                                      },
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .copyProjectUrl)),
                                                  Text(AppLocalizations.of(
                                                          context)
                                                      .sharingInstructions),
                                                ]))));
                              }),
                          GestureDetector(
                              child: ListTile(
                                  leading: Icon(Icons.list_alt),
                                  title: Text(AppLocalizations.of(context)
                                      .reviewCompletedSurveys)),
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

                              showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                          actions: [
                                            TextButton(
                                              child: Text('Close'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                          title: Row(children: [
                                            Icon(Icons.sync_alt),
                                            Text('Project Syncing...')
                                          ]),
                                          content: Consumer<ProjectSyncService>(
                                              builder: (context, syncService,
                                                  child) {
                                            if (syncService.status != null &&
                                                syncService
                                                        .status.currentStatus !=
                                                    null) {
                                              return IntrinsicHeight(
                                                  child: Column(children: [
                                                Text(syncService
                                                    .status.currentStatus),
                                                Text(syncService
                                                        .status.completeFiles
                                                        .toString() +
                                                    "/" +
                                                    syncService
                                                        .status.totalFiles
                                                        .toString() +
                                                    " files uploaded")
                                              ]));
                                            } else {
                                              return Text("starting upload...");
                                            }
                                          }));
                                    });
                                  });
                            },
                            child: ListTile(
                              leading: Icon(Icons.sync_alt),
                              title:
                                  Text(AppLocalizations.of(context).syncData),
                            ),
                          ),
                          GestureDetector(
                              child: ListTile(
                                  leading: Icon(Icons.delete_forever),
                                  title: Text(AppLocalizations.of(context)
                                      .deleteProject)),
                              onTap: () {
                                // set up the buttons

                                Widget cancelButton = TextButton(
                                  child:
                                      Text(AppLocalizations.of(context).cancel),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                );
                                Widget continueButton = TextButton(
                                  child:
                                      Text(AppLocalizations.of(context).delete),
                                  onPressed: () async {
                                    try {
                                      await _database.projectDao
                                          .deleteProject(project);
                                    } catch (exception, stackTrace) {
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
                                  title: Text(AppLocalizations.of(context)
                                      .deleteProject),
                                  content: Text(AppLocalizations.of(context)
                                      .deleteProjectWarningBody),
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
              subtitle: StreamBuilder<List<Survey>>(
                  stream: _surveys,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Survey>> snapshot) {
                    if (snapshot.data != null &&
                        snapshot.data.length != null &&
                        snapshot.data.length > 0)
                      return Text(AppLocalizations.of(context)
                          .streetSurveyCount(snapshot.data.length));
                    else
                      return Text(AppLocalizations.of(context).readyToSurvey);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
