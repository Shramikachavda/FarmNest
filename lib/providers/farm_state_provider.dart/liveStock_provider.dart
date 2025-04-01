import 'package:agri_flutter/models/crop_details.dart';
import 'package:agri_flutter/models/live_stock_detail.dart';
import 'package:agri_flutter/services/firestore_event_expense.dart';
import 'package:flutter/widgets.dart';

class LivestockProvider with ChangeNotifier {
  final List<LiveStockDetail> _liveStockList = [];
  final FirestoreService _firestoreService = FirestoreService();

  LivestockProvider() {
    fetchLivestock();
  }

  List<LiveStockDetail> get liveStockList => _liveStockList; // Getter for list

  Future<void> fetchLivestock() async {
    try {
      print("🔹 Fetching livestock...");
      List<LiveStockDetail> fetchedList =
          await _firestoreService.getLiveStock();

      _liveStockList.clear();
      _liveStockList.addAll(fetchedList);

      print("✅ Retrieved ${_liveStockList.length} livestock entries");
      notifyListeners();
    } catch (e) {
      print("❌ Error fetching livestock: $e");
    }
  }

  /// 🔹 **Add Livestock to Firestore**
  Future<void> addLiveStock(LiveStockDetail livestock) async {
    try {
      print("🔹 Adding livestock: ${livestock.liveStockName}");
      await _firestoreService.addLiveStock(livestock);

      _liveStockList.add(livestock);
      print("✅ Added livestock: ${livestock.liveStockName}");
      notifyListeners();
    } catch (e) {
      print("❌ Error adding livestock: $e");
    }
  }

  /// 🔹 **Remove Livestock from Firestore**
  Future<void> removeLiveStock(LiveStockDetail livestock) async {
    try {
      await _firestoreService.removeLive(livestock);

      _liveStockList.removeWhere((item) => item.id == livestock.id);
      print("✅ Removed livestock: ${livestock.liveStockName}");
      notifyListeners();
    } catch (e) {
      print("❌ Error removing livestock: $e");
    }
  }

  Future<void> updateLivestock(String userId, LiveStockDetail livestock) async {
    try {
      await _firestoreService.updateLivestock(userId, livestock);
      int index = _liveStockList.indexWhere((item) => item.id == livestock.id);
      if (index != -1) {
        _liveStockList[index] = livestock;
        notifyListeners();
      }
    } catch (e) {
      print("Error updating livestock: $e");
      // Optionally show an error message to the user
    }
  }
}
