// file: lib/providers/selected_address_provider.dart
import 'package:flutter/material.dart';
import 'package:agri_flutter/models/post_sign_up/default_farmer_address.dart';

class SelectedAddressProvider extends ChangeNotifier {
  DefaultFarmerAddress? _selected;

  DefaultFarmerAddress? get selected => _selected;

  void setAddress(DefaultFarmerAddress address) {
    _selected = address;
    notifyListeners();
  }

  void clear() {
    _selected = null;
    notifyListeners();
  }
}
