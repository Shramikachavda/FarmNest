import 'package:agri_flutter/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  // Fetch products from Firestore without modifying the model
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('products').get();


      _products =
          snapshot.docs.map((doc) {
            final data = doc.data();

            return Product(
              id: doc.id,
              name: data['name'] ?? '',
              category: data['category'] ?? '',
              description: data['description'] ?? '',
              imageUrl: data['imageUrl'] ?? '',
              price: (data['price'] ?? 0).toDouble(),
            );
          }).toList();

      _isLoading = false;

      notifyListeners();
    } catch (error) {
      print("Error fetching products: $error");
      rethrow;
    }
  }
}
