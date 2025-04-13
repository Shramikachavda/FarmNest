import 'package:agri_flutter/models/product.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final List<Product> _cartList = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CartProvider() {
    fetchCart(); // Fetch cart on initialization
  }
  // ✅ Get cart list
  List<Product> get cartItems => _cartList;
  int get cartTotalItem => _cartList.length;
  String get userId => _auth.currentUser?.uid ?? '';

  // **Fetch Cart Items**
  Future<void> fetchCart() async {
    try {
      print("🔹 Fetching cart items from Firestore...");
      final cartItems = await _firestoreService.getCart();

      _cartList.clear();
      _cartList.addAll(cartItems);
      notifyListeners();

      print("✅ Cart updated! Total items: ${_cartList.length}");
    } catch (e) {
      print("❌ Error fetching cart: $e");
    }
  }

  // **Add to Cart**
  Future<void> addCartItem(Product product) async {
    try {
      // Find product in cart (if exists)
      final existingIndex = _cartList.indexWhere(
        (item) => item.id == product.id,
      );

      if (existingIndex != -1) {
        // Product already exists, increase its quantity
        await increaseQuantity(_cartList[existingIndex]);
      } else {
        // 👇 Make sure quantity is set to 1 explicitly
        final newProduct = product.copyWith(quantity: 1);
        await _firestoreService.addToCart(newProduct);
        _cartList.add(newProduct);
        notifyListeners();
        print("✅ Product added to cart: ${newProduct.id}");
      }
    } catch (e) {
      print("❌ Error adding to cart: $e");
    }
  }

  // **Remove from Cart**
  Future<void> removeCartItem(Product product) async {
    try {
      print("🔹 Removing from cart: ${product.id}");
      await _firestoreService.removeFromCart(product.id);

      _cartList.removeWhere((item) => item.id == product.id);
      notifyListeners();
      print("✅ Product removed from cart: ${product.id}");
    } catch (e) {
      print("❌ Error removing from cart: $e");
    }
  }

  // **Increase quantity**

  Future<void> increaseQuantity(Product product) async {
    try {
      final index = _cartList.indexWhere((item) => item.id == product.id);

      if (index != -1) {
        // ✅ Product already in cart → increase quantity
        _cartList[index].quantity++;

        await _firestoreService.updateCartItemQuantity(
          userId,
          _cartList[index].id,
          _cartList[index].quantity,
        );

        notifyListeners();
        print(
          "✅ Quantity increased: ${_cartList[index].name}, New quantity: ${_cartList[index].quantity}",
        );
      } else {
        // 🆕 Product not in cart → add to cart with quantity 1
        final newProduct = product.copyWith(quantity: 1);

        _cartList.add(newProduct);

        await _firestoreService.addToCart(newProduct);

        notifyListeners();
        print("🛒 Product added to cart: ${newProduct.name}");
      }
    } catch (e) {
      print("❌ Error increasing quantity: $e");
    }
  }

  // **Decrease quantity**
  Future<void> decreaseQuantity(Product product) async {
    try {
      final index = _cartList.indexWhere((item) => item.id == product.id);

      if (index != -1) {
        if (_cartList[index].quantity > 1) {
          // ✅ Decrease quantity
          _cartList[index].quantity--;

          // ✅ Update Firestore
          await _firestoreService.updateCartItemQuantity(
            userId,
            _cartList[index].id,
            _cartList[index].quantity,
          );

          notifyListeners();
          print(
            "✅ Quantity decreased: ${product.name}, New quantity: ${_cartList[index].quantity}",
          );
        } else {
          // ✅ If quantity is 1, remove the item from cart
          await removeCartItem(_cartList[index]);
          print("🗑 Product removed from cart: ${product.name}");
        }
      } else {
        print(
          "🚨 Cannot decrease quantity. Product not in cart: ${product.name}",
        );
      }
    } catch (e) {
      print("❌ Error decreasing quantity: $e");
    }
  }

  // ✅ **Total price**
  double get totalCartPrice {
    double total = _cartList.fold(
      0,
      (sum, product) => sum + (product.price * product.quantity),
    );
    print("🛒 Total Cart Price: $total");
    return total;
  }

  // ✅ **Get total price for a specific product**
  double getProductTotalPrice(Product product) {
    double totalPrice = product.price * product.quantity;
    print("🛒 Total price for ${product.name}: $totalPrice");
    return totalPrice;
  }

  // ✅ **Clear Cart**
  Future<void> clearCart() async {
    try {
      print("🔹 Clearing cart for user: $userId");
      await _firestoreService.clearCart(userId);

      _cartList.clear();
      notifyListeners();
      print("✅ Cart cleared successfully.");
    } catch (e) {
      print("❌ Error clearing cart: $e");
    }
  }

  // ✅ **Check if a product is in the cart**
  bool isProductInCart(Product product) {
    return _cartList.any((item) => item.id == product.id);
  }

  int getQuantity(Product product) {
    final index = _cartList.indexWhere((item) => item.id == product.id);
    return index != -1 ? _cartList[index].quantity : 1;
  }
}
