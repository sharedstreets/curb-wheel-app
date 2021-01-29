import 'package:curbwheel/utils/spatial_utils.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
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
  ProjectMapDatastore _mapData;
  final db.Project project;

  _FullMapState(this.project);

  void _onMapClick(point, latlng) async {
    LatLngBounds bounds = await _mapController.getVisibleRegion();

    // ick is this the rigfh way to handle async object initialization?
    List<Feature<Geometry>> features =
        (await _mapData.mapData).getGeomsByBounds(bounds);

    _mapController.clearLines();
    for (Feature f in features) {
      List<LatLng> mapboxGeom = await (await _mapData.mapData)
          .getMapboxGLGeomById(f.properties['id']);
      _mapController.addLine(new LineOptions(
        geometry: mapboxGeom,
        lineColor: "#ff0000",
        lineWidth: 14.0,
        lineOpacity: 0.5,
      ));
    }
  }

  void _onMapCreated(MapboxMapController controller) async {
    _mapData = new ProjectMapDatastore(project);
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
    }
    // _mapController.onLineTapped;
    // _mapController.addLine(new LineOptions(
    //   geometry: ,
    //   lineColor: "#ff0000",
    //   lineWidth: 14.0,
    //   lineOpacity: 0.5,
    // ));
  }

  @override
  Widget build(BuildContext context) {
    _map = MapboxMap(
      accessToken: ACCESS_TOKEN,
      styleString: STYLE_STRING,
      myLocationEnabled: true,
      myLocationTrackingMode: MyLocationTrackingMode.Tracking,
      compassEnabled: true,
      onMapCreated: _onMapCreated,
      onMapClick: _onMapClick,
      initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
    );

    return new Scaffold(body: _map);
  }
}
