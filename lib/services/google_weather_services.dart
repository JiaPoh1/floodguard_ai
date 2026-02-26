import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static Future<Map<String, dynamic>> getWeatherData(double lat, double lng) async {
    final String apiKey = dotenv.env['GOOGLE_WEATHER_API_KEY'] ?? '';
    
    if (apiKey.isEmpty) {
      throw Exception('API Key not found in .env file');
    }

    final String url = 
      'https://weather.googleapis.com/v1/currentConditions:lookup?location.latitude=$lat&location.longitude=$lng&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error body: ${response.body}");
      throw Exception('Failed to load weather: ${response.statusCode}');
    }
  }
}