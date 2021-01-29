import 'dart:convert';
import 'dart:math';

import 'package:curbwheel/database/database.dart' as db;
import 'package:curbwheel/utils/file_utils.dart';
import 'package:curbwheel/utils/spatial_utils.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:r_tree/r_tree.dart';
import 'package:turf/helpers.dart';

class ProjectMapDatastores {
  Map<String, ProjectMapDatastore> _datastores = Map();

  getDatastore(db.Project p) {
    _datastores.putIfAbsent(p.projectId, () {
      return new ProjectMapDatastore(p);
    });

    return _datastores[p.projectId];
  }
}

class ProjectMapDatastore {
  final db.Project _project;
  MapData _mapData;

  ProjectMapDatastore(this._project);

  get mapData async {
    if (_mapData == null) {
      String mapDataString =
          await FileUtils.readFile(_project.projectId, 'map.json');
      Map<String, dynamic> mapDataJson = jsonDecode(mapDataString);
      _mapData = MapData.fromJson(mapDataJson);
    }
    return _mapData;
  }
}

class MapData {
  final FeatureCollection<Geometry> _featureCollection;

  Map<String, Feature> _geomIndex;
  Map<String, String> _refIndex;

  RTree<Feature<Geometry>> _spatialIndex;

  MapData(this._featureCollection);

  MapData.fromJson(Map<String, dynamic> json)
      : _featureCollection = FeatureCollection.fromJson(json);

  FeatureCollection<Geometry> get featureCollection => _featureCollection;

  Map<String, String> get refIndex {
    _refIndex = new Map();

    for (Feature feature in _featureCollection.features) {
      _refIndex.putIfAbsent(
          feature.properties['forwardRefId'], () => feature.properties['id']);
      _refIndex.putIfAbsent(
          feature.properties['backwardRefId'], () => feature.properties['id']);
    }
  }

  Map<String, Feature> get geomIndex {
    if (_geomIndex == null) {
      _geomIndex = new Map();

      for (Feature feature in _featureCollection.features) {
        _geomIndex.putIfAbsent(feature.properties['id'], () => feature);
      }
    }
    return _geomIndex;
  }

  RTree<Feature<Geometry>> get spatialIndex {
    if (_spatialIndex == null) {
      _spatialIndex = new RTree();

      for (Feature feature in _featureCollection.features) {
        Rectangle rect = bboxToRectangle(bbox(feature));
        _spatialIndex.insert(new RTreeDatum(rect, feature));
      }
    }
    return _spatialIndex;
  }

  List<Feature<Geometry>> getGeomsByBounds(LatLngBounds bounds) {
    Rectangle r = boundsToRectangle(bounds);
    return spatialIndex.search(r).map((i) {
      return i.value;
    }).toList();
  }

  Future<List<LatLng>> getMapboxGLGeomById(String id) async {
    Feature f = this.geomIndex[id];
    if (f.properties['mapboxgl_latlngs'] == null) {
      List<LatLng> latLngs = new List();
      await coordEach(f,
          (coord, coordIndex, featureIndex, multiFeatureIndex, geometryIndex) {
        latLngs.add(new LatLng(coord[1], coord[0]));
      }, false);
      f.properties['mapboxgl_latlngs'] = latLngs;
    }
    return f.properties['mapboxgl_latlngs'];
  }

  getGeomById(String refId) {}

  getGeomRefById(String refId) {}
}
