import 'package:agri_flutter/core/image.dart';
import 'package:agri_flutter/core/widgets/BaseStateFullWidget.dart';
import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_icon.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/models/product.dart';
import 'package:agri_flutter/presentation/drawer/order_screen.dart';
import 'package:agri_flutter/presentation/drawer/selected_address.dart';
import 'package:agri_flutter/providers/drawer/selected_address.dart';
import 'package:agri_flutter/providers/market_place_provider/cart_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/favorite_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/product_provider.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
  final FirestoreService _firestoreService = FirestoreService();

  void showSuccessAnimationAndNavigate(BuildContext context) {
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
                      return Container();
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

  Future<void> _placeOrder(Product product) async {
    final selectedAddressProvider = Provider.of<SelectedAddressProvider>(
      context,
      listen: false,
    );
    final address = selectedAddressProvider.selected;

    if (address == null) {
      showCustomSnackBar(context, "Please select an address");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SelectAddressScreen()),
      ).then((_) {
        // Retry order placement if address is selected
        if (selectedAddressProvider.selected != null) {
          _placeOrder(product);
        }
      });
      return;
    }

    try {
      // Create a list with the single product
      final products = [product];
      await _firestoreService.placeOrder(products, address);
      showSuccessAnimationAndNavigate(context);
    } catch (e) {
      showCustomSnackBar(context, "Failed to place order: $e");
    }
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
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                    bottom: Radius.circular(20.r),
                  ),
                  child:
                      product.imageUrl.isNotEmpty
                          ? Image.network(
                            product.imageUrl,
                            width: double.infinity,
                            height: 270.h,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color:
                                      themeColor(
                                        context: context,
                                      ).surfaceContainerHighest,
                                  width: double.infinity,
                                  height: 270.h,
                                  child: Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 60.w,
                                      color:
                                          themeColor(
                                            context: context,
                                          ).onSurfaceVariant,
                                    ),
                                  ),
                                ),
                          )
                          : Container(
                            color:
                                themeColor(
                                  context: context,
                                ).surfaceContainerHighest,
                            width: double.infinity,
                            height: 270.h,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50.w,
                                color:
                                    themeColor(
                                      context: context,
                                    ).onSurfaceVariant,
                              ),
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
                              ? Icon(Icons.favorite, size: 20.sp)
                              : Icon(
                                Icons.favorite_border_outlined,
                                size: 20.sp,
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
                  style: TextStyle(
                    color: themeColor(context: context).onSurfaceVariant,
                  ),
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
                            await _placeOrder(product);
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
