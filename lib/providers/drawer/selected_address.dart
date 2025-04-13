import 'package:flutter/material.dart';
import 'package:agri_flutter/models/post_sign_up/default_farmer_address.dart';

class SelectedAddressProvider with ChangeNotifier {
  DefaultFarmerAddress? _selected;

  DefaultFarmerAddress? get selected => _selected;

  void setAddress(DefaultFarmerAddress address) {
    _selected = address;
    notifyListeners(); // This ensures CheckoutView updates
    print("Selected Address Updated: ${address.name}");
  }

  void clear() {
    _selected = null;
    notifyListeners();
  }
}