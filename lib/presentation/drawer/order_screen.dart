import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/providers/drawer/order_provider.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:agri_flutter/models/product.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.getOrderList;

    return Scaffold(
      backgroundColor: themeColor(context: context).surface,
      appBar: CustomAppBar(title: "Your Orders"),
      body: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 12.h),
        child: orders.isEmpty
            ? const Center(
                child: Text(
                  "No orders placed yet.",
                  style: TextStyle(fontSize: 16),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final product = orders[index];
                        final int qty = product.quantity ?? 1;
                        final double price = product.price ?? 0.0;
                        final double total = qty * price;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // product image
                                if (product.imageUrl != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      product.imageUrl!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                const SizedBox(width: 16),
                                // product details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "₹${price.toStringAsFixed(2)} x $qty = ₹${total.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // ✅ Optional: Total Summary at Bottom
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Quantity: ${orderProvider.totalQuantity}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Total: ₹${orderProvider.totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
