import 'package:agri_flutter/models/product.dart';
import 'package:agri_flutter/providers/market_place_provider/products.dart';

import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  Product? _selectedProduct;

  // Getter for selected product
  Product? get selectedProduct => _selectedProduct;

  // Get product in new page
  void setDetailProduct(String id, Products productsProvider) {
    try {
      _selectedProduct = productsProvider.products.firstWhere((product) => product.id == id);
      print(_selectedProduct?.id.toString());
      print(_selectedProduct?.name);
      print("provider value\n");
      notifyListeners();
    } catch (e) {
      print("Error setting detail product: $e");
      _selectedProduct = null; // Handle case where product is not found
      notifyListeners();
    }
  }
}