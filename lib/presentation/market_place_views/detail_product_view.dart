import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/providers/market_place_provider/cart_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/favorite_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/product_provider.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/BaseStateFullWidget.dart';

class DetailProductView extends BaseStatefulWidget {
  const DetailProductView({super.key});

  @override
  State<DetailProductView> createState() => _DetailProductViewState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/DetailProductView";

  @override
  String get routeName => route;
}

class _DetailProductViewState extends State<DetailProductView> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    // ✅ Fetch the latest version of the product from CartProvider
    final product = cartProvider.cartItems.firstWhere(
      (item) => item.id == cartProvider.cartItems.first.id,
      orElse: () => Provider.of<ProductProvider>(context).selectedProduct!,
    );

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align items to the start
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 270.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    favoriteProvider.isFavorite(product)
                        ? favoriteProvider.removeFavorite(product)
                        : favoriteProvider.addFavorite(product);
                    showCustomSnackBar(
                      context,
                      favoriteProvider.isFavorite(product)
                          ? 'Item added to favorite list'
                          : 'Item removed from favorite list',
                    );
                  },
                  icon:
                      favoriteProvider.isFavorite(product)
                          ? Icon(Icons.favorite, size: 24.sp)
                          : Icon(Icons.favorite_outline, size: 24.sp),
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    cartProvider.decreaseQuantity(product);
                  },
                  child: Container(
                    height: 27.h,
                    width: 27.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeColor(context: context).primary,
                    ),
                    child: Center(child: Icon(Icons.remove, size: 24.sp)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.r),
                  child: Text(
                    '${product.quantity}', // ✅ Now dynamically updates
                  ),
                ),
                InkWell(
                  onTap: () {
                    cartProvider.increaseQuantity(product);
                  },
                  child: Container(
                    height: 27.h,
                    width: 27.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeColor(context: context).primary,
                    ),
                    child: Center(child: Icon(Icons.add, size: 24.sp)),
                  ),
                ),
                Spacer(),
                SizedBox(height: 5.h),
                Text(
                  "₹ ${cartProvider.getProductTotalPrice(product).toString()}",
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Text(
              "Product Description",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              product.description,
              style: TextStyle(color: themeColor(context: context).surfaceContainerHighest),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onClick: () {
                      cartProvider.addCartItem(product);
                      showCustomSnackBar(context, "Product added to cart");
                    },
                    buttonName: "Add to cart",
                  ),
                ),
                Expanded(
                  child: CustomButton(onClick: () {}, buttonName: "Buy Now"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
