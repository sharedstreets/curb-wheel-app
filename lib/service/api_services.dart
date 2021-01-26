import "dart:async";
import 'package:chopper/chopper.dart';
import 'package:turf/turf.dart';
import 'dart:convert';

part 'api_services.chopper.dart';

class MapData {
  final FeatureCollection featureCollection;

  MapData(this.featureCollection);

  MapData.fromJson(Map<String, dynamic> json)
      : featureCollection = FeatureCollection.fromJson(json);
}

@ChopperApi()
abstract class JsonService extends ChopperService {
  static JsonService create([ChopperClient client]) => _$JsonService(client);

  @Get(path: '{url}')
  Future<Response> getJson(@Path('url') String url);
}
