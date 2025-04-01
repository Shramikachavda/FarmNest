import 'package:agri_flutter/services/firestore_event_expense.dart';
import 'package:flutter/material.dart';
import 'package:agri_flutter/models/crop_details.dart';

class CropDetailsProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<CropDetails> _cropDetailsList = [];

  List<CropDetails> get allCropList => _cropDetailsList;

  CropDetailsProvider() {
    fetchCrops();
  }

  /// **Fetch Crops from Firestore**
  Future<void> fetchCrops() async {
    try {
      _cropDetailsList = await _firestoreService.getCrops();
      notifyListeners();
    } catch (e) {
      print("❌ Error fetching crops: $e");
    }
  }

  /// **Add Crop (Firestore + Provider)**
  Future<void> addCrop(CropDetails cropDetail) async {
    try {
      await _firestoreService.addCrop(cropDetail);
      _cropDetailsList.add(cropDetail);
      notifyListeners();
      print("✅ Crop added: ${cropDetail.cropName}");
    } catch (e) {
      print("❌ Error adding crop: $e");
    }
  }

  /// 🔹 **Update Crop inside User**
Future<void> updateCrop(String userId , CropDetails crop) async {
  try {
    await _firestoreService.updateCrop(userId, crop);
    int index = _cropDetailsList.indexWhere((item) => item.id == crop.id);
    if (index != -1) {
      _cropDetailsList[index] = crop;
      notifyListeners();
    }
  } catch (e) {
    print("Error updating crop: $e");
    // Optionally show an error message to the user
  }
}



  /// **Remove Product (Firestore + Provider)**
  Future<void> removeCrop(CropDetails crop) async {
    try {
      await _firestoreService.removeCrop(crop.id); // Remove from Firestore
      _cropDetailsList.removeWhere(
        (p) => p.id == crop.id,
      ); // Remove from Provider
      notifyListeners(); // Notify UI update
      print("✅ Product removed: ${crop.id}");
    } catch (e) {
      print("❌ Error removing product: $e");
    }
  }
}
