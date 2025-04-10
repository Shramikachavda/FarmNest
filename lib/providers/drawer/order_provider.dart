import 'package:agri_flutter/models/product.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier {

  //order list
  List<Product> _orderList =  [];

  //get order list
  List<Product> get getOrderList => _orderList;

  //add order
  void addOrder(Product product){
    _orderList.add(product);
    notifyListeners();
  }

}