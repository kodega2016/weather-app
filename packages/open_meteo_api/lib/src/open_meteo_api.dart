import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_meteo_api/src/errors/exceptions.dart';
import 'package:open_meteo_api/src/models/location.dart';
import 'package:open_meteo_api/src/models/weather.dart';

class OpenMeteoApi {
  final http.Client _client;
  OpenMeteoApi({
    http.Client? client,
  }) : _client = client ?? http.Client();

  static const _baseUrlWeather = 'api.open-meteo.com';
  static const _baseUrlGeocoding = 'geocoding-api.open-meteo.com';

  Future<Location> locationSearch(String query) async {
    final locationRequest = Uri.https(
      _baseUrlGeocoding,
      '/v1/search',
      {'name': query, 'count': '1'},
    );
    final locationResponse = await _client.get(locationRequest);
    if (locationResponse.statusCode != 200) throw LocationRequestFailure();
    final locationJson = jsonDecode(locationResponse.body) as Map;
    if (!locationJson.containsKey('results')) throw LocationNotFoundFailure();
    final results = locationJson['results'] as List;
    if (results.isEmpty) throw LocationNotFoundFailure();
    return Location.fromJson(results.first as Map<String, dynamic>);
  }

  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final weatherRequest = Uri.https(_baseUrlWeather, 'v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current_weather': 'true'
    });

    final weatherResponse = await _client.get(weatherRequest);
    if (weatherResponse.statusCode != 200) throw WeatherRequestFailure();
    final bodyJson = jsonDecode(weatherResponse.body) as Map<String, dynamic>;
    if (!bodyJson.containsKey('current_weather')) {
      throw WeatherNotFoundFailure();
    }
    final weatherJson = bodyJson['current_weather'] as Map<String, dynamic>;
    return Weather.fromJson(weatherJson);
  }
}
