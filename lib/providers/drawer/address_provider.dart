import 'package:flutter/material.dart';
import '../../models/post_sign_up/default_farmer_address.dart';
import '../../services/firestore.dart';

class AddressProvider with ChangeNotifier {
  AddressProvider() {
    loadAddressesSilently();
  }

  final FirestoreService _firestoreService = FirestoreService();

  List<DefaultFarmerAddress> _addresses = [];
  bool _isLoading = false;

  List<DefaultFarmerAddress> get addresses => _addresses;
  bool get isLoading => _isLoading;

  Future<void> loadAddressesSilently() async {
    _isLoading = true; // Update state without notifying
    _addresses = await _firestoreService.getAllAddresses();
    _isLoading = false;
    print(
      "Silently Loaded Addresses: ${_addresses.map((a) => '${a.name}: ${a.isDefault}').toList()}",
    );
    // No notifyListeners() here; let the widget handle initial render
  }

  Future<void> loadAddresses() async {
    _isLoading = true;
    notifyListeners();

    _addresses = await _firestoreService.getAllAddresses();
    print(
      "Loaded Addresses: ${_addresses.map((a) => '${a.name}: ${a.isDefault}').toList()}",
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addAddress(DefaultFarmerAddress address) async {
    await _firestoreService.addDefaultLocation(address);
    await loadAddresses(); // Use notifying version here
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
    await _firestoreService.setDefaultAddress(address.name);
    await loadAddresses();
  }

  Future<DefaultFarmerAddress?> getDefaultAddress() async {
    final result = await _firestoreService.getDefaultAddress();
    print("Default Address from Firestore: $result");
    return result;
  }
}
