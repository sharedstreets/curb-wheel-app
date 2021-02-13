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

class StreetSelectMapScreenArguments {
  final db.Project project;
  StreetSelectMapScreenArguments(this.project);
}

class StreetSelectMapScreen extends StatefulWidget {
  static const routeName = '/map';

  final db.Project project;

  StreetSelectMapScreen({Key key, this.project}) : super(key: key);

  @override
  _StreetSelectMapScreenState createState() =>
      _StreetSelectMapScreenState(project);
}

class _StreetSelectMapScreenState extends State<StreetSelectMapScreen> {
  final db.Project project;

  _StreetSelectMapScreenState(this.project);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Select street",
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

  List<_Line> _basemapLines = new List();
  List<_Line> _selectionLines = new List();
  List<_Line> _surveyedLines = new List();
  List<_Symbol> _selectionSymbols = [];

  Map<String, int> _surveyedStreets;

  _Line _surveyedSelectedStreet;

  _FullMapState(this.project);
  Street _selectedStreet;

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

    List<db.Survey> surveys = await _database.surveyDao.getAllSurveys();

    _surveyedStreets = Map();
    for (db.Survey s in surveys) {
      _surveyedStreets.putIfAbsent(s.shStRefId, () {
        return 0;
      });
      _surveyedStreets[s.shStRefId] += 1;
    }
  }

  _redrawMap() {
    _mapController.clearLines();
    for (_Line l in _basemapLines) {
      _mapController.addLine(l.options, l.data);
    }
    for (_Line l in _surveyedLines) {
      _mapController.addLine(l.options, l.data);
    }
    for (_Line l in _selectionLines) {
      _mapController.addLine(l.options, l.data);
    }

    _mapController.clearSymbols();
    for (_Symbol s in _selectionSymbols) {
      _mapController.addSymbol(s.options, s.data);
    }
  }

  _onToggleDirection() {
    if (_selectedStreet != null) {
      _selectStreet(
          _selectedStreet.shstGeomId,
          _selectedStreet.sideOfStreet,
          _selectedStreet.directionOfTravel == DirectionOfTravel.Forward
              ? DirectionOfTravel.Backward
              : DirectionOfTravel.Forward);
    }
  }

  _onToggleSide() {
    if (_selectedStreet != null) {
      _selectStreet(
          _selectedStreet.shstGeomId,
          _selectedStreet.sideOfStreet == SideOfStreet.Right
              ? SideOfStreet.Left
              : SideOfStreet.Right,
          _selectedStreet.directionOfTravel);
    }
  }

  void _onLineTapped(Line tappedLine) async {
    _selectStreet(
        tappedLine.data['id'], SideOfStreet.Right, DirectionOfTravel.Forward);
  }

  void _selectStreet(String geomId, SideOfStreet sideOfStreet,
      DirectionOfTravel direction) async {
    var data = await _projectMapData.mapData;
    Feature<LineString> f = data.geomIndex[geomId];
    String streetName = f.properties['name'];
    if (streetName == null || streetName == "") streetName = "Unamed Street";

    String fromId = direction == DirectionOfTravel.Forward
        ? f.properties['fromIntersectionId']
        : f.properties['toIntersectionId'];
    String toId = direction == DirectionOfTravel.Forward
        ? f.properties['toIntersectionId']
        : f.properties['fromIntersectionId'];
    String refId = direction == DirectionOfTravel.Forward
        ? f.properties['forwardReferenceId']
        : f.properties['backReferenceId'];
    num refLength = f.properties['distance'];

    List<String> fromStreets = data.getStreetsByIntersection(fromId);
    List<String> toStreets = data.getStreetsByIntersection(toId);

    String fromStreetName = "Unamed Street";
    for (String newStreet in fromStreets) {
      if (streetName.toLowerCase() != newStreet.toLowerCase()) {
        if (fromStreetName == "Unamed Street") {
          fromStreetName = newStreet;
        }
      }
    }

    String toStreetName = "Unamed Street";
    for (String newStreet in toStreets) {
      if (streetName.toLowerCase() != newStreet.toLowerCase()) {
        if (toStreetName == "Unamed Street") {
          toStreetName = newStreet;
        }
      }
    }

    Street selectedStreet = Street(geomId, refId, refLength, streetName,
        fromStreetName, toStreetName, sideOfStreet, direction);

    // clone and reverse objects
    List<Position> geomCoords;
    if (direction == DirectionOfTravel.Forward)
      geomCoords = f.geometry.coordinates;
    else
      geomCoords =
          List<Position>.from(f.geometry.coordinates).reversed.toList();

    Feature<LineString> visualizationFeature =
        Feature<LineString>(geometry: LineString(coordinates: geomCoords));

    List<LatLng> mapboxGeom = await getMapboxGLGeom(visualizationFeature);

    double sideOfStreetStreetOffset = 4;
    if (sideOfStreet == SideOfStreet.Left &&
        direction == DirectionOfTravel.Forward)
      sideOfStreetStreetOffset = -4;
    else if (sideOfStreet == SideOfStreet.Left &&
        direction == DirectionOfTravel.Backward) sideOfStreetStreetOffset = -4;

    _selectionLines = new List();
    _Line l = new _Line();
    l.options = new LineOptions(
      geometry: mapboxGeom,
      lineColor: "#667ad2",
      lineWidth: 4.0,
      lineOffset: sideOfStreetStreetOffset,
      lineOpacity: 1.0,
    );
    l.data = {"id": f.properties['id']};
    _selectionLines.add(l);

    Point p = along(visualizationFeature, 20);
    double b = bearing(Point(coordinates: geomCoords[0]), p);
    LatLng latLng = new LatLng(p.coordinates.lat, p.coordinates.lng);

    double sideOfStreetSymbolOffset = 0.25;
    if (sideOfStreet == SideOfStreet.Left &&
        direction == DirectionOfTravel.Forward)
      sideOfStreetSymbolOffset = -1.75;
    else if (sideOfStreet == SideOfStreet.Right &&
        direction == DirectionOfTravel.Backward)
      sideOfStreetSymbolOffset = -1.75;

    double rotationOffset = b - 90;
    double paddingOffset = 2;
    String arrows = ">>>";
    if (rotationOffset > 90) {
      arrows = "<<<";
      rotationOffset = rotationOffset - 180;
      paddingOffset = -2;
    }

    _selectionSymbols = List();
    _Symbol s = new _Symbol();
    s.options = new SymbolOptions(
      geometry: latLng,
      textField: arrows + ' ' + streetName + ' ' + arrows,
      textRotate: rotationOffset,
      textSize: 14,
      textMaxWidth: 30,
      textOffset: Offset(paddingOffset, sideOfStreetSymbolOffset),
      textAnchor: 'top',
      textColor: '#667ad2',
      textHaloBlur: 1,
      textHaloColor: '#ffffff',
      textHaloWidth: 0.8,
    );
    s.data = {"id": f.properties['id']};

    _selectionSymbols.add(s);

    // if (_surveyedSelectedStreet != null) {
    //   _surveyedLines.add(_surveyedSelectedStreet);
    // }

    // _surveyedSelectedStreet = null;

    _redrawMap();

    setState(() {
      _selectedStreet = selectedStreet;
    });
  }

  void _onMapChanged() async {
    MapData data = await _projectMapData.mapData;

    // not performant on a iphone 6s below z15
    // suggests importance of switching to geojson overlay
    if (_mapController.isCameraMoving == false &&
        _mapController.cameraPosition.zoom > 15.5) {
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

      // ick is this the rigfh way to handle async object initialization?
      List<Feature<LineString>> features = data.getGeomsByBounds(bounds);

      _basemapLines = new List();
      _surveyedLines = new List();
      for (Feature<LineString> f in features) {
        List<LatLng> mapboxGeom =
            await data.getMapboxGLGeomById(f.properties['id']);

        _Line l = new _Line();
        l.options = new LineOptions(
          geometry: mapboxGeom,
          lineColor: "#000000",
          lineWidth: 6.0,
          lineOpacity: 0.0,
        );

        l.data = {"id": f.properties['id']};
        _basemapLines.add(l);

        if (_surveyedStreets.containsKey(f.properties['forwardReferenceId'])) {
          _Line l = new _Line();
          l.options = new LineOptions(
            geometry: mapboxGeom,
            lineColor: "#ff0000",
            lineWidth: 4.0,
            lineOffset: 4,
            lineOpacity: 0.5,
          );
          l.data = {"id": f.properties['id']};
          _surveyedLines.add(l);

          // if (_selectedStreet != null &&
          //     _selectedStreet.shStRefId != f.properties['id'])
          //
          // else
          //   _surveyedSelectedStreet = l;
        }

        if (_surveyedStreets.containsKey(f.properties['bakcReferenceId'])) {
          _Line l = new _Line();
          l.options = new LineOptions(
            geometry: mapboxGeom,
            lineColor: "#ff0000",
            lineWidth: 4.0,
            lineOffset: 4,
            lineOpacity: 0.5,
          );
          l.data = {"id": f.properties['id']};
          _surveyedLines.add(l);

          // if (_selectedStreet != null &&
          //     _selectedStreet.shStRefId != f.properties['id'])
          //
          // else
          //   _surveyedSelectedStreet = l;
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
      _mapController.onLineTapped.add(_onLineTapped);
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
      SelectStreetHeader(project, _zoomInToTap, _selectedStreet,
          _onToggleDirection, _onToggleSide),
      Expanded(child: _map),
    ]));
  }
}

class SelectStreetHeader extends StatefulWidget {
  final db.Project project;
  final Street street;
  final Function toggleSideCallback;
  final Function toggleDirectionCallback;
  final bool zoomInToTap;

  SelectStreetHeader(this.project, this.zoomInToTap, this.street,
      this.toggleDirectionCallback, this.toggleSideCallback);

  @override
  _SelectStreetHeader createState() => _SelectStreetHeader();
}

class _SelectStreetHeader extends State<SelectStreetHeader> {
  @override
  Widget build(BuildContext context) {
    WheelCounter _counter = Provider.of<WheelCounter>(context);
    db.CurbWheelDatabase _database = Provider.of<db.CurbWheelDatabase>(context);
    SurveyDao surveyDao = _database.surveyDao;

    var _street = widget.street;
    var _project = widget.project;

    String streetName = _street != null
        ? _street.streetName
        : widget.zoomInToTap == null || widget.zoomInToTap == true
            ? "Zoom in to select street"
            : "Select a street";

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
                              length: moor.Value(_street.length),
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
            _street != null
                ? Center(
                    child: Row(children: [
                    IconTextButton(
                        label: "Toggle Side",
                        icon: Icons.swap_horiz,
                        callback: widget.toggleSideCallback),
                    IconTextButton(
                        label: "Toggle Direction",
                        icon: Icons.swap_vert,
                        callback: widget.toggleDirectionCallback),
                  ]))
                : SizedBox.shrink()
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
