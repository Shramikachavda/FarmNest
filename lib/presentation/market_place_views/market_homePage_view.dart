import 'dart:async';
import 'package:agri_flutter/customs_widgets/custom_choice_chip.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/models/product.dart';
import 'package:agri_flutter/providers/market_place_provider/cart_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/favorite_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/product_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/products.dart';
import 'package:agri_flutter/services/firestore.dart';

import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/presentation/market_place_views/cart_view.dart';
import 'package:agri_flutter/presentation/market_place_views/detail_product_view.dart';
import 'package:agri_flutter/presentation/market_place_views/favorite_view.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/BaseStateFullWidget.dart';
import '../../customs_widgets/custom_icon.dart';
import '../../data/choice_chips_value.dart';
import '../../providers/category_provider.dart';

class MarketHomepageView extends BaseStatefulWidget {
  const MarketHomepageView({super.key});

  @override
  State<MarketHomepageView> createState() => _MarketHomepageViewState();

  @override
  Route buildRoute() => materialRoute();

  static const String route = "/MarketHomepageView";

  @override
  String get routeName => route;
}

class _MarketHomepageViewState extends State<MarketHomepageView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNodeSearch = FocusNode();
  String selectedCategory = "";
  List<Product> _filteredProducts = [];
  Timer? _debounce;



  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productsProvider = Provider.of<Products>(context, listen: false);
      productsProvider.fetchProducts().then((_) {
        setState(() {
          _filteredProducts = productsProvider.products;
        });
      }).catchError((error) {
        showCustomSnackBar(context, 'Failed to load products: $error');
      });
    });

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
    final productsProvider = Provider.of<Products>(context, listen: false);
    setState(() {
      query = query.toLowerCase().trim();
      if (query.isEmpty && selectedCategory.isEmpty) {
        _filteredProducts = productsProvider.products;
      } else {
        _filteredProducts =
            productsProvider.products.where((product) {
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
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: themeColor(context: context).surface,
      appBar: AppBar(
        title: bodyMediumText("Market place"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, size: 20.sp),
            onPressed:
                () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => CartView())),
          ),
          IconButton(
            icon: Icon(Icons.favorite_border, size: 20.sp),
            onPressed:
                () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => FavoriteView())),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 12.h),
        child: Column(
          children: [
            // Search Field
            CustomFormField(
              focusNode: _focusNodeSearch,
              textInputAction: TextInputAction.done,
              hintText: 'Product Name/Category',
              keyboardType: TextInputType.text,
              label: 'Search Store',
              textEditingController: _searchController,
              icon: Icon(Icons.search, size: 20.sp),
            ),

            Consumer<CategoryProvider>(
              builder: (context, category, child) {
                final categories = category.CategotyList;
                if (categories.isEmpty) {
                  return Center(child: bodyText("No categories found."));
                }

                return SizedBox(
                  height: 70.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final label = categories[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: customChoiceChip(
                          label: label,
                          selectedCategory: selectedCategory,
                          onSelected: filterProducts,
                          context: context,
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            // Product Grid
            Expanded(
              child: Consumer<Products>(
                builder: (context, productsProvider, child) {
                  if (productsProvider.isLoading) {
                    return showLoading(context);
                  }

                  if (productsProvider.products.isEmpty) {
                    bodyText("No products found.");
                  }
                  if (_filteredProducts.isEmpty) {
                    bodyText("No products found.");
                  }

                  return GridView.builder(
                    itemCount: _filteredProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                    ),
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];

                      return InkWell(
                        onTap: () {
                          productProvider.setDetailProduct(
                            product.id,
                            productsProvider,
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DetailProductView(),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            side: BorderSide(
                              color:
                                  themeColor(context: context).outlineVariant,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.r),
                                    ),
                                    child:
                                        product.imageUrl.isNotEmpty
                                            ? Image.network(
                                              product.imageUrl,
                                              width: double.infinity,
                                              height: 100.h,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Container(
                                                    color:
                                                        themeColor(
                                                          context: context,
                                                        ).surfaceContainerHighest,
                                                    width: double.infinity,
                                                    height: 100.h,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported,
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
                                              height: 100.h,
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

                                  // Image
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                    ),
                                    child: bodyText(product.name),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                    ),
                                    child: captionStyleText(
                                      product.description,
                                    ),
                                  ),
                                  // Price and Buttons
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        smallText(
                                          '₹${product.price.toStringAsFixed(2)}',
                                        ),
                                        customRoundIconButton(
                                          context: context,
                                          icon:
                                              favoriteProvider.isFavorite(
                                                    product,
                                                  )
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                          onPressed: () async {
                                            final isFav = favoriteProvider
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
                                        ),
                                        customRoundIconButton(
                                          context: context,
                                          icon: Icons.add,
                                          onPressed: () async {
                                            if (cartProvider.isProductInCart(
                                              product,
                                            )) {
                                              await cartProvider
                                                  .increaseQuantity(product);
                                              showCustomSnackBar(
                                                context,
                                                'Quantity increased',
                                              );
                                            } else {
                                              await cartProvider.addCartItem(
                                                product,
                                              );
                                              showCustomSnackBar(
                                                context,
                                                'Item added to cart',
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ].separator(SizedBox(height: 5.h)).toList(),
                          ),
                        ),
                      );
                    },
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
