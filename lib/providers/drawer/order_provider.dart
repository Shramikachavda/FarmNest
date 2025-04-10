import 'package:flutter/cupertino.dart';
import 'package:agri_flutter/models/product.dart';

class OrderProvider with ChangeNotifier {
  // Order List
  final List<Product> _orderList = [];

  // Getter: List of all orders
  List<Product> get getOrderList => _orderList;

  // Add a product to the order
  void addOrder(Product product) {
    _orderList.add(product);
    notifyListeners();
  }

  // ✅ Get total quantity of all ordered items
  int get totalQuantity {
    return _orderList.fold(0, (sum, item) => sum + (item.quantity ?? 1));
  }

  // ✅ Get total price of all ordered items
  double get totalPrice {
    return _orderList.fold(
      0.0,
      (sum, item) => sum + ((item.price ?? 0.0) * (item.quantity ?? 1)),
    );
  }

  // Optional: Clear all orders (for after placing order)
  void clearOrders() {
    _orderList.clear();
    notifyListeners();
  }
}
