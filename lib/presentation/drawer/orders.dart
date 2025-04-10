import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';

class Order extends StatelessWidget {
  const Order({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor().surface,
      body:  Center(child: Text("orders")),
    );
  }
}
