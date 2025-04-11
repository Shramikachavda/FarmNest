import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/presentation/market_place_views/check_out.dart';
import 'package:agri_flutter/providers/market_place_provider/cart_provider.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../customs_widgets/custom_icon.dart';
import '../../providers/market_place_provider/product_provider.dart';
import '../../utils/navigation/navigation_utils.dart';
import 'detail_product_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
   Provider.of<CartProvider>(context, listen: false).fetchCart();
  }
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: themeColor(context: context).surface,
      appBar: CustomAppBar(title: "Cart Items"),
      body:
          cartProvider.cartItems.isEmpty
              ? Center(
                child: bodyText(
                  "No item in cart yet",
                ),
              )
              : Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartProvider.cartTotalItem,
                        itemBuilder: (context, index) {
                          final product = cartProvider.cartItems[index];
                          return Column(
                            children: [
                              ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  side: BorderSide(
                                    color: themeColor().outlineVariant,
                                    width: 2,
                                  ),
                                ),
                                title: bodyText(product.name),
                                onTap: () {

                                  final productProvider = context.read<ProductProvider>();
                                  productProvider.setDetailProduct(product.id);
                                  NavigationUtils.push(
                                    DetailProductView().buildRoute(),
                                  );
                                },

                                subtitle: Row(
                                  children: [
                                    // Decrease quantity
                                    customRoundIconButton(
                                      context: context,
                                      icon: Icons.remove,
                                      onPressed: () async {
                                        if (product.quantity == 1) {
                                          final shouldRemove = await showDialog<
                                            bool
                                          >(
                                            context: context,
                                            builder:
                                                (context) => AlertDialog(
                                                  title: bodyMediumText(
                                                    "Remove Item?",
                                                  ),
                                                  content: bodyText(
                                                    "Do you want to remove ${product.name} from the cart?",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                            false,
                                                          ),
                                                      child: bodyText("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                            true,
                                                          ),
                                                      child: bodyText("Remove"),
                                                    ),
                                                  ],
                                                ),
                                          );

                                          if (shouldRemove == true) {
                                            await cartProvider.removeCartItem(
                                              product,
                                            );

                                            showCustomSnackBar(
                                              context,
                                              "${product.name} removed from cart",
                                            );
                                          }
                                        } else {
                                          await cartProvider.decreaseQuantity(
                                            product,
                                          );
                                        }
                                      },
                                    ),

                                    //quantity
                                    Padding(
                                      padding: EdgeInsets.all(8.w),
                                      child: Text(
                                        '${product.quantity}',
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ),

                                    // Increase Quantity
                                    customRoundIconButton(
                                      context: context,
                                      icon: Icons.add,
                                      onPressed: () async {
                                        await cartProvider.increaseQuantity(
                                          product,
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                trailing: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Remove Item
                                    SizedBox(
                                      width: 30.w,
                                      height: 30.w,
                                      child: Center(
                                        child: IconButton(
                                          iconSize: 20.sp,
                                          onPressed: () {
                                            cartProvider.removeCartItem(
                                              product,
                                            );
                                          },
                                          icon: const Icon(Icons.cancel_sharp),
                                        ),
                                      ),
                                    ),
                                    // Product Total Price
                                    Text(
                                      "₹${cartProvider.getProductTotalPrice(product)}",
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Image.network(
                                    product.imageUrl,
                                    width: 60.w,
                                    height: 60.w,

                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h),
                            ],
                          );
                        },
                      ),
                    ),

                    // total price
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Total Cart Price
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              bodySemiLargeExtraBoldText("Total:"),
                              bodyText(
                                "₹ ${cartProvider.totalCartPrice.toDouble()}",
                              ),
                            ],
                          ),

                          SizedBox(width: 12.w),

                          Expanded(
                            child: CustomButton(
                              buttonName: 'Checkout',
                              onClick: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CheckoutView(),
                                  ),
                                );
                              },
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
