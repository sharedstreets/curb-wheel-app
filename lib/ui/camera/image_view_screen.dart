import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewScreenArguments {
  final String filePath;

  ImageViewScreenArguments(this.filePath);
}

class ImageViewScreen extends StatelessWidget {
  static const routeName = '/image-view';

  @override
  Widget build(BuildContext context) {
    final ImageViewScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    final String filePath = args.filePath;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Image.file(
                  File(filePath),
                  fit: BoxFit.cover,
                ),
              ),
            ]),
      ),
    );
  }
}
