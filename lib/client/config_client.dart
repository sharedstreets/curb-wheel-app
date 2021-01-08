import 'package:chopper/chopper.dart';
import '../service/api_services.dart';

class ConfigClient {
  final ChopperClient chopper;

  ConfigClient()
      : chopper = ChopperClient(
            services: [ConfigService.create()],
            interceptors: [HttpLoggingInterceptor()],
            converter: JsonConverter());

  getConfig(String url) async {
    final configService = chopper.getService<ConfigService>();

    /// then call your function
    final response = await configService.getConfig(url);

    //if (response.isSuccessful) {
    // successful request
    final body = response.body;
    print(body);
    print("foo");
    //Map data = jsonDecode(body);
    print("foo");
    //print(data);
    var config = Config.fromJson(body);
    return config;
    //}
  }
}
