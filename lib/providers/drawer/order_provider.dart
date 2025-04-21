
import 'package:agri_flutter/models/order_model.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orderList = [];
  final FirestoreService _firestoreService = FirestoreService();

  List<Order> get getOrderList => _orderList;

  Future<void> fetchOrders(String userId) async {
    try {
      print("🔹 Fetching orders for User: $userId");
      final List<Map<String, dynamic>> firebaseOrders =
          await _firestoreService.getOrders(userId: userId);

      _orderList.clear();

      for (var orderMap in firebaseOrders) {
        try {
          final order = Order.fromJson(orderMap);
          _orderList.add(order);
        } catch (e, stackTrace) {
          print("❌ Error parsing order: $e, JSON: $orderMap");
          print("Stack trace: $stackTrace");
        }
      }

      print("✅ Fetched ${_orderList.length} orders.");
      notifyListeners();
    } catch (e, stackTrace) {
      print("❌ Failed to fetch orders: $e");
      print("Stack trace: $stackTrace");
    }
  }

  int get totalQuantity => _orderList.fold(
        0,
        (sum, order) => sum + order.products.fold(0, (s, p) => s + p.quantity),
      );

  double get totalPrice =>
      _orderList.fold(0.0, (sum, order) => sum + order.total);

  void clearOrders() {
    _orderList.clear();
    notifyListeners();
  }
}