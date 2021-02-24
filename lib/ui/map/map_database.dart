import 'dart:convert';
import 'dart:math';

import 'package:curbwheel/database/database.dart' as db;
import 'package:curbwheel/utils/file_utils.dart';
import 'package:curbwheel/utils/spatial_utils.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:r_tree/r_tree.dart';
import 'package:turf/helpers.dart';
import 'package:synchronized/synchronized.dart';

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
  var _lock = new Lock();

  get mapData async {
    await _lock.synchronized(() async {
      if (_mapData == null) {
        String mapDataString =
            await FileUtils.readFile(_project.projectId, 'map.json');
        Map<String, dynamic> mapDataJson = jsonDecode(mapDataString);

        // ugh -- geoJSON parser is not typed need to manually implement types json factory to a typed list
        FeatureCollection fc =
            LineCollectionFeatureCollectionFromJson(mapDataJson);
        _mapData = MapData(fc);
      }
    });

    return _mapData;
  }
}

class MapData {
  final FeatureCollection<LineString> _featureCollection;

  Map<String, Feature<LineString>> _geomIndex;
  Map<String, String> _refIndex;
  Map<String, List<String>> _intersectionIndex;
  RTree<Feature<LineString>> _spatialIndex;

  MapData(this._featureCollection);

  FeatureCollection<LineString> get featureCollection => _featureCollection;

  Map<String, List<String>> get intersectionIndex {
    _intersectionIndex = new Map();

    for (Feature<LineString> feature in _featureCollection.features) {
      _intersectionIndex.putIfAbsent(
          feature.properties['toIntersectionId'], () => List<String>());
      _intersectionIndex.putIfAbsent(
          feature.properties['fromIntersectionId'], () => List<String>());

      _intersectionIndex[feature.properties['toIntersectionId']]
          .add(feature.properties['id']);
      _intersectionIndex[feature.properties['fromIntersectionId']]
          .add(feature.properties['id']);
    }
    return _intersectionIndex;
  }

  List<String> getStreetsByIntersection(String intersectionId) {
    List<String> streetIds = this.intersectionIndex[intersectionId];

    Set<String> normalizedNames = Set();
    Set<String> uniqueNames = Set();
    for (String streetId in streetIds) {
      String name = this.geomIndex[streetId].properties['name'];
      if (name != null && name != "") {
        String normalizedName = name.toLowerCase();
        if (!normalizedNames.contains(normalizedName)) {
          normalizedNames.add(normalizedName);
          uniqueNames.add(name);
        }
      }
    }

    return uniqueNames.toList();
  }

  Map<String, String> get refIndex {
    if (_refIndex == null) {
      _refIndex = new Map();

      for (Feature<LineString> feature in _featureCollection.features) {
        _refIndex.putIfAbsent(feature.properties['forwardReferenceId'],
            () => feature.properties['id']);
        _refIndex.putIfAbsent(feature.properties['backReferenceId'],
            () => feature.properties['id']);
      }
    }
    return _refIndex;
  }

  Map<String, Feature<LineString>> get geomIndex {
    if (_geomIndex == null) {
      _geomIndex = new Map();

      for (Feature<LineString> feature in _featureCollection.features) {
        _geomIndex.putIfAbsent(feature.properties['id'], () => feature);
      }
    }
    return _geomIndex;
  }

  Feature<LineString> getDirectionalGeomByRefId(String refId) {
    String geomId = refIndex[refId];
    if (geomIndex[geomId].properties['forwardReferenceId'] == refId)
      return this.geomIndex[geomId];
    else {
      List<Position> geomCoords =
          List<Position>.from(geomIndex[geomId].geometry.coordinates)
              .reversed
              .toList();

      Feature<LineString> reversedFeature = Feature<LineString>(
          properties: geomIndex[geomId].properties,
          geometry: LineString(
            coordinates: geomCoords,
          ));

      return reversedFeature;
    }
  }

  RTree<Feature<LineString>> get spatialIndex {
    if (_spatialIndex == null) {
      _spatialIndex = new RTree();

      for (Feature<LineString> feature in _featureCollection.features) {
        Rectangle rect = bboxToRectangle(bbox(feature));
        _spatialIndex.insert(new RTreeDatum(rect, feature));
      }
    }
    return _spatialIndex;
  }

  List<Feature<LineString>> getGeomsByBounds(LatLngBounds bounds) {
    Rectangle r = boundsToRectangle(bounds);
    return spatialIndex.search(r).map((i) {
      return i.value;
    }).toList();
  }

  Future<List<LatLng>> getMapboxGLGeomById(String id) async {
    Feature<LineString> f = this.geomIndex[id];
    if (f.properties['mapboxgl_latlngs'] == null) {
      List<LatLng> latLngs = await getMapboxGLGeom(f);
      f.properties['mapboxgl_latlngs'] = latLngs;
    }
    return f.properties['mapboxgl_latlngs'];
  }

  getGeomById(String refId) {}

  getGeomRefById(String refId) {}
}
