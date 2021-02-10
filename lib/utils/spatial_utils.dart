import 'dart:ffi';
import 'dart:math';

import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:turf/turf.dart' as turf;

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

// /**
//  * Get Geometry from Feature or Geometry Object
//  *
//  * @param {Feature|Geometry} geojson GeoJSON Feature or Geometry Object
//  * @returns {Geometry|null} GeoJSON Geometry Object
//  * @throws {Error} if geojson is not a Feature or Geometry Object
//  * @example
//  * var point = {
//  *   "type": "Feature",
//  *   "properties": {},
//  *   "geometry": {
//  *     "type": "Point",
//  *     "coordinates": [110, 40]
//  *   }
//  * }
//  * var geom = turf.getGeom(point)
//  * //={"type": "Point", "coordinates": [110, 40]}
//  */
getGeom(geojson) {
  if (geojson.type == "Feature") {
    return geojson.geometry;
  }
  return geojson;
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

/// Takes a {@link LineString} and returns a {@link Point} at a specified distance along the line.
///
/// @name along
/// @param {Feature<LineString>} line input line
/// @param {number} distance distance along the line
/// @param {Object} [options] Optional parameters
/// @param {string} [options.units="kilometers"] can be degrees, radians, miles, or kilometers
/// @returns {Feature<Point>} Point `distance` `units` along the line
/// @example
/// var line = turf.lineString([[-83, 30], [-84, 36], [-78, 41]]);
/// var options = {units: 'miles'};
///
/// var along = turf.along(line, 200, options);
///
/// //addToMap
/// var addToMap = [along, line]
along(line, double distance, {var options = turf.Unit.meters}) {
  // Get Coords
  var geom = getGeom(line);
  var coords = geom.coordinates;
  double travelled = 0;
  for (var i = 0; i < coords.length; i++) {
    if (distance >= travelled && i == coords.length - 1) {
      break;
    } else if (travelled >= distance) {
      double overshot = distance - travelled;
      if (overshot == 0) {
        return turf.Point(coordinates: coords[i]);
      } else {
        double direction = turf.bearingRaw(coords[i], coords[i - 1]) - 180;
        var interpolated =
            turf.destinationRaw(coords[i], overshot, direction, options);
        return turf.Point(coordinates: interpolated);
      }
    } else {
      travelled += turf.distanceRaw(coords[i], coords[i + 1], options);
    }
  }
  return turf.Point(coordinates: coords[coords.length - 1]);
}

// /**
//  * Takes a {@link LineString|line}, a specified distance along the line to a start {@link Point},
//  * and a specified  distance along the line to a stop point
//  * and returns a subsection of the line in-between those points.
//  *
//  * This can be useful for extracting only the part of a route between two distances.
//  *
//  * @name lineSliceAlong
//  * @param {Feature<LineString>|LineString} line input line
//  * @param {number} startDist distance along the line to starting point
//  * @param {number} stopDist distance along the line to ending point
//  * @param {Object} [options={}] Optional parameters
//  * @param {string} [options.units='kilometers'] can be degrees, radians, miles, or kilometers
//  * @returns {Feature<LineString>} sliced line
//  * @example
//  * var line = turf.lineString([[7, 45], [9, 45], [14, 40], [14, 41]]);
//  * var start = 12.5;
//  * var stop = 25;
//  * var sliced = turf.lineSliceAlong(line, start, stop, {units: 'miles'});
//  *
//  * //addToMap
//  * var addToMap = [line, start, stop, sliced]
//  */
lineSliceAlong(line, startDist, stopDist, {options}) {
  // Optional parameters
  if (options == null) options = {"units": turf.Unit.meters};

  var coords;
  List<turf.Position> slice = [];

  // Validation
  if (line.type == "Feature")
    coords = line.geometry.coordinates;
  else if (line.type == "LineString")
    coords = line.coordinates;
  else
    throw new Exception("input must be a LineString Feature or Geometry");

  var origCoordsLength = coords.length;
  double travelled = 0;
  var overshot, direction, interpolated;

  for (var i = 0; i < coords.length; i++) {
    if (startDist >= travelled && i == coords.length - 1)
      break;
    else if (travelled > startDist && slice.length == 0) {
      overshot = startDist - travelled;
      if (overshot == 0) {
        slice.add(coords[i]);
        return turf.Feature<turf.LineString>(
            geometry: turf.LineString(coordinates: slice));
      }
      direction = turf.bearingRaw(coords[i], coords[i - 1]) - 180;
      interpolated =
          turf.destinationRaw(coords[i], overshot, direction, options['units']);
      slice.add(interpolated);
    }

    if (travelled >= stopDist) {
      overshot = stopDist - travelled;
      if (overshot == 0) {
        slice.add(coords[i]);
        return turf.Feature<turf.LineString>(
            geometry: turf.LineString(coordinates: slice));
      }
      direction = turf.bearingRaw(coords[i], coords[i - 1]) - 180;
      interpolated =
          turf.destinationRaw(coords[i], overshot, direction, options['units']);
      slice.add(interpolated);
      return turf.Feature<turf.LineString>(
          geometry: turf.LineString(coordinates: slice));
    }

    if (travelled >= startDist) {
      slice.add(coords[i]);
    }

    if (i == coords.length - 1) {
      return turf.Feature<turf.LineString>(
          geometry: turf.LineString(coordinates: slice));
    }

    travelled += turf.distanceRaw(coords[i], coords[i + 1], options['units']);
  }

  if (travelled < startDist && coords.length == origCoordsLength)
    throw new Exception("Start position is beyond line");
  return turf.Feature<turf.LineString>(
      geometry: turf.LineString(coordinates: coords[coords.length - 1]));
}

// /**
//  * Get GeoJSON object's type, Geometry type is prioritize.
//  *
//  * @param {GeoJSON} geojson GeoJSON object
//  * @param {string} [name="geojson"] name of the variable to display in error message (unused)
//  * @returns {string} GeoJSON type
//  * @example
//  * var point = {
//  *   "type": "Feature",
//  *   "properties": {},
//  *   "geometry": {
//  *     "type": "Point",
//  *     "coordinates": [110, 40]
//  *   }
//  * }
//  * var geom = turf.getType(point)
//  * //="Point"
//  */
getType(geojson) {
  if (geojson.type == "FeatureCollection") {
    return "FeatureCollection";
  }
  if (geojson.type == "GeometryCollection") {
    return "GeometryCollection";
  }
  if (geojson.type == "Feature" && geojson.geometry != null) {
    return geojson.geometry.type;
  }
  return geojson.type;
}

// /**
//  * Takes a {@link LineString|line} and returns a {@link LineString|line} at offset by the specified distance.
//  *
//  * @name lineOffset
//  * @param {Geometry|Feature<LineString|MultiLineString>} geojson input GeoJSON
//  * @param {number} distance distance to offset the line (can be of negative value)
//  * @param {Object} [options={}] Optional parameters
//  * @param {string} [options.units='kilometers'] can be degrees, radians, miles, kilometers, inches, yards, meters
//  * @returns {Feature<LineString|MultiLineString>} Line offset from the input line
//  * @example
//  * var line = turf.lineString([[-83, 30], [-84, 36], [-78, 41]], { "stroke": "#F00" });
//  *
//  * var offsetLine = turf.lineOffset(line, 2, {units: 'miles'});
//  *
//  * //addToMap
//  * var addToMap = [offsetLine, line]
//  * offsetLine.properties.stroke = "#00F"
//  */
lineOffset(geojson, distance, {options}) {
  // Optional parameters
  if (options == null) options = {"units": turf.Unit.meters};
  var units = options['units'];

  // Valdiation
  if (geojson == null) throw new Exception("geojson is required");
  if (distance == null || distance == null || distance is! num)
    throw new Exception("distance is required");

  var type = getType(geojson);

  switch (type) {
    case "LineString":
      return lineOffsetFeature(geojson, distance, units);

    // !!! not implemented
    // case "MultiLineString":
    //   var coords = [];
    //   flattenEach(geojson, function (feature) {
    //     coords.push(
    //       lineOffsetFeature(feature, distance, units).geometry.coordinates
    //     );
    //   });
    //   return multiLineString(coords, properties);
    default:
      throw new Exception("geometry " + type + " is not supported");
  }
}

// /**
//  * Line Offset
//  *
//  * @private
//  * @param {Geometry|Feature<LineString>} line input line
//  * @param {number} distance distance to offset the line (can be of negative value)
//  * @param {string} [units=kilometers] units
//  * @returns {Feature<LineString>} Line offset from the input line
//  */
lineOffsetFeature(line, distance, units) {
  List<List<turf.Position>> segments = [];
  var offsetDegrees = turf.lengthToDegrees(distance, units);
  var coords = getCoords(line);
  List<turf.Position> finalCoords = [];
  coords.asMap().forEach((index, currentCoords) {
    if (index != coords.length - 1) {
      var segment =
          processSegment(currentCoords, coords[index + 1], offsetDegrees);
      segments.add(segment);
      if (index > 0) {
        List<turf.Position> seg2Coords = segments[index - 1];
        turf.Position intersects = intersection(segment, seg2Coords);

        // Handling for line segments that aren't straight
        if (intersects != null) {
          seg2Coords[1] = intersects;
          segment[0] = intersects;
        }

        finalCoords.add(seg2Coords[0]);
        if (index == coords.length - 2) {
          finalCoords.add(segment[0]);
          finalCoords.add(segment[1]);
        }
      }
      // Handling for lines that only have 1 segment
      if (coords.length == 2) {
        finalCoords.add(segment[0]);
        finalCoords.add(segment[1]);
      }
    }
  });
  turf.Feature<turf.LineString> newLine = turf.Feature<turf.LineString>(
      geometry: turf.LineString(coordinates: finalCoords),
      properties: line.properties);
  return newLine;
}

// /**
//  * Process Segment
//  * Inspiration taken from http://stackoverflow.com/questions/2825412/draw-a-parallel-line
//  *
//  * @private
//  * @param {Array<number>} point1 Point coordinates
//  * @param {Array<number>} point2 Point coordinates
//  * @param {number} offset Offset
//  * @returns {Array<Array<number>>} offset points
//  */
List<turf.Position> processSegment(
    turf.Position point1, turf.Position point2, offset) {
  var L = sqrt((point1[0] - point2[0]) * (point1[0] - point2[0]) +
      (point1[1] - point2[1]) * (point1[1] - point2[1]));

  var out1x = point1[0] + (offset * (point2[1] - point1[1])) / L;
  var out2x = point2[0] + (offset * (point2[1] - point1[1])) / L;
  var out1y = point1[1] + (offset * (point1[0] - point2[0])) / L;
  var out2y = point2[1] + (offset * (point1[0] - point2[0])) / L;
  return [turf.Position(out1x, out1y), turf.Position(out2x, out2y)];
}

// /**
//  * Unwrap coordinates from a Feature, Geometry Object or an Array
//  *
//  * @name getCoords
//  * @param {Array<any>|Geometry|Feature} coords Feature, Geometry Object or an Array
//  * @returns {Array<any>} coordinates
//  * @example
//  * var poly = turf.polygon([[[119.32, -8.7], [119.55, -8.69], [119.51, -8.54], [119.32, -8.7]]]);
//  *
//  * var coords = turf.getCoords(poly);
//  * //= [[[119.32, -8.7], [119.55, -8.69], [119.51, -8.54], [119.32, -8.7]]]
//  */
getCoords(coords) {
  if (coords is List) {
    return coords;
  }

  // Feature
  if (coords.type == "Feature") {
    if (coords.geometry != null) {
      return coords.geometry.coordinates;
    }
  } else {
    // Geometry
    if (coords.coordinates) {
      return coords.coordinates;
    }
  }

  throw new Exception(
      "coords must be GeoJSON Feature, Geometry Object or an Array");
}

// /**
//  * https://github.com/rook2pawn/node-intersection
//  *
//  * Author @rook2pawn
//  */

// /**
//  * AB
//  *
//  * @private
//  * @param {Array<Array<number>>} segment - 2 vertex line segment
//  * @returns {Array<number>} coordinates [x, y]
//  */
ab(segment) {
  var start = segment[0];
  var end = segment[1];
  return [end[0] - start[0], end[1] - start[1]];
}

// /**
//  * Cross Product
//  *
//  * @private
//  * @param {Array<number>} v1 coordinates [x, y]
//  * @param {Array<number>} v2 coordinates [x, y]
//  * @returns {Array<number>} Cross Product
//  */
crossProduct(v1, v2) {
  return v1[0] * v2[1] - v2[0] * v1[1];
}

// /**
//  * Add
//  *
//  * @private
//  * @param {Array<number>} v1 coordinates [x, y]
//  * @param {Array<number>} v2 coordinates [x, y]
//  * @returns {Array<number>} Add
//  */
add(v1, v2) {
  return [v1[0] + v2[0], v1[1] + v2[1]];
}

// /**
//  * Sub
//  *
//  * @private
//  * @param {Array<number>} v1 coordinates [x, y]
//  * @param {Array<number>} v2 coordinates [x, y]
//  * @returns {Array<number>} Sub
//  */
sub(v1, v2) {
  return [v1[0] - v2[0], v1[1] - v2[1]];
}

// /**
//  * scalarMult
//  *
//  * @private
//  * @param {number} s scalar
//  * @param {Array<number>} v coordinates [x, y]
//  * @returns {Array<number>} scalarMult
//  */
scalarMult(s, v) {
  return [s * v[0], s * v[1]];
}

// /**
//  * Intersect Segments
//  *
//  * @private
//  * @param {Array<number>} a coordinates [x, y]
//  * @param {Array<number>} b coordinates [x, y]
//  * @returns {Array<number>} intersection
//  */
turf.Position intersectSegments(List<turf.Position> a, List<turf.Position> b) {
  var p = a[0];
  var r = ab(a);
  var q = b[0];
  var s = ab(b);

  var cross = crossProduct(r, s);
  var qmp = sub(q, p);
  var numerator = crossProduct(qmp, s);
  var t = numerator / cross;
  var intersection = add(p, scalarMult(t, r));
  return turf.Position(intersection[0], intersection[1]);
}

// /**
//  * Is Parallel
//  *
//  * @private
//  * @param {Array<number>} a coordinates [x, y]
//  * @param {Array<number>} b coordinates [x, y]
//  * @returns {boolean} true if a and b are parallel (or co-linear)
//  */
isParallel(List<turf.Position> a, List<turf.Position> b) {
  var r = ab(a);
  var s = ab(b);
  return crossProduct(r, s) == 0;
}

// /**
//  * Intersection
//  *
//  * @private
//  * @param {Array<number>} a coordinates [x, y]
//  * @param {Array<number>} b coordinates [x, y]
//  * @returns {Array<number>|boolean} true if a and b are parallel (or co-linear)
//  */
intersection(List<turf.Position> a, List<turf.Position> b) {
  if (isParallel(a, b)) return null;
  return intersectSegments(a, b);
}

// /**
//  * Callback for flattenEach
//  *
//  * @callback flattenEachCallback
//  * @param {Feature} currentFeature The current flattened feature being processed.
//  * @param {number} featureIndex The current index of the Feature being processed.
//  * @param {number} multiFeatureIndex The current index of the Multi-Feature being processed.
// //  */

// // /**
// //  * Iterate over flattened features in any GeoJSON object, similar to
// //  * Array.forEach.
// //  *
// //  * @name flattenEach
// //  * @param {FeatureCollection|Feature|Geometry} geojson any GeoJSON object
// //  * @param {Function} callback a method that takes (currentFeature, featureIndex, multiFeatureIndex)
// //  * @example
// //  * var features = turf.featureCollection([
// //  *     turf.point([26, 37], {foo: 'bar'}),
// //  *     turf.multiPoint([[40, 30], [36, 53]], {hello: 'world'})
// //  * ]);
// //  *
// //  * turf.flattenEach(features, function (currentFeature, featureIndex, multiFeatureIndex) {
// //  *   //=currentFeature
// //  *   //=featureIndex
// //  *   //=multiFeatureIndex
// //  * });
// //  */
// flattenEach(geojson, callback) {
//   geomEach(geojson, function (geometry, featureIndex, properties, bbox, id) {
//     // Callback for single geometry
//     var type = geometry === null ? null : geometry.type;
//     switch (type) {
//       case null:
//       case "Point":
//       case "LineString":
//       case "Polygon":
//         if (
//           callback(
//             feature(geometry, properties, { bbox: bbox, id: id }),
//             featureIndex,
//             0
//           ) === false
//         )
//           return false;
//         return;
//     }

//     var geomType;

//     // Callback for multi-geometry
//     switch (type) {
//       case "MultiPoint":
//         geomType = "Point";
//         break;
//       case "MultiLineString":
//         geomType = "LineString";
//         break;
//       case "MultiPolygon":
//         geomType = "Polygon";
//         break;
//     }

//     for (
//       var multiFeatureIndex = 0;
//       multiFeatureIndex < geometry.coordinates.length;
//       multiFeatureIndex++
//     ) {
//       var coordinate = geometry.coordinates[multiFeatureIndex];
//       var geom = {
//         type: geomType,
//         coordinates: coordinate,
//       };
//       if (
//         callback(feature(geom, properties), featureIndex, multiFeatureIndex) ===
//         false
//       )
//         return false;
//     }
//   });
// }

// converting from @turf/bbox
// https://github.com/Turfjs/turf/blob/2e9d3d51f765a814c2cad90e88ff86e27c9e066f/packages/turf-bbox/index.ts
// modified to support 3d bbox lng1,lat1,alt1,lng2,lat2,alt2
//
bbox(turf.Feature feature) {
  turf.BBox result = turf.BBox(INFINITY, INFINITY, -INFINITY, -INFINITY);
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

bboxToRectangle(turf.BBox bbox) {
  return new Rectangle(
      bbox.lat1, bbox.lng1, bbox.lat2 - bbox.lat1, bbox.lng2 - bbox.lng1);
}

Future<List<LatLng>> getMapboxGLGeom(turf.Feature f) async {
  List<LatLng> latLngs = new List();
  await coordEach(f,
      (coord, coordIndex, featureIndex, multiFeatureIndex, geometryIndex) {
    latLngs.add(new LatLng(coord[1], coord[0]));
  }, false);

  return latLngs;
}

turf.FeatureCollection<turf.LineString> LineCollectionFeatureCollectionFromJson(
    Map<String, dynamic> json) {
  return turf.FeatureCollection<turf.LineString>(
    bbox: json['bbox'] == null
        ? null
        : turf.BBox.fromJson(
            (json['bbox'] as List)?.map((e) => e as num)?.toList()),
    features: (json['features'] as List)
        ?.map((e) => e == null
            ? null
            : turf.Feature<turf.LineString>.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}
