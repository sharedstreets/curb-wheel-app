import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import '../../database/database.dart';

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
