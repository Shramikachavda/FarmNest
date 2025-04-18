/*import 'package:agri_flutter/services/firestore.dart';
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
*/


// lib/providers/farm_state_provider.dart/crop_details_provider.dart
import 'package:agri_flutter/models/crop_details.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:flutter/material.dart';

import '../../core/drop_down_value.dart';

class CropDetailsProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<CropDetails> _allCropList = [];

  // Dropdown values

  GrowthStage? _selectedStage;
  FertilizerType? _selectedFertilizer;
  PesticideType? _selectedPesticide;


  GrowthStage? get selectedStage => _selectedStage;
  FertilizerType? get selectedFertilizer => _selectedFertilizer;
  PesticideType? get selectedPesticide => _selectedPesticide;

  void setGrowth(GrowthStage? value) {
    _selectedStage = value ?? GrowthStage.seedling;
    notifyListeners();
  }

  void setFerti(FertilizerType? value) {
    _selectedFertilizer = value ?? FertilizerType.organic;
    notifyListeners();
  }

  void setPesti(PesticideType? value) {
    _selectedPesticide = value ?? PesticideType.insecticide;
    notifyListeners();
  }
  List<CropDetails> get allCropList => _allCropList;

  Future<void> addCrop(CropDetails crop) async {
    try {
      await _firestoreService.addCrop(_firestoreService.userId, crop);
      _allCropList.add(crop);
      notifyListeners();
    } catch (e) {
      throw Exception("Error adding crop: $e");
    }
  }

  Future<void> updateCrop(String userId, CropDetails crop) async {
    try {
      await _firestoreService.updateCrop(userId, crop);
      final index = _allCropList.indexWhere((c) => c.id == crop.id);
      if (index != -1) {
        _allCropList[index] = crop;
        notifyListeners();
      }
    } catch (e) {
      throw Exception("Error updating crop: $e");
    }
  }

  Future<void> removeCrop(String id) async{
    try{
      await _firestoreService.deleteCrop(id);
      print("delete");
    }catch(e){
      throw Exception("Error fetching crops: $e");
    }
  }

  Future<void> fetchCrops() async {
    try {
      _allCropList = await _firestoreService.getCrops();
      notifyListeners();
    } catch (e) {
      throw Exception("Error fetching crops: $e");
    }
  }
}