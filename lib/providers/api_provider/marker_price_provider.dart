import 'package:agri_flutter/repo/market_price_api.dart';
import 'package:flutter/material.dart';


class MarkerPriceProvider extends ChangeNotifier {
  final MarketPricesRepository _repository = MarketPricesRepository();
  List<dynamic> prices = [];
  bool isLoading = false;
  String? errorMessage;

  Future<dynamic> loadPrices() async {
    isLoading = true;
    errorMessage = null; // Reset error
    notifyListeners();

    try {
      prices = await _repository.fetchMarketPrices();
    } catch (e) {
      errorMessage = e.toString(); // Capture error for UI
    }

    isLoading = false;
    notifyListeners();
  }
}