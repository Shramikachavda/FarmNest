import 'dart:async';
import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/providers/market_place_provider/favorite_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/product_provider.dart';
import 'package:agri_flutter/presentation/market_place_views/detail_product_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/widgets/BaseStateFullWidget.dart';
import '../../customs_widgets/reusable.dart';
import '../../theme/theme.dart';

class FavoriteView extends BaseStatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/FavoriteView";

  @override
  String get routeName => route;
}

class _FavoriteViewState extends State<FavoriteView> {
  //textEditingController
  final TextEditingController _searchController = TextEditingController();

  //focusNode
  final FocusNode _focusNodeSearch = FocusNode();
  List<dynamic> _filteredFavorites = [];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final favoriteProvider = Provider.of<FavoriteProvider>(
      context,
      listen: false,
    );
    _filteredFavorites =
        favoriteProvider.favoriteList; // Load all favorite products initially

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
    final favoriteProvider = Provider.of<FavoriteProvider>(
      context,
      listen: false,
    );

    setState(() {
      query = query.toLowerCase().trim();

      if (query.isEmpty) {
        _filteredFavorites = favoriteProvider.favoriteList;
      } else {
        _filteredFavorites =
            favoriteProvider.favoriteList.where((product) {
              return product.name.toLowerCase().contains(query) ||
                  product.category.toLowerCase().contains(query);
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final selectedProd = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: "Favorites"),
      body: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.h),
        child: Column(
          children: [

            CustomFormField(
              focusNode: _focusNodeSearch,
              textInputAction: TextInputAction.done,
              hintText: 'Product Name/Category',
              keyboardType: TextInputType.text,
              label: 'Search Store',
              textEditingController: _searchController,
              icon: const Icon(Icons.search),
            ),
            SizedBox(height: 10.h),

            Expanded(
              child:
                  _filteredFavorites.isEmpty
                      ? Center(
                        child: Text(
                          "No products found.",
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      )
                      : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.80,
                          crossAxisSpacing: 8.w,
                          mainAxisSpacing: 8.h,
                        ),
                        itemCount: _filteredFavorites.length,
                        itemBuilder: (context, index) {
                          final favoriteProduct = _filteredFavorites[index];
                          return InkWell(
                            onTap: () {
                              selectedProd.setDetailProduct(favoriteProduct.id);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailProductView(),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 120.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.r),
                                        topRight: Radius.circular(12.r),
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          favoriteProduct.imageUrl,
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.w),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            favoriteProvider.removeFavorite(
                                              favoriteProduct,
                                            );
                                            //  _filterFavorites(); // Re-filter after removal
                                          },
                                          child: Container(
                                            height: 30.w,
                                            width: 30.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: themeColor(context: context).primary,
                                            ),
                                            child: Icon(
                                              Icons.favorite,
                                              size: 20.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: bodyText(favoriteProduct.name),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    child: captionStyleText(
                                      favoriteProduct.description,
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        captionStyleText(favoriteProduct.category , color: themeColor(context: context).primary) ,
                                        bodyText( "₹${favoriteProduct.price}",)


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
