import 'dart:convert';

import 'package:curbwheel/utils/spatial_utils.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:turf/turf.dart';

import '../../database/database.dart' as db;
import 'map_database.dart';

const String ACCESS_TOKEN =
    "pk.eyJ1IjoidHJhbnNwb3J0cGFydG5lcnNoaXAiLCJhIjoiY2trZTN1b3NlMDN3aTJvbzFhdW1uZGExcCJ9.S0gouMnBt_Ynv0GnmOQzeA";

const String STYLE_STRING =
    "mapbox://styles/transportpartnership/ckke3y9ts0wbn17mk62j9vt4a";

class MapScreenArguments {
  final db.Project project;
  MapScreenArguments(this.project);
}

class MapScreen extends StatefulWidget {
  static const routeName = '/map';

  final db.Project project;

  MapScreen({Key key, this.project}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState(project);
}

class _MapScreenState extends State<MapScreen> {
  final db.Project project;

  _MapScreenState(this.project);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(""
                //widget.project.name,
                )),
        body: FullMap(project));
  }
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

  LatLngBounds _lastBounds;

  final db.Project project;

  _FullMapState(this.project);
  String _fromStreetName;
  String _toStreetName;

  String _streetName;
  String _geomId;
  String _refId;
  String _sideOfStreet = "right";

  bool _zoomInToTap = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _projectMapData = Provider.of<ProjectMapDatastores>(context, listen: false)
        .getDatastore(project);
  }

  void _onLineTapped(Line tappedLine) async {
    var data = await _projectMapData.mapData;
    var f = data.geomIndex[tappedLine.data["id"]];
    print("FEATURE");
    print(f);
    print("TAPPED");
    print(tappedLine.data);

    String streetName = f.properties['name'];

    List<String> fromStreets =
        data.getStreetsByIntersection(f.properties['fromIntersectionId']);
    List<String> toStreets =
        data.getStreetsByIntersection(f.properties['toIntersectionId']);

    String fromStreetName;
    for (String newStreet in fromStreets) {
      if (streetName.toLowerCase() != newStreet.toLowerCase()) {
        if (fromStreetName == null) {
          fromStreetName = newStreet;
        }
      }
    }

    String toStreetName;
    for (String newStreet in toStreets) {
      if (streetName.toLowerCase() != newStreet.toLowerCase()) {
        if (toStreetName == null) {
          toStreetName = newStreet;
        }
      }
    }

    setState(() {
      _streetName = streetName;
      _fromStreetName = fromStreetName;
      _toStreetName = toStreetName;
      _geomId = f.properties['id'];
      _refId = f.properties['forwardReferenceId'];
    });

    //lineOffset(f, 10)
    // var offsetLine = lineSliceAlong(f, 20, 30);

    List<LatLng> mapboxGeom = await getMapboxGLGeom(f);

    _mapController.addLine(
        new LineOptions(
          geometry: mapboxGeom,
          lineColor: "#0000ff",
          lineWidth: 6.0,
          lineOpacity: 0.1,
        ),
        {"id": f.properties['id']});

    Point p = along(f, 20);

    double b = bearing(Point(coordinates: f.geometry.coordinates[0]), p);

    LatLng latLng = new LatLng(p.coordinates.lat, p.coordinates.lng);

    _mapController.clearSymbols();
    _mapController.addSymbol(
        new SymbolOptions(
          geometry: latLng,
          textField: '➤➤➤',
          textRotate: b - 90 - _mapController.cameraPosition.bearing,
          textSize: 16,
          textOffset: Offset(0, 0.25),
          textAnchor: 'top',
          textColor: '#0000ff',
          textHaloBlur: 1,
          textHaloColor: '#ffffff',
          textHaloWidth: 0.8,
        ),
        {"id": f.properties['id']});
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
      List<Feature<Geometry>> features = data.getGeomsByBounds(bounds);

      _mapController.onLineTapped.add((Line l) {
        print(l);
      });

      _mapController.clearLines();
      for (Feature<Geometry> f in features) {
        List<LatLng> mapboxGeom =
            await data.getMapboxGLGeomById(f.properties['id']);
        Future<Line> l = _mapController.addLine(
            new LineOptions(
              geometry: mapboxGeom,
              lineColor: "#000000",
              lineWidth: 6.0,
              lineOpacity: 0.0,
            ),
            {"id": f.properties['id']});
      }
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
        onMapCreated: _onMapCreated,
        trackCameraPosition: true,
        initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
      );
    var _fromText = _fromStreetName != null ? TextSpan(text: "from ") : TextSpan(text: "");
    var fromStreetName = _fromStreetName != null
        ? TextSpan(text: _fromStreetName, style: TextStyle(fontWeight: FontWeight.bold))
        : TextSpan(text: "");
    var _toText = _toStreetName != null ? TextSpan(text: " to ") : TextSpan(text:"");
    var toStreetName = _toStreetName != null
        ? TextSpan(text: _toStreetName, style: TextStyle(fontWeight: FontWeight.bold))
        : TextSpan(text: "");
    var _crossStreetText = RichText(
      text: TextSpan(
        text: '',
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          _fromText,
          fromStreetName,
          _toText,
          toStreetName
        ],
      ),
    );
    return new Scaffold(
        body: Column(children: [
      ExpansionTile(
        initiallyExpanded:
            _fromStreetName != null || _toStreetName != null ? true : false,
        title: Text(
          _streetName != null
              ? _streetName
              : _zoomInToTap
                  ? "Zoom in to select street"
                  : "Select a street",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),

          // put button here for firing survey here should call
          // _onStreetSelected() to start survey
          //
          //
        ),
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 10, 10),
                  child: Row(children: [Flexible(child: _crossStreetText)])))
        ],
      ),
      Expanded(child: _map),
    ]));
  }
}

class Street {
  final String shStRefId;
  final String name;
  final String side;

  Street(this.shStRefId, this.name, this.side);
}
