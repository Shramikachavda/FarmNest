import 'package:agri_flutter/repo/weather.dart';
import 'package:flutter/material.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _repository = WeatherRepository();
  Map<String, dynamic>? currentWeather;
  List<dynamic>? hourlyForecast;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadWeather(double lat, double lon) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentWeather = await _repository.fetchCurrentWeather(lat, lon);
      print("Weather Data Loaded: $currentWeather");
      //  final forecastData = await _repository.fetchHourlyForecast(lat, lon);
      //  hourlyForecast = forecastData['list'];
      if (currentWeather == null) {
        errorMessage = 'No weather data available';
        print("Weather Fetch Error: $errorMessage");
      }
    } catch (e) {
      print("Weather Fetch Error: $e");
      errorMessage = 'Error: $e';
      currentWeather = null;
      hourlyForecast = null;
    }

    isLoading = false;
    notifyListeners();
  }
}
