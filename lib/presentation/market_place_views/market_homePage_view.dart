import 'dart:async';
import 'package:agri_flutter/customs_widgets/custom_choice_chip.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/data/product.dart';
import 'package:agri_flutter/models/product.dart';
import 'package:agri_flutter/providers/market_place_provider/cart_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/favorite_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/product_provider.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
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

            // Category Chips
            SizedBox(
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
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                        ),
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];

                          return InkWell(
                            onTap: () {
                              productProvider.setDetailProduct(product.id);

                              print(product.id);
                              print(product.name);

                              print("marke price page\n");
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
                                  color: themeColor().outlineVariant,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    [
                                      // Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20.r),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          height: 120.h,
                                          decoration: BoxDecoration(
                                            color: themeColor(context: context).surface,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                product.imageUrl,
                                              ),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
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
                                            Text(
                                              '₹${product.price}',
                                              style: TextStyle(fontSize: 14.sp),
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
                                                if (cartProvider
                                                    .isProductInCart(product)) {
                                                  await cartProvider
                                                      .increaseQuantity(
                                                        product,
                                                      );
                                                  showCustomSnackBar(
                                                    context,
                                                    'Quantity increased',
                                                  );
                                                  /*    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Item added to cart'),
                                          action: SnackBarAction(
                                            label: 'View Cart',
                                            onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (_) => CartView()));
                                            },
                                          ),
                                        ),
                                      );*/
                                                } else {
                                                  await cartProvider
                                                      .addCartItem(product);
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
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
