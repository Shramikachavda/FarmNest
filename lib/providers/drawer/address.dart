import 'package:flutter/material.dart';
import 'package:agri_flutter/models/post_sign_up/default_farmer_address.dart';
import 'package:agri_flutter/services/firestore.dart';

class AddressProvider with ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  List<DefaultFarmerAddress> _addresses = [];
  List<DefaultFarmerAddress> get addresses => _addresses;

  Future<void> loadAddresses() async {
    _addresses = await _service.getAllAddresses();
    notifyListeners();
  }

  Future<void> addAddress(DefaultFarmerAddress address) async {
    if (address.isDefault) {
      await _service.addDefaultLocation(address);
    } else {
      await _service.addNewAddress(address);
    }
    await loadAddresses(); // Refresh list
  }

  Future<void> updateAddress(DefaultFarmerAddress address) async {
    await _service.updateAddress(address);
    await loadAddresses();
  }

  Future<void> deleteAddress(String name) async {
    await _service.deleteAddress(name);
    await loadAddresses();
  }

  Future<void> setDefault(DefaultFarmerAddress address) async {
    await _service.addDefaultLocation(address);
    await loadAddresses();
  }
}
