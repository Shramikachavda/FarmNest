import 'dart:async';

import 'package:agri_flutter/services/location.dart';
import 'package:geocoding/geocoding.dart';
import '../../../models/responses/weather_response.dart';
import '../../../repo/weather.dart';

class WeatherBloc {
  final WeatherRepository _repository = WeatherRepository();
  final LocationService locationService = LocationService();

  final StreamController<Weather> _streamController =
      StreamController.broadcast();

  Stream<Weather> get dailyWeather => _streamController.stream;

  Future<void> loadWeatherData(double lat, double long) async {
    try {
      // final currentWeather = await _repository.fetchCurrentWeather(lat, long);
      final forecastData = await _repository.fetchHourlyForecast(lat, long);
      _streamController.add(forecastData);
    } catch (e) {
      _streamController.addError(e);
    }
  }

  Future<void> fetchWeatherData() async {
    final locationData = await locationService.fetchLocation();
    if (locationData != null) {
      double lat = locationData.latitude ?? 0;
      double long = locationData.longitude ?? 0;
      await loadWeatherData(lat, long);
    } else {
      _streamController.addError("Something went Wrong");
    }

  }



  Future<void> fetchWeatherByCity(String city) async {
    try {
      List<Location> locations = await locationFromAddress(city);
      if (locations.isNotEmpty) {
        await loadWeatherData(locations[0].latitude, locations[0].longitude);
      } else {
        _streamController.addError("City not found.");
      }
    } catch (e) {
      _streamController.addError("Failed to get coordinates.");
    }
  }


  void dispose() {
    _streamController.close();
  }
}



