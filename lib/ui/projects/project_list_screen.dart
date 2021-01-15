import 'package:curbwheel/client/config_client.dart';
import 'package:curbwheel/ui/projects/add_project_form.dart';
import 'package:curbwheel/ui/projects/qr_scanner.dart';
import 'package:curbwheel/utils/write_file.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:curbwheel/database/database.dart';
import 'project_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Action { form, qrcode }

class ProjectListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProjectListScreenState();
  }
}

class ProjectListScreenState extends State<ProjectListScreen> {
  CurbWheelDatabase _database;
  @override
  Widget build(BuildContext context) {
    _database = Provider.of<CurbWheelDatabase>(context);

    Future<void> _addProjectOption() async {
      switch (await showDialog<Action>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('Add project'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, Action.qrcode);
                  },
                  child: Row(children: <Widget>[
                    Icon(Icons.qr_code_scanner),
                    Text('  Scan QR Code',
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ]),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, Action.form);
                  },
                  child: Row(children: <Widget>[
                    Icon(Icons.link),
                    Text('  Enter URL',
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ]),
                ),
              ],
            );
          })) {
        case Action.qrcode:
          var projectUrl = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => QrScanner()));
          if (projectUrl != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddProjectFormScreen(initalProjectUrl: projectUrl),
              ),
            );
          }
          break;
        case Action.form:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddProjectFormScreen(initalProjectUrl: null)));
          break;
      }
    }

    Stream<List<Project>> _projects = _database.projectDao.watchAllProjects();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Projects',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addProjectOption();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder(
                    stream: _projects,
                    builder: (_, AsyncSnapshot<List<Project>> snapshot) {
                      return Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: snapshot.data.isEmpty
                              ? Center(child: Text('No projects yet'))
                              : ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return ProjectCard(
                                      project: snapshot.data[index],
                                    );
                                  }),
                        ),
                      );
                    })
              ]),
        ),
      ),
    );
  }
}
