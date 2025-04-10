import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/presentation/home_page_view/market_price_widget.dart';
import 'package:agri_flutter/providers/api_provider/marker_price_provider.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../core/widgets/BaseStateFullWidget.dart';
import '../customs_widgets/reusable.dart';

class SearchScreen extends BaseStatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/SearchScreen";

  @override
  String get routeName => route;
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _commodityController = TextEditingController();
  final FocusNode _focusNodeCommodity = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Consumer<MarkerPriceProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 1.h,) ,
                //search
                CustomFormField(
                  hintText: 'Enter Commodity (e.g., Potato)',
                  keyboardType: TextInputType.name,
                  label: 'Enter Commodity (e.g., Potato)',
                  textEditingController: _commodityController,
                  focusNode: _focusNodeCommodity,
                  textInputAction: TextInputAction.search,
                ),

                //search button
                CustomButton(onClick: (){
                  provider.loadFilteredPrices(
                    state: 'Gujarat', // Fixed to Gujarat
                    commodity:
                    _commodityController.text.isNotEmpty
                        ? _commodityController.text
                        : null,
                  );
                }, buttonName: "Search") ,

            if (provider.isLoading)
              const CircularProgressIndicator()


            else if (provider.errorMessage != null)
                  Text(provider.errorMessage!)
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.prices.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            MarketPriceCard(record: provider.prices[index]),
                            SizedBox(height: 12.h,)
                          ]
                        );
                      },
                    ),
                  ),
              ].separator(SizedBox(height: 24.h,)).toList()
            ),
          );
        },
      ),
    );
  }
}
