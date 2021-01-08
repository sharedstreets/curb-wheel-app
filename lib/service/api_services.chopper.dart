// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_services.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$ConfigService extends ConfigService {
  _$ConfigService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = ConfigService;

  Future<Response> getConfig(String url) {
    final $url = '$url';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
