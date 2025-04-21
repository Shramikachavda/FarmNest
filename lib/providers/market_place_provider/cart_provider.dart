import 'dart:developer';
import 'package:agri_flutter/models/product.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final List<Product> _cartList = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CartProvider() {
    fetchCart(); // Load cart on init
  }

  List<Product> get cartItems => _cartList;
  int get cartTotalItem => _cartList.length;
  String get userId => _auth.currentUser?.uid ?? '';

  // 🔄 Fetch cart from Firestore
  Future<void> fetchCart() async {
    try {
      final cartItems = await _firestoreService.getCart();
      _cartList.clear();
      _cartList.addAll(cartItems);
      notifyListeners();
    } catch (e) {
      log("❌ Error fetching cart: $e");
    }
  }

  // ➕ Add to cart
  Future<void> addCartItem(Product product) async {
    try {
      final existingIndex = _cartList.indexWhere((item) => item.id == product.id);

      if (existingIndex != -1) {
        // Already exists → increase quantity
        await increaseQuantity(_cartList[existingIndex]);
      } else {
        // Add fresh product with quantity = 1
        final newProduct = product.copyWith(quantity: 1);
        await _firestoreService.addToCart(newProduct);
        _cartList.add(newProduct);
        notifyListeners();
      }
    } catch (e) {
      log("❌ Error adding to cart: $e");
    }
  }

  // ❌ Remove from cart
  Future<void> removeCartItem(Product product) async {
    try {
      await _firestoreService.removeFromCart(product.id);
      _cartList.removeWhere((item) => item.id == product.id);
      notifyListeners();
    } catch (e) {
      log("❌ Error removing from cart: $e");
    }
  }

  // 🔼 Increase quantity
  Future<void> increaseQuantity(Product product) async {
    try {
      final index = _cartList.indexWhere((item) => item.id == product.id);
      if (index != -1) {
        _cartList[index].quantity++;
        await _firestoreService.updateCartItemQuantity(
          userId,
          product.id,
          _cartList[index].quantity,
        );
        notifyListeners();
      }
    } catch (e) {
      log("❌ Error increasing quantity: $e");
    }
  }

  // 🔽 Decrease quantity
  Future<void> decreaseQuantity(Product product) async {
    try {
      final index = _cartList.indexWhere((item) => item.id == product.id);

      if (index != -1) {
        if (_cartList[index].quantity > 1) {
          _cartList[index].quantity--;
          await _firestoreService.updateCartItemQuantity(
            userId,
            product.id,
            _cartList[index].quantity,
          );
          notifyListeners();
        } else {
          await removeCartItem(product);
        }
      }
    } catch (e) {
      log("❌ Error decreasing quantity: $e");
    }
  }

  // 💰 Total price
  double get totalCartPrice {
    return _cartList.fold(
      0,
          (sum, product) => sum + (product.price * product.quantity),
    );
  }

  // 💵 Price for a specific product
  double getProductTotalPrice(Product product) {
    return product.price * product.quantity;
  }

  // ❎ Clear cart
  Future<void> clearCart() async {
    try {
      await _firestoreService.clearCart(userId);
      _cartList.clear();
      notifyListeners();
    } catch (e) {
      log("❌ Error clearing cart: $e");
    }
  }

  // 🔍 Check if in cart
  bool isProductInCart(Product product) {
    return _cartList.any((item) => item.id == product.id);
  }

  // 🔢 Get quantity of a product
  int getQuantity(Product product) {
    final index = _cartList.indexWhere((item) => item.id == product.id);
    return index != -1 ? _cartList[index].quantity : 1;
  }
}
