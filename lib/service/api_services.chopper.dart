// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_services.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$JsonService extends JsonService {
  _$JsonService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = JsonService;

  Future<Response> getJson(String url) {
    final $url = '${url}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
