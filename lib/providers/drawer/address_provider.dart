import 'package:flutter/material.dart';

import '../../models/post_sign_up/default_farmer_address.dart';
import '../../services/firestore.dart';

class AddressProvider with ChangeNotifier {
  AddressProvider() {
    loadAddresses();
  }

  final FirestoreService _firestoreService = FirestoreService();

  List<DefaultFarmerAddress> _addresses = [];
  bool _isLoading = false; // <-- Add this line

  List<DefaultFarmerAddress> get addresses => _addresses;
  bool get isLoading => _isLoading; // <-- And this getter

  Future<void> loadAddresses() async {
    _isLoading = true;        // Start loading
    notifyListeners();

    _addresses = await _firestoreService.getAllAddresses();

    _isLoading = false;       // Done loading
    notifyListeners();
  }

  Future<void> addAddress(DefaultFarmerAddress address) async {
    if (address.isDefault) {
      await _firestoreService.addDefaultLocation(address);
    } else {
      await _firestoreService.addNewAddress(address);
    }
    await loadAddresses();
  }

  Future<void> updateAddress(DefaultFarmerAddress address) async {
    await _firestoreService.updateAddress(address);
    await loadAddresses();
  }

  Future<void> deleteAddress(String name) async {
    await _firestoreService.deleteAddress(name);
    await loadAddresses();
  }

  Future<void> setDefault(DefaultFarmerAddress address) async {
    await _firestoreService.addDefaultLocation(address);
    await loadAddresses();
  }

  Future<DefaultFarmerAddress?> getDefaultAddress() async {
    return await _firestoreService.getDefaultAddress();
  }

}
