import 'package:agri_flutter/repo/weather.dart';
import 'package:flutter/material.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _repository = WeatherRepository();
  Map<String, dynamic>? currentWeather;
  List<Map<String, dynamic>>? dailyForecast; // Changed to store 4-day forecast
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadWeather(double lat, double lon) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Fetch current weather (already working)
      currentWeather = await _repository.fetchCurrentWeather(lat, lon);
      print("Current Weather Loaded: $currentWeather");

      // Fetch and process 4-day forecast
      final forecastData = await _repository.fetchHourlyForecast(lat, lon);
      dailyForecast = _processForecast(forecastData['list']);
      print("Daily Forecast Loaded: $dailyForecast");

      if (currentWeather == null) {
        errorMessage = 'No current weather data available';
        print("Weather Fetch Error: $errorMessage");
      }
      if (dailyForecast == null || dailyForecast!.isEmpty) {
        errorMessage = errorMessage != null
            ? '$errorMessage\nNo forecast data available'
            : 'No forecast data available';
        print("Forecast Fetch Error: $errorMessage");
      }
    } catch (e) {
      print("Weather Fetch Error: $e");
      errorMessage = 'Error: $e';
      currentWeather = null;
      dailyForecast = null;
    }

    isLoading = false;
    notifyListeners();
  }

  // Process forecast to get 4 daily entries
  List<Map<String, dynamic>> _processForecast(List<dynamic> forecastList) {
    final dailyForecast = <Map<String, dynamic>>[];
    final seenDates = <String>{};

    for (var entry in forecastList) {
      final dateTime = DateTime.parse(entry['dt_txt']);
      final date = "${dateTime.day}/${dateTime.month}/${dateTime.year}";

      // Pick 12:00 PM entry for each day
      if (!seenDates.contains(date) && dateTime.hour == 12) {
        dailyForecast.add(Map<String, dynamic>.from(entry));
        seenDates.add(date);
      }
      if (dailyForecast.length == 4) break; // Limit to 4 days
    }

    // Fill with available entries if less than 4 days
    if (dailyForecast.length < 4) {
      for (var entry in forecastList) {
        final dateTime = DateTime.parse(entry['dt_txt']);
        final date = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
        if (!seenDates.contains(date)) {
          dailyForecast.add(Map<String, dynamic>.from(entry));
          seenDates.add(date);
        }
        if (dailyForecast.length == 4) break;
      }
    }

    return dailyForecast;
  }
}