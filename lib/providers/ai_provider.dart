import 'package:flutter/material.dart';

class AIProvider with ChangeNotifier {
  bool _isLoading = false;
  String _aiResponse = "";
  bool _showAiResponse = false;

  bool get isLoading => _isLoading;
  String get aiResponse => _aiResponse;
  bool get showAiResponse => _showAiResponse;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setAiResponse(String response) {
    _aiResponse = response;
    notifyListeners();
  }

  void setShowAiResponse(bool value) {
    _showAiResponse = value;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _aiResponse = "";
    _showAiResponse = false;
    notifyListeners();
  }
}