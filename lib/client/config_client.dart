import 'package:chopper/chopper.dart';

import 'package:curbwheel/service/models.dart';
import '../service/api_services.dart';

class ConfigClient {
  final ChopperClient chopper;
  ConfigClient()
      : chopper = ChopperClient(
            services: [JsonService.create()],
            interceptors: [HttpLoggingInterceptor()],
            converter: JsonConverter());

  _getJson(String url) async {
    final jsonService = chopper.getService<JsonService>();
    final response = await jsonService.getJson(url);

    if (response.isSuccessful) {
      // successful request
      final body = response.body;
      return body;
    } else
      throw Exception("Failed to load json data.");
  }

  getConfig(String url) async {
    var configJson = await _getJson(url);
    Config config = new Config.fromJson(configJson);
    return config;
  }

  getMapData(Config config) async {
    final mapDataJson = await _getJson(config.mapData);
    return MapData.fromJson(mapDataJson);
  }
}
