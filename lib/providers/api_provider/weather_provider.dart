import 'package:agri_flutter/repo/weather.dart';
import 'package:flutter/material.dart';

import '../../models/responses/weather_response.dart';

class WeatherViewModel with ChangeNotifier {

  final WeatherRepository _repository = WeatherRepository();
  Map<String, dynamic>? currentWeather;
  List<ListElement>? dailyForecast; // Changed to store 4-day forecast
  bool isLoading = false;
  String? errorMessage;


  // Process forecast to get 4 daily entries
  List<ListElement> _processForecast(List<ListElement> forecastList) {
    List<ListElement> dailyForecast = [];
    final seenDates = <String>{};

    for (var entry in forecastList) {
      final dateTime = entry.dtTxt ;
          final date = "${dateTime?.day  }/${dateTime?.month}/${dateTime?.year}";

      // Pick 12:00 PM entry for each day
      if (!seenDates.contains(date) && dateTime?.hour == 12) {
        dailyForecast.add(entry);
        seenDates.add(date);
      }
      if (dailyForecast.length == 4) break; // Limit to 4 days
    }

    // Fill with available entries if less than 4 days
    if (dailyForecast.length < 4) {
      for (var entry in forecastList) {
        final dateTime = entry.dtTxt;
        final date = "${dateTime?.day}/${dateTime?.month}/${dateTime?.year}";
        if (!seenDates.contains(date)) {
          dailyForecast.add(entry);
          seenDates.add(date);
        }
        if (dailyForecast.length == 4) break;
      }
    }

    return dailyForecast;
  }

  Future<void> loadWeather(double lat, double lon, {bool reset = false}) async {
    if (reset) {
      currentWeather = null;
      dailyForecast = null;
      errorMessage = null;
    }

    isLoading = true;
    notifyListeners();

    try {
      currentWeather = await _repository.fetchCurrentWeather(lat, lon);
      final forecastData = await _repository.fetchHourlyForecast(lat, lon);
      dailyForecast = _processForecast(forecastData.list??[]);

      if (currentWeather == null) {
        errorMessage = 'No current weather data available';
      }

      if (dailyForecast == null || dailyForecast!.isEmpty) {
        errorMessage = '${errorMessage != null
            ? '$errorMessage\n'
            : ''}No forecast data available';
      }
    } catch (e) {
      errorMessage = 'Error: $e';
      currentWeather = null;
      dailyForecast = null;
    }

    isLoading = false;
    notifyListeners();
  }

}
