import 'dart:io';

import '../database/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  CurbWheelDatabase _database;

  @override
  Widget build(BuildContext context) {
    _database = Provider.of<CurbWheelDatabase>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Photos")),
      body: StreamBuilder(
        stream: _database.photoDao.watchAllPhotos(),
        builder: (context, AsyncSnapshot<List<Photo>> snapshot) {
          return Column(
            children: <Widget>[
              Expanded(
                  child: GridView.builder(
                      itemCount: snapshot.data.length,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return new GestureDetector(
                          child: new Card(
                            elevation: 5.0,
                            child: Image.file(
                              File(snapshot.data[index].file),
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      })),
            ],
          );
        },
      ),
    );
  }
}
