// providers/drawer/order_provider.dart
import 'package:agri_flutter/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:agri_flutter/models/product.dart';

class OrderProvider with ChangeNotifier {
  final List<Product> _orderList = [];
  final FirestoreService _firestoreService = FirestoreService();

  List<Product> get getOrderList => _orderList;

  Future<void> fetchOrders(String userId) async {
    try {
      print("🔹 Fetching orders for User: $userId");
      final List<Map<String, dynamic>> firebaseOrders =
          await _firestoreService.getOrders();

      _orderList.clear();

      for (var orderMap in firebaseOrders) {
        // Process each product in the order
        final products = orderMap['products'] as List<dynamic>? ?? [];
        for (var productJson in products) {
          try {
            final product = Product.fromJson(
              productJson as Map<String, dynamic>,
            );
            _orderList.add(product);
          } catch (e, stackTrace) {
            print("❌ Error parsing product: $e, JSON: $productJson");
            print("Stack trace: $stackTrace");
          }
        }
      }

      print("✅ Fetched ${_orderList.length} products from orders.");
      notifyListeners();
    } catch (e, stackTrace) {
      print("❌ Failed to fetch orders: $e");
      print("Stack trace: $stackTrace");
    }
  }

  void addOrder(Product product) {
    _orderList.add(product);
    notifyListeners();
  }

  int get totalQuantity =>
      _orderList.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _orderList.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  void clearOrders() {
    _orderList.clear();
    notifyListeners();
  }
}
