import 'package:sentry_flutter/sentry_flutter.dart';

import 'preview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CameraScreenArguments {
  final String surveyItemId;
  final double position;
  final String pointId;

  CameraScreenArguments({this.surveyItemId, this.position, this.pointId});
}

class CameraScreen extends StatefulWidget {
  static const routeName = '/camera';

  final String surveyItemId;
  final double position;
  final String pointId;

  CameraScreen({this.surveyItemId, this.position, this.pointId});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController cameraController;
  List cameras;
  int selectedCameraIndex;
  String imgPath;
  double _position;
  String _pointId;
  bool awaitingCapture = false;

  Future initCamera(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController.dispose();
    }

    cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);

    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    if (cameraController.value.hasError) {
      print('Camera Error ${cameraController.value.errorDescription}');
    }

    try {
      await cameraController.initialize();
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget cameraWidget(context) {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return Text(
        AppLocalizations.of(context).loading,
        style: TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
      );
    }
    var camera = cameraController.value;
    final size = MediaQuery.of(context).size;

    var scale = size.aspectRatio * camera.aspectRatio;

    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(cameraController),
      ),
    );
  }

  /// Display camera preview
  Widget cameraPreview() {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return Text(
        AppLocalizations.of(context).loading,
        style: TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
      );
    }

    return AspectRatio(
      aspectRatio: cameraController.value.aspectRatio,
      child: CameraPreview(cameraController),
    );
  }

  Widget cameraControl(context) {
    return new Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: new FloatingActionButton(
        child: Icon(
          Icons.camera,
          size: 56.0,
          color: Color.fromRGBO(0, 0, 0, 0.6),
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.2),
        onPressed: awaitingCapture ? null : () => onCapture(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  onCapture(context) async {
    try {
      final p = await getTemporaryDirectory();
      final name = DateTime.now();
      final path = "${p.path}/$name.png";
      try {
        awaitingCapture = true;
        XFile img = await cameraController.takePicture();
        awaitingCapture = false;
        await img.saveTo(path);
        Navigator.pushNamed(context, PreviewScreen.routeName,
            arguments: PreviewScreenArguments(widget.surveyItemId, path,
                position: _position, pointId: _pointId));
      } catch (exception, stackTrace) {
        await Sentry.captureException(
          exception,
          stackTrace: stackTrace,
        );
      }
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    this._pointId = widget.pointId;
    this._position = widget.position;
    availableCameras().then((value) {
      cameras = value;
      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        initCamera(cameras[selectedCameraIndex]).then((value) {});
      } else {
        print('No camera available');
      }
    }).catchError((e) {
      print('Error : ${e.code}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: <Widget>[
            cameraWidget(context),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 120,
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    color: Colors.transparent,
                    child: cameraControl(context)))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();

    super.dispose();
  }
}

class PhotoContainer {
  final String pointId;
  final String filePath;

  PhotoContainer(this.pointId, this.filePath);
}
