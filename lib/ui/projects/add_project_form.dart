import 'package:curbwheel/client/config_client.dart';
import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/utils/write_file.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart' as moor;
import 'package:provider/provider.dart';

class AddProjectFormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddProjectFormScreenState();
}

class _AddProjectFormScreenState extends State<AddProjectFormScreen> {
  CurbWheelDatabase _database;
  final textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_database = Provider.of<CurbWheelDatabase>(context);
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }
  /*
  _fetchAndAdd(String url) async {
    final config = await ConfigClient().getConfig(url);
    final mapData = await ConfigClient().getConfig(config.mapData);
    print(config.projectId);
    final _project = ProjectsCompanion(
        projectId: moor.Value(config.projectId),
        name: moor.Value(config.projectName),
        email: moor.Value(config.email),
        organization: moor.Value(config.organization));
    await _database.projectDao.insertProject(_project);
    await FileWriter().writeFile(config.projectId, mapData.toString());
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: Text(
          'Projects',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:
        Column(
      children: <Widget>[
        Center(child:         TextFormField(
          controller: textFieldController,
          decoration: InputDecoration(labelText: 'configuration URL'),
        ),),


        TextButton(
          
          child: Text("Download"),
          onPressed: () => print(textFieldController.value.text)
        )
        
      ],
    ));
  }
}
