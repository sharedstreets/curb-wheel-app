import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/ui/map/map_screen.dart';
import 'package:flutter/material.dart';

class WheelScreen extends StatelessWidget {
  final Project project;
  final Street street;

  WheelScreen(this.project, this.street);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Surveying"),
      ),
    );
  }
}
