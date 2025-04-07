import 'package:agri_flutter/customs_widgets/custom_choice_chip.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/data/product.dart';
import 'package:agri_flutter/models/product.dart';
import 'package:agri_flutter/providers/market_place_provider/cart_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/favorite_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/product_provider.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/presentation/market_place_views/cart_view.dart';
import 'package:agri_flutter/presentation/market_place_views/detail_product_view.dart';
import 'package:agri_flutter/presentation/market_place_views/favorite_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import '../../core/widgets/BaseStateFullWidget.dart';

class MarketHomepageView extends BaseStatefulWidget {
  const MarketHomepageView({super.key});

  @override
  State<MarketHomepageView> createState() => _MarketHomepageViewState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/MarketHomepageView";

  @override
  String get routeName => route;
}

class _MarketHomepageViewState extends State<MarketHomepageView> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = "";
  List<Product> _filteredProducts = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _filteredProducts = ProductData.products;

    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        searchProducts(_searchController.text);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void searchProducts(String query) {
    setState(() {
      query = query.toLowerCase().trim();

      if (query.isEmpty && selectedCategory.isEmpty) {
        _filteredProducts = ProductData.products;
      } else {
        _filteredProducts =
            ProductData.products.where((product) {
              final nameMatch = product.name.toLowerCase().contains(query);
              final categoryMatch = product.category.toLowerCase().contains(
                query,
              );
              final categoryFilter =
                  selectedCategory.isEmpty ||
                  product.category == selectedCategory;
              return (nameMatch || categoryMatch) && categoryFilter;
            }).toList();
      }
    });
  }

  void filterProducts(String category) {
    setState(() {
      selectedCategory = category;
      searchProducts(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => CartView()));
            },
            icon: Icon(Icons.shopping_cart_outlined, size: 24.sp),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => FavoriteView()));
            },
            icon: Icon(Icons.favorite_border, size: 24.sp),
          ),
        ],
        title: Text("Market", style: TextStyle(fontSize: 20.sp)),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 12.w),
        child: Column(
          children: [
            // Search Field
            CustomFormField(
              hintText: 'Product Name/Category',
              keyboardType: TextInputType.text,
              label: 'Search Store',
              textEditingController: _searchController,
              icon: Icon(Icons.search, size: 22.sp),
            ),

            // Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  customChoiceChip(
                    label: 'Seeds',
                    selectedCategory: selectedCategory,
                    onSelected: filterProducts,
                  ),
                  customChoiceChip(
                    label: 'Fertilizer',
                    selectedCategory: selectedCategory,
                    onSelected: filterProducts,
                  ),
                  customChoiceChip(
                    label: 'Pesticide',
                    selectedCategory: selectedCategory,
                    onSelected: filterProducts,
                  ),
                  customChoiceChip(
                    label: 'Vehicles',
                    selectedCategory: selectedCategory,
                    onSelected: filterProducts,
                  ),
                  customChoiceChip(
                    label: 'Irrigation Supplies',
                    selectedCategory: selectedCategory,
                    onSelected: filterProducts,
                  ),
                  customChoiceChip(
                    label: 'Storage & Packaging',
                    selectedCategory: selectedCategory,
                    onSelected: filterProducts,
                  ),
                ],
              ),
            ),

            // Product Grid
            Expanded(
              child:
                  _filteredProducts.isEmpty
                      ? Center(
                        child: Text(
                          "No products found.",
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      )
                      : GridView.builder(
                        itemCount: _filteredProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 8.w,
                          mainAxisSpacing: 8.h,
                        ),
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];

                          return InkWell(
                            onTap: () {
                              productProvider.setDetailProduct(product.id);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailProductView(),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15.r),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height: 100.h,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(product.imageUrl),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      product.name,
                                      style: TextStyle(fontSize: 14.sp),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    child: Text(
                                      product.description,
                                      style: TextStyle(fontSize: 12.sp),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '₹${product.price}',
                                          style: TextStyle(fontSize: 14.sp),
                                        ),

                                        Container(
                                          width: 35.w,
                                          height: 35.w,
                                          decoration: BoxDecoration(
                                            color:
                                                themeColor().secondaryContainer,
                                            borderRadius: BorderRadius.circular(
                                              40.r,
                                            ), // Rounded corners
                                          ),
                                          child: Center(
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () async {
                                                bool isFav = favoriteProvider
                                                    .isFavorite(product);

                                                if (isFav) {
                                                  await favoriteProvider
                                                      .removeFavorite(product);
                                                  showCustomSnackBar(
                                                    context,
                                                    'Item removed from favorite list',
                                                  );
                                                } else {
                                                  await favoriteProvider
                                                      .addFavorite(product);
                                                  showCustomSnackBar(
                                                    context,
                                                    'Item added to favorite list',
                                                  );
                                                }
                                              },
                                              icon:
                                                  favoriteProvider.isFavorite(
                                                        product,
                                                      )
                                                      ? Icon(
                                                        Icons.favorite,
                                                        size: 24.sp,
                                                      )
                                                      : Icon(
                                                        Icons.favorite_border,
                                                        size: 24.sp,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 35.w,
                                          height: 35.w,
                                          decoration: BoxDecoration(
                                            color:
                                                themeColor().secondaryContainer,
                                            borderRadius: BorderRadius.circular(
                                              40.r,
                                            ), // Rounded corners
                                          ),
                                          child: Center(
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () async {
                                                cartProvider.isProductInCart(
                                                      product,
                                                    )
                                                    ? await cartProvider
                                                        .removeCartItem(product)
                                                    : await cartProvider
                                                        .addCartItem(product);

                                                cartProvider.isProductInCart(
                                                      product,
                                                    )
                                                    ? showCustomSnackBar(
                                                      context,

                                                      'Item removed from cart',
                                                    )
                                                    : showCustomSnackBar(
                                                      context,
                                                      'Item added to cart',
                                                    );
                                              },
                                              icon:
                                                  cartProvider.isProductInCart(
                                                        product,
                                                      )
                                                      ? Icon(
                                                        Icons.remove,
                                                        size: 24.sp,
                                                      )
                                                      : Icon(
                                                        Icons.add,
                                                        size: 24.sp,
                                                      ),
                                            ),
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
          ],
        ),
      ),
    );
  }
}
