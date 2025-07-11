import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/responses/weather_response.dart';

class WeatherRepository {
  static const String _baseUrlCurrent =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String _baseUrlHourly =
      'https://api.openweathermap.org/data/2.5/forecast';
  static const String _apiKey ="";
    //  '9442f93b3131dfd4791a8a09c19efdbb'; // Replace with your key

  Future<Map<String, dynamic>> fetchCurrentWeather(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse(
      '$_baseUrlCurrent?lat=$lat&lon=$lon&appid=$_apiKey&units=metric',
    );
    final response = await http.get(url);
    print('Current Weather Response: ${response.body}');
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Failed to load current weather: ${response.statusCode}');
  }

  Future<Weather> fetchHourlyForecast(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse(
      '$_baseUrlHourly?lat=$lat&lon=$lon&appid=$_apiKey&units=metric',
    );
    print(url);

    final response = await http.get(url);
    print("hourly record $response ");
    Weather weatherData = weatherFromJson(response.body);
    print("hourly record weather $weatherData ");
    if (response.statusCode == 200) return weatherData;
    throw Exception('Failed to load hourly forecast: ${response.statusCode}');
  }
}
