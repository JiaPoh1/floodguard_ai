import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city/models/models.dart';
import 'package:country_state_city/utils/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<List<State>> getAllStates() async {
  return await getStatesOfCountry('MY');
}

Future<List<City>> getAllCitiesByState(String stateCode) async {
  return await getStateCities('MY', stateCode);
}

Future<Map<String, dynamic>?> fetchGeoLocation(String cityName) async {
  final geoResponse = await http.get(
    Uri.parse(
      'http://api.openweathermap.org/geo/1.0/direct?q=$cityName,MY&limit=1&appid=${dotenv.env['OPEN_WEATHER_API_KEY']}',
    ),
  );
  final json = jsonDecode(geoResponse.body) as List<dynamic>;

  if (json.isEmpty) {
    return null;
  }

  return jsonDecode(geoResponse.body)[0] as Map<String, dynamic>;
}

Future<Map<String, dynamic>?> fetchWeatherForecasts(String cityName) async {
  final geoData = await fetchGeoLocation(cityName);

  if (geoData == null) {
    return null;
  }

  final lat = geoData['lat'];
  final lon = geoData['lon'];

  final response = await http.get(
    Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=${dotenv.env['OPEN_WEATHER_API_KEY']}',
    ),
  );

  return jsonDecode(response.body);
}

Future<List<Map<String, dynamic>>> getAllWeatherForecasts() async {
  try {
    final weatherForecastsSnapshots = await FirebaseFirestore.instance.collection('weather_forecasts').get();
    final List<Map<String, dynamic>> weatherForecasts = [];

    for (var weatherForecast in weatherForecastsSnapshots.docs) {
      final data = await fetchWeatherForecasts(weatherForecast['city_name']);

      if (data == null) {
        continue;
      }

      data['name'] = weatherForecast['city_name'];
      data['docId'] = weatherForecast.id;
      weatherForecasts.add(data);
    }

    return weatherForecasts;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<int> addWeatherForecast(String cityName) async {
  final geoData = await fetchGeoLocation(cityName);

  if (geoData == null) {
    return 0;
  }

  await FirebaseFirestore.instance.collection('weather_forecasts').add({'city_name': cityName, 'country_code': 'MY'});
  return 1;
}

Future<void> deleteWeatherForecast(String docId) async {
  await FirebaseFirestore.instance.collection('weather_forecasts').doc(docId).delete();
}
