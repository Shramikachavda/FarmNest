import 'package:agri_flutter/repo/market_price_api.dart';
import 'package:flutter/material.dart';

class MarkerPriceProvider extends ChangeNotifier {
  final MarketPricesRepository _repository = MarketPricesRepository();
  List<dynamic> prices = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadInitialPrices() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      prices = await _repository.fetchMarketPrices(
        state: 'Gujarat',
        dateFilter: '01/04/2025', // Use a recent date in dd/MM/yyyy format
      );
      if (prices.isEmpty) {
        errorMessage = 'No data found for Gujarat';
      }
      prices = prices.take(2).toList(); // Limit to 3 for home page
    } catch (e) {
      errorMessage = 'Error loading initial prices: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadFilteredPrices({String? state, String? commodity}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      prices = await _repository.fetchMarketPrices(
        state: state ?? 'Gujarat',
        commodity: commodity,
        dateFilter: '01/04/2025', // Default to recent data
      );
      if (prices.isEmpty) {
        errorMessage =
            'No data found for ${commodity ?? "any commodity"} in Gujarat on 01/04/2025';
      }
    } catch (e) {
      errorMessage = 'Error loading filtered prices: $e';
    }

    isLoading = false;
    notifyListeners();
  }
}
