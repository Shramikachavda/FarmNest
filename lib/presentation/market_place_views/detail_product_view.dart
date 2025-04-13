import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/models/product.dart';
import 'package:agri_flutter/presentation/drawer/order_screen.dart';
import 'package:agri_flutter/providers/drawer/order_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/cart_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/favorite_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/product_provider.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../core/image.dart';
import '../../core/widgets/BaseStateFullWidget.dart';
import '../../customs_widgets/custom_icon.dart';

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
  void showSuccessAnimationAndNavigate(BuildContext context, Product product) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.addOrder(product);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DotLottieLoader.fromAsset(
                  'assets/animations/your_file.lottie',
                  frameBuilder: (context, composition) {
                    if (composition != null) {
                      return Lottie.memory(
                        composition.animations.values.single,
                        height: 400,
                        width: 500,
                      );
                    } else {
                      return Container(); // or a loading indicator if you want
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('❌ Failed to load .lottie animation');
                  },
                ),

                const Text(
                  "Order Placed Successfully!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
    );

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pop();
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => OrderScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    final product = Provider.of<ProductProvider>(context).selectedProduct;

    if (product == null) {
      return Center(child: Text("No product selected."));
    }

    print(product.name);
    print("detail page");

    return Scaffold(
      backgroundColor: themeColor(context: context).surface,
      appBar: CustomAppBar(title: product.name),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              [
                Container(
                  width: double.infinity,
                  height: 270.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: themeColor().outlineVariant,
                      width: 2,
                    ),

                    image: DecorationImage(
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    bodySemiLargeExtraBoldText(product.name),
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
                              : Icon(
                                Icons.favorite_border_outlined,
                                size: 24.sp,
                              ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    customRoundIconButton(
                      context: context,
                      icon: Icons.remove,
                      onPressed: () async {
                        await cartProvider.decreaseQuantity(product);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.r),
                      child: bodyText('${cartProvider.getQuantity(product)}'),
                    ),
                    customRoundIconButton(
                      context: context,
                      icon: Icons.add,
                      onPressed: () async {
                        await cartProvider.increaseQuantity(product);
                      },
                    ),
                    Spacer(),
                    SizedBox(height: 5.h),
                    Text(
                      "₹ ${cartProvider.getProductTotalPrice(product).toString()}",
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                bodyMediumBoldText("Product Description"),
                Text(
                  product.description,
                  style: TextStyle(color: themeColor().onSurfaceVariant),
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
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomButton(
                        onClick: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text("Confirm Purchase"),
                                  content: const Text(
                                    "Are you sure you want to buy this item now?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: const Text("Buy Now"),
                                    ),
                                  ],
                                ),
                          );

                          if (result == true) {
                            showSuccessAnimationAndNavigate(context, product);
                          }
                        },
                        buttonName: "Buy Now",
                      ),
                    ),
                  ],
                ),
              ].separator(SizedBox(height: 3.h)).toList(),
        ),
      ),
    );
  }
}
