import 'package:agri_flutter/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser?.uid ?? '';

  // **Place Order - Move items from Cart to Orders**
  Future<void> placeOrder(List<Product> cartItems) async {
    try {
      if (cartItems.isEmpty) return;

      final orderId = _db.collection('users').doc(userId).collection('orders').doc().id;

      await _db.collection('users').doc(userId).collection('orders').doc(orderId).set({
        'orderId': orderId,
        'orderDate': DateTime.now().toIso8601String(),
        'products': cartItems.map((product) => product.toMap()).toList(),
      });

      // Clear cart after placing order
      for (var product in cartItems) {
        await _db.collection('users').doc(userId).collection('cart').doc(product.id).delete();
      }

      notifyListeners();
    } catch (e) {
      print("Error placing order: $e");
    }
  }

  // **Fetch Orders**
  Future<List<Map<String, dynamic>>> fetchOrders() async {
    try {
      final snapshot = await _db.collection('users').doc(userId).collection('orders').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }
}
