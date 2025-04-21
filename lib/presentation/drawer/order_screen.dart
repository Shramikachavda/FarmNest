import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';

import 'package:agri_flutter/providers/drawer/order_provider.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      orderProvider.fetchOrders(userId).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.getOrderList;

    return Scaffold(
      backgroundColor: themeColor(context: context).surface,
      appBar: CustomAppBar(title: "Your Orders"),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text("No orders placed yet."))
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: orders.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final order = orders[index];

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                side: BorderSide(
                                  color: themeColor(context: context)
                                      .outlineVariant,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    bodyText('Order ID: ${order.id}'),
                                    SizedBox(height: 8.h),
                                    captionStyleText(
                                      color: themeColor(context: context).primary,
                                      'Status: ${order.status}',
                                    ),
                                    captionStyleText(
                                      color:
                                          themeColor(context: context).onSurface,
                                      'Date: ${order.timestamp?.toString().substring(0, 10) ?? "Pending"}',
                                    ),
                                    SizedBox(height: 8.h),
                                    ...order.products.map((product) => Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              child: product.imageUrl.isNotEmpty
                                                  ? Image.network(
                                                      product.imageUrl,
                                                      width: 60.w,
                                                      height: 60.h,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) =>
                                                          Icon(
                                                        Icons.image_not_supported,
                                                        size: 60.w,
                                                        color: themeColor(
                                                                context:
                                                                    context)
                                                            .onSurfaceVariant,
                                                      ),
                                                    )
                                                  : Icon(
                                                      Icons.image_not_supported,
                                                      size: 60.w,
                                                      color: themeColor(
                                                              context: context)
                                                          .onSurfaceVariant,
                                                    ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  bodyText(product.name),
                                                  SizedBox(height: 4.h),
                                                  captionStyleText(
                                                    color: themeColor(
                                                            context: context)
                                                        .primary,
                                                    '₹${product.price.toStringAsFixed(2)} x ${product.quantity} = ₹${(product.price * product.quantity).toStringAsFixed(2)}',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    SizedBox(height: 8.h),
                                    bodyText(
                                        'Total: ₹${order.total.toStringAsFixed(2)}'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
    );
  }
}