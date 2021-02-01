import 'dart:math';

import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:turf/turf.dart';

const double INFINITY = 1.0 / 0.0;

// TODO convert turf methods to a pull request for package:turf/turf.dart

// converting from @turf/meta
// https://github.com/Turfjs/turf/blob/3cea4b5f125a11fb4757da59d1222fd837d9783c/packages/turf-meta/index.js
coordEach(geojson, callback, excludeWrapCoord) {
  // Handles null Geometry -- Skips this GeoJSON
  if (geojson == null) return;
  var j,
      k,
      l,
      geometry,
      stopG,
      coords,
      geometryMaybeCollection,
      wrapShrink = 0,
      coordIndex = 0,
      isGeometryCollection,
      type = geojson.type,
      isFeatureCollection = type == "FeatureCollection",
      isFeature = type == "Feature",
      stop = isFeatureCollection ? geojson.features.length : 1;

  // This logic may look a little weird. The reason why it is that way
  // is because it's trying to be fast. GeoJSON supports multiple kinds
  // of objects at its root: FeatureCollection, Features, Geometries.
  // This function has the responsibility of handling all of them, and that
  // means that some of the `for` loops you see below actually just don't apply
  // to certain inputs. For instance, if you give this just a
  // Point geometry, then both loops are short-circuited and all we do
  // is gradually rename the input until it's called 'geometry'.
  //
  // This also aims to allocate as few resources as possible: just a
  // few numbers and booleans, rather than any temporary arrays as would
  // be required with the normalization approach.
  for (var featureIndex = 0; featureIndex < stop; featureIndex++) {
    geometryMaybeCollection = isFeatureCollection
        ? geojson.features[featureIndex].geometry
        : isFeature
            ? geojson.geometry
            : geojson;
    isGeometryCollection = geometryMaybeCollection.type != null
        ? geometryMaybeCollection.type == "GeometryCollection"
        : false;
    stopG =
        isGeometryCollection ? geometryMaybeCollection.geometries.length : 1;

    for (var geomIndex = 0; geomIndex < stopG; geomIndex++) {
      var multiFeatureIndex = 0;
      var geometryIndex = 0;
      geometry = isGeometryCollection
          ? geometryMaybeCollection.geometries[geomIndex]
          : geometryMaybeCollection;

      // Handles null Geometry -- Skips this geometry
      if (geometry == null) continue;
      coords = geometry.coordinates;
      String geomType = geometry.type;

      wrapShrink = excludeWrapCoord &&
              (geomType == "Polygon" || geomType == "MultiPolygon")
          ? 1
          : 0;

      if (geomType != null) {
        switch (geomType) {
          case "Point":
            if (callback(coords, coordIndex, featureIndex, multiFeatureIndex,
                    geometryIndex) ==
                false) return false;
            coordIndex++;
            multiFeatureIndex++;
            break;
          case "LineString":
          case "MultiPoint":
            for (j = 0; j < coords.length; j++) {
              if (callback(coords[j], coordIndex, featureIndex,
                      multiFeatureIndex, geometryIndex) ==
                  false) return false;
              coordIndex++;
              if (geomType == "MultiPoint") multiFeatureIndex++;
            }
            if (geomType == "LineString") multiFeatureIndex++;
            break;
          case "Polygon":
          case "MultiLineString":
            for (j = 0; j < coords.length; j++) {
              for (k = 0; k < coords[j].length - wrapShrink; k++) {
                if (callback(coords[j][k], coordIndex, featureIndex,
                        multiFeatureIndex, geometryIndex) ==
                    false) return false;
                coordIndex++;
              }
              if (geomType == "MultiLineString") multiFeatureIndex++;
              if (geomType == "Polygon") geometryIndex++;
            }
            if (geomType == "Polygon") multiFeatureIndex++;
            break;
          case "MultiPolygon":
            for (j = 0; j < coords.length; j++) {
              geometryIndex = 0;
              for (k = 0; k < coords[j].length; k++) {
                for (l = 0; l < coords[j][k].length - wrapShrink; l++) {
                  if (callback(coords[j][k][l], coordIndex, featureIndex,
                          multiFeatureIndex, geometryIndex) ==
                      false) return false;
                  coordIndex++;
                }
                geometryIndex++;
              }
              multiFeatureIndex++;
            }
            break;
          case "GeometryCollection":
            for (j = 0; j < geometry.geometries.length; j++)
              if (coordEach(
                      geometry.geometries[j], callback, excludeWrapCoord) ==
                  false) return false;
            break;
          default:
            throw new Exception("Unknown Geometry Type");
        }
      }
    }
  }
}

contains(LatLngBounds lnglatBounds, LatLng lnglat) {
  bool containsLatitude = lnglatBounds.southwest.latitude <= lnglat.latitude &&
      lnglat.latitude <= lnglatBounds.northeast.latitude;
  bool containsLongitude =
      lnglatBounds.southwest.longitude <= lnglat.longitude &&
          lnglat.longitude <= lnglatBounds.northeast.longitude;
  if (lnglatBounds.southwest.longitude > lnglatBounds.northeast.longitude) {
    // wrapped coordinates
    containsLongitude = lnglatBounds.southwest.longitude >= lnglat.longitude &&
        lnglat.longitude >= lnglatBounds.northeast.longitude;
  }

  return containsLatitude && containsLongitude;
}

// converting from @turf/bbox
// https://github.com/Turfjs/turf/blob/2e9d3d51f765a814c2cad90e88ff86e27c9e066f/packages/turf-bbox/index.ts
// modified to support 3d bbox lng1,lat1,alt1,lng2,lat2,alt2
//
bbox(Feature feature) {
  BBox result = BBox(INFINITY, INFINITY, -INFINITY, -INFINITY);
  coordEach(feature,
      (coord, coordIndex, featureIndex, multiFeatureIndex, geometryIndex) {
    if (result[0] > coord[0]) {
      result[0] = coord[0];
    }
    if (result[1] > coord[1]) {
      result[1] = coord[1];
    }
    if (result[3] < coord[0]) {
      result[3] = coord[0];
    }
    if (result[4] < coord[1]) {
      result[4] = coord[1];
    }
  }, false);
  return result;
}

boundsToRectangle(LatLngBounds bounds) {
  return new Rectangle(
      bounds.southwest.latitude,
      bounds.southwest.longitude,
      bounds.northeast.latitude - bounds.southwest.latitude,
      bounds.northeast.longitude - bounds.southwest.longitude);
}

bboxToRectangle(BBox bbox) {
  return new Rectangle(
      bbox.lat1, bbox.lng1, bbox.lat2 - bbox.lat1, bbox.lng2 - bbox.lng1);
}
