import 'package:curbwheel/database/database.dart' as db;
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:curbwheel/database/survey_dao.dart';
import 'package:curbwheel/service/bluetooth_service.dart';
import 'package:curbwheel/ui/wheel/wheel_screen.dart';
import 'package:curbwheel/utils/spatial_utils.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:turf/turf.dart';
import 'package:uuid/uuid.dart';
import 'map_database.dart';

const String ACCESS_TOKEN =
    "pk.eyJ1IjoidHJhbnNwb3J0cGFydG5lcnNoaXAiLCJhIjoiY2trZTN1b3NlMDN3aTJvbzFhdW1uZGExcCJ9.S0gouMnBt_Ynv0GnmOQzeA";

const String STYLE_STRING =
    "mapbox://styles/transportpartnership/ckke3y9ts0wbn17mk62j9vt4a";

var uuid = Uuid();

class StreetReviewMapScreenArguments {
  final db.Project project;
  StreetReviewMapScreenArguments(this.project);
}

class StreetReviewMapScreen extends StatefulWidget {
  static const routeName = '/map/review';

  final db.Project project;

  StreetReviewMapScreen({Key key, this.project}) : super(key: key);

  @override
  _StreetReviewMapScreenState createState() =>
      _StreetReviewMapScreenState(project);
}

class _StreetReviewMapScreenState extends State<StreetReviewMapScreen> {
  final db.Project project;

  _StreetReviewMapScreenState(this.project);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Review surveys",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white))),
        body: FullMap(project));
  }
}

class _Line {
  LineOptions options;
  Map<String, dynamic> data;
}

class _Symbol {
  SymbolOptions options;
  Map<String, dynamic> data;
}

enum SideOfStreet { Right, Left }

enum DirectionOfTravel { Forward, Backward }

class Street {
  final String shstGeomId;
  final String shStRefId;
  final num length;
  final String streetName;
  final String fromStreetName;
  final String toStreetName;
  final SideOfStreet sideOfStreet;
  final DirectionOfTravel directionOfTravel;

  Street(
      this.shstGeomId,
      this.shStRefId,
      this.length,
      this.streetName,
      this.fromStreetName,
      this.toStreetName,
      this.sideOfStreet,
      this.directionOfTravel);
}

class FullMap extends StatefulWidget {
  final db.Project project;

  const FullMap(this.project);

  @override
  State createState() => _FullMapState(project);
}

class _FullMapState extends State<FullMap> {
  MapboxMapController _mapController;
  MapboxMap _map;
  ProjectMapDatastore _projectMapData;
  db.CurbWheelDatabase _database;

  LatLngBounds _lastBounds;

  final db.Project project;

  List<_Line> _surveyedLines = new List();
  Map<String, List<db.Survey>> _surveyedStreets;

  _FullMapState(this.project);

  bool _zoomInToTap = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSurveyedLines(context);
    });
    _projectMapData = Provider.of<ProjectMapDatastores>(context, listen: false)
        .getDatastore(project);
  }

  _loadSurveyedLines(context) async {
    print("test");

    List<db.Survey> surveys =
        await _database.surveyDao.getAllSurveysByProjectId(project.id);

    _surveyedStreets = Map();
    for (db.Survey s in surveys) {
      _surveyedStreets.putIfAbsent(s.shStRefId, () {
        return List();
      });
      _surveyedStreets[s.shStRefId].add(s);
    }
  }

  _redrawMap() {
    for (_Line l in _surveyedLines) {
      _mapController.addLine(l.options, l.data);
    }
  }

  void _onMapChanged() async {
    MapData data = await _projectMapData.mapData;

    // not performant on a iphone 6s below z15
    // suggests importance of switching to geojson overlay
    if (_mapController.isCameraMoving == false &&
        _mapController.cameraPosition.zoom > 12) {
      setState(() {
        _zoomInToTap = false;
      });
      LatLngBounds bounds = await _mapController.getVisibleRegion();

      // TOOD need to filter filter for box contains?
      if (_lastBounds != null) {
        if (contains(_lastBounds, bounds.northeast) &&
            contains(_lastBounds, bounds.southwest)) return;
      }

      _lastBounds = bounds;

      List<Feature<LineString>> features = data.getGeomsByBounds(bounds);

      _surveyedLines = new List();
      for (Feature<LineString> f in features) {
        List<LatLng> mapboxGeom =
            await data.getMapboxGLGeomById(f.properties['id']);

        if (_surveyedStreets.containsKey(f.properties['forwardReferenceId'])) {
          for (db.Survey s
              in _surveyedStreets[f.properties['forwardReferenceId']]) {
            double offset = 4;
            _Line l = new _Line();
            if (s.side == SideOfStreet.Left.toString()) offset = -4;
            l.options = new LineOptions(
              geometry: mapboxGeom,
              lineColor: "#ff0000",
              lineWidth: 4.0,
              lineOffset: offset,
              lineOpacity: 0.5,
            );
            l.data = {"id": f.properties['id']};
            _surveyedLines.add(l);
          }
        }

        if (_surveyedStreets.containsKey(f.properties['bakcReferenceId'])) {
          for (db.Survey s
              in _surveyedStreets[f.properties['forwardReferenceId']]) {
            double offset = -4;
            _Line l = new _Line();
            if (s.side == SideOfStreet.Left.toString()) offset = 4;
            l.options = new LineOptions(
              geometry: mapboxGeom,
              lineColor: "#ff0000",
              lineWidth: 4.0,
              lineOffset: offset,
              lineOpacity: 0.5,
            );
            l.data = {"id": f.properties['id']};
            _surveyedLines.add(l);
          }
        }
      }

      _redrawMap();
    }
  }

  void _onMapCreated(MapboxMapController controller) async {
    _mapController = controller;
    // update map to user location if permissions allow
    final location = Location();
    final hasPermissions = await location.hasPermission();
    if (hasPermissions == PermissionStatus.granted) {
      LocationData locationData = await location.getLocation();
      LatLng newLatLng =
          new LatLng(locationData.latitude, locationData.longitude);
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(newLatLng, 12);
      _mapController.moveCamera(cameraUpdate);
      _mapController.addListener(_onMapChanged);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_map == null)
      _map = MapboxMap(
        accessToken: ACCESS_TOKEN,
        styleString: STYLE_STRING,
        myLocationEnabled: true,
        myLocationTrackingMode: MyLocationTrackingMode.Tracking,
        compassEnabled: true,
        rotateGesturesEnabled: false,
        onMapCreated: _onMapCreated,
        trackCameraPosition: true,
        initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
      );

    _database = Provider.of<db.CurbWheelDatabase>(context);

    return new Scaffold(
        body: Column(children: [
      ReviewStreetHeader(project, _zoomInToTap, null),
      Expanded(child: _map),
    ]));
  }
}

class ReviewStreetHeader extends StatefulWidget {
  final db.Project project;
  final bool zoomInToTap;
  final Street street;

  ReviewStreetHeader(this.project, this.zoomInToTap, this.street);

  @override
  _ReviewStreetHeader createState() => _ReviewStreetHeader();
}

class _ReviewStreetHeader extends State<ReviewStreetHeader> {
  @override
  Widget build(BuildContext context) {
    WheelCounter _counter = Provider.of<WheelCounter>(context);
    db.CurbWheelDatabase _database = Provider.of<db.CurbWheelDatabase>(context);
    SurveyDao surveyDao = _database.surveyDao;

    var _project = widget.project;
    var _street = this.widget.street;

    String streetName = _street != null
        ? _street.streetName
        : widget.zoomInToTap == null || widget.zoomInToTap == true
            ? "Zoom in to select street"
            : "Zoom in to select a street";

    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '${streetName}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                _street != null
                    ? IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () async {
                          String surveyId = uuid.v4();
                          var surveysCompanion = db.SurveysCompanion(
                              id: moor.Value(surveyId),
                              shStRefId: moor.Value(_street.shStRefId),
                              streetName: moor.Value(_street.streetName),
                              mapLength: moor.Value(_street.length),
                              projectId: moor.Value(_project.id),
                              startStreetName:
                                  moor.Value(_street.fromStreetName),
                              endStreetName: moor.Value(_street.toStreetName),
                              direction: moor.Value(
                                  _street.directionOfTravel.toString()),
                              side:
                                  moor.Value(_street.sideOfStreet.toString()));
                          await surveyDao.insertSurvey(surveysCompanion);
                          db.Survey survey =
                              await surveyDao.getSurveyById(surveyId);
                          _counter.resetForwardCounter();
                          Navigator.pushNamed(context, WheelScreen.routeName,
                              arguments:
                                  WheelScreenArguments(_project, survey));
                        },
                      )
                    : SizedBox.shrink()
              ],
            ),
            _street != null
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: '',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: _street.sideOfStreet == SideOfStreet.Left
                                  ? "Left side"
                                  : "Right side",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: " between "),
                          TextSpan(
                              text: '${_street.fromStreetName}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ' and '),
                          TextSpan(
                              text: '${_street.toStreetName}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class IconTextButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Function callback;

  IconTextButton({Key key, this.label, this.icon, this.callback})
      : super(key: key);

  @override
  _IconTextButtonState createState() => _IconTextButtonState();
}

class _IconTextButtonState extends State<IconTextButton> {
  @override
  build(BuildContext context) {
    return FlatButton(
        onPressed: () async {
          this.widget.callback();
        },
        padding: EdgeInsets.all(10.0),
        child: Row(children: [Icon(widget.icon), Text(this.widget.label)]));
  }
}
