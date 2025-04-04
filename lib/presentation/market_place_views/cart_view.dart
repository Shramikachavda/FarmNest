
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/providers/market_place_provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Cart", style: TextStyle(fontSize: 22.sp))),
      body:
          cartProvider.cartItems.isEmpty
              ? Center(
                child: Text(
                  "No item in cart yet",
                  style: TextStyle(fontSize: 16.sp),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProvider.cartTotalItem,
                      itemBuilder: (context, index) {
                        final product = cartProvider.cartItems[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: ListTile(
                            title: Text(
                              product.name,
                              style: TextStyle(fontSize: 14.sp),
                            ),

                            subtitle: Row(
                              children: [
                                // ➖ Decrease Quantity
                                InkWell(
                                  onTap: () {
                                    cartProvider.decreaseQuantity(product);
                                  },
                                  child: Container(
                                    height: 30.w,
                                    width: 30.w,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.remove),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.w),
                                  child: Text(
                                    '${product.quantity}',
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ),
                                // ➕ Increase Quantity
                                InkWell(
                                  onTap: () {
                                    cartProvider.increaseQuantity(product);
                                  },
                                  child: Container(
                                    height: 30.w,
                                    width: 30.w,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(child: Icon(Icons.add)),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // ❌ Remove Item
                                SizedBox(
                                  width: 30.w,
                                  height: 30.w,
                                  child: Center(
                                    child: IconButton(
                                      iconSize: 18.sp,
                                      onPressed: () {
                                        cartProvider.removeCartItem(product);
                                      },
                                      icon: const Icon(Icons.cancel),
                                    ),
                                  ),
                                ),
                                // 💰 Product Total Price
                                Text(
                                  "₹${cartProvider.getProductTotalPrice(product)}",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ],
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                product.imageUrl,
                                width: 60.w,
                                height: 60.w,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // 🛒 Total Price & Buy Button
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Total Cart Price
                        Column(
                          children: [
                            Text("Total:", style: TextStyle(fontSize: 16.sp)),
                            Text(
                              "₹ ${cartProvider.totalCartPrice.toDouble()}",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        // 🛒 Buy Button
                        Expanded(
                          child: CustomButton(
                            buttonName: 'Checkout',
                            onClick: () {
                              // Handle Checkout
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
