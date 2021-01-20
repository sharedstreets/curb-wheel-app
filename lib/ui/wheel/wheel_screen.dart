import 'package:curbwheel/database/database.dart';
import 'package:curbwheel/ui/features/features_screen.dart';
import 'package:curbwheel/ui/map/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WheelScreen extends StatefulWidget {
  final Project project;
  final Street street;

  WheelScreen(this.project, this.street);

  @override
  _WheelScreenState createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  CurbWheelDatabase _database;
  List<Span> incompleteSpans;
  List<Span> completeSpans;

  @override
  Widget build(BuildContext context) {

    _database = Provider.of<CurbWheelDatabase>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Surveying"),
      ),
      body: Container(
        color: Color(0xFFEFEFEF),
        child: Column(
          children: [
            WheelHeader(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FeatureSelectScreen(widget.project, widget.street, 0.0, [])))
        },
      ),
    );
  }
}

class WheelHeader extends StatefulWidget {
  @override
  _WheelHeaderState createState() => _WheelHeaderState();
}

class _WheelHeaderState extends State<WheelHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Street name"),
                IconButton(icon: Icon(Icons.check), onPressed: null)
              ],
            ),
            Row(
              children: [
                Text("Between X and Y"),
              ],
            )
          ],
        )
      );
  }
}

class SpanList extends StatefulWidget {
  @override
  _SpanListState createState() => _SpanListState();
}

class _SpanListState extends State<SpanList> {
  List<Span> spans;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: spans.length,
        itemBuilder: (context, index) {
          var span = spans[index];
          return Card(child: Text(span.name));
        });
  }
}

class SpanCard extends StatefulWidget {
  @override
  _SpanCardState createState() => _SpanCardState();
}

class _SpanCardState extends State<SpanCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
        children: [
          Row(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: Icon(Icons.more_horiz), onPressed: null),
              IconButton(icon: Icon(Icons.camera_alt), onPressed: null),
            ],
          )
        ],
      )
    );
  }
}
