import 'package:curbwheel/client/config_client.dart';
import 'package:curbwheel/ui/projects/add_project_form.dart';
import 'package:curbwheel/utils/write_file.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;

import '../../database/database.dart';
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
                  child: const Text('Scan QR Code'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, Action.form);
                  },
                  child: const Text('Manually add'),
                ),
              ],
            );
          })) {
        case Action.qrcode:
          // Let's go.
          // ...
          break;
        case Action.form:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddProjectFormScreen()));
          break;
      }
    }

    Stream<List<Project>> _projects = _database.projectDao.watchAllProjects();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Projects',
          style: TextStyle(color: Colors.white),
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
          padding: EdgeInsets.all(40.0),
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
