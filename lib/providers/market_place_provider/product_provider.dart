import 'package:agri_flutter/data/product.dart';
import 'package:agri_flutter/models/product.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = ProductData.products;
  Product? _selectedProduct;

  //getteer of product
  List<Product> get products => _products;

  Product? get selectedProduct => _selectedProduct;

  //get product in new page
  void setDetailProduct(String id) {
    _selectedProduct = _products.firstWhere((product) => product.id == id);
    print(_selectedProduct?.id.toString());   print(_selectedProduct?.name);
    print("provider value\n");
    notifyListeners();
  }
}
