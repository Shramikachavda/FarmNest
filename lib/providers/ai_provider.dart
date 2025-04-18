import 'package:agri_flutter/models/post_sign_up/farm_detail.dart';
import 'package:flutter/material.dart';

import '../services/gimini_service_api.dart';

class AIProvider with ChangeNotifier {
  bool _isLoading = false;
  String _aiResponse = "";
  bool _showAiResponse = false;
  String _aiFarmResponse = "";
  final GeminiService _geminiService = GeminiService();
  bool get isLoading => _isLoading;

  String get aiResponse => _aiResponse;

  bool get showAiResponse => _showAiResponse;

  String get aiFarmResponse => _aiFarmResponse;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setAiResponse(String response) {
    _aiResponse = response;
    notifyListeners();
  }

  Future<void> getSuggestion(BuildContext context, FarmDetail farm) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _geminiService.getFarmAdvice(farm.state, farm.locationDescription);
      farm.aiResponse = response;
    } catch (e) {
      farm.aiResponse = "Error generating recommendations: $e";
    } finally {
     _isLoading = false;
      notifyListeners();
    }
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
