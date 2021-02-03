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

class MapScreen extends StatefulWidget {
  final db.Project project;

  const MapScreen({Key key, this.project}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState(project);
}

class _MapScreenState extends State<MapScreen> {
  final db.Project project;

  _MapScreenState(this.project);

  @override
  Widget build(BuildContext context) {
    //_database = Provider.of<CurbWheelDatabase>(context);
    //Stream<List<Project>> _projects = _database.projectDao.watc();
    return Scaffold(
        appBar: AppBar(
            title: Text(
          widget.project.name,
          //style: TextStyle(color: Colors.white),
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

  String _streetName = "Select a street";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _projectMapData = Provider.of<ProjectMapDatastores>(context, listen: false)
        .getDatastore(project);
  }

  void _onLineTapped(Line tappedLine) async {
    var f = (await _projectMapData.mapData).geomIndex[tappedLine.data["id"]];
    setState(() {
      _streetName = f.properties['name'];
    });
  }

  void _onMapChanged() async {
    MapData data = await _projectMapData.mapData;

    // not preformant on a iphone 6s below z15
    // suggests importance of switching to geojson overlay
    if (_mapController.isCameraMoving == false &&
        _mapController.cameraPosition.zoom > 15.5) {
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
              lineWidth: 4.0,
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

    return new Scaffold(
        body: Column(children: [
      Expanded(child: _map),
      ExpansionTile(
        title: Text(
          _streetName,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
    ]));
  }
}
