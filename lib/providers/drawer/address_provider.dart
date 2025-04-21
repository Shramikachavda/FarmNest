import 'package:flutter/material.dart';
import '../../models/post_sign_up/default_farmer_address.dart';
import '../../services/firestore.dart';

class AddressProvider with ChangeNotifier {
  AddressProvider() {
    loadAddresses();
  }

  final FirestoreService _firestoreService = FirestoreService();

  List<DefaultFarmerAddress> _addresses = [];
  bool _isLoading = false;

  List<DefaultFarmerAddress> get addresses => _addresses;

  bool get isLoading => _isLoading;

  Future<void> loadAddresses() async {
    _isLoading = true;
    notifyListeners();

    _addresses = await _firestoreService.getAllAddresses();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addAddress(DefaultFarmerAddress address) async {
    await _firestoreService.addDefaultLocation(address);
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

  Future<void> setDefaultIfNotAlready(DefaultFarmerAddress newDefault) async {
    if (newDefault.isDefault) return;

    for (var addr in _addresses) {
      if (addr.isDefault && addr.name != newDefault.name) {
        await _firestoreService.updateAddress(
          addr.copyWith(isDefault: false),
        );
      }
    }

    await _firestoreService.updateAddress(
      newDefault.copyWith(isDefault: true),
    );

    await loadAddresses();
  }

  Future<DefaultFarmerAddress?> getDefaultAddress() async {
    _isLoading = true;
    notifyListeners();
    final data =  await _firestoreService.getDefaultAddress();
    _isLoading = false;
    notifyListeners();
    return data;

  }
}

