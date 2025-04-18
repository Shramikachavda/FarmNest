import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../customs_widgets/custom_snackbar.dart';
import '../../../models/post_sign_up/farm_detail.dart';
import '../../../models/responses/weather_response.dart';
import '../../../providers/ai_provider.dart';
import '../../../services/firestore.dart';
import '../../../services/gimini_service_api.dart';
import '../../home_page_view/weather_forecast/weather_bloc.dart';

class FarmBloc {
  final StreamController<List<FarmDetail>> _streamController =
      StreamController.broadcast();
  final FirestoreService _firestoreService = FirestoreService();

  final WeatherBloc _weatherBloc = WeatherBloc();
  final GeminiService _geminiService = GeminiService();

  Stream<List<FarmDetail>> get farmList => _streamController.stream;

  Future<void> getFarmDetail() async {
    try {
      final result = await _firestoreService.getFarm();
      print("result  : $result");
      _streamController.add(result ?? []);
    } catch (e) {
      _streamController.addError("something went wrong $e");
    }
  }

  Future<void> updateFarmBoundary(
    String farmId,
    List<LatLongData> boundaries,
  ) async {
    await _firestoreService.updateFarmBoundary(farmId, boundaries);
  }

  Future<bool> deleteFarm(String farmId) async {
    try {
      await _firestoreService.deleteFarm(farmId);

      await getFarmDetail();
      return true;
    } catch (e) {
      print("Error deleting farm: $e");
      return false;
    }
  }

  void dispose() {
    _streamController.close();
  }

  Future<void> getSuggestion(
    BuildContext context,
    String city,
    String locationDescription,
    String id,
  ) async {
    final aiProvider = Provider.of<AIProvider>(context, listen: false);
    aiProvider.setLoading(true);
    aiProvider.setShowAiResponse(true);
    try {
      final response = await _geminiService.getFarmAdvice(
        city,
        locationDescription,
      );

      aiProvider.setLoading(false);
      aiProvider.setAiResponse(response);
    } catch (e) {
      aiProvider.setAiResponse("Error generating recommendations: $e");
      showCustomSnackBar(context, "Failed to fetch recommendations: $e");
      aiProvider.setLoading(false);
    }
  }
}
