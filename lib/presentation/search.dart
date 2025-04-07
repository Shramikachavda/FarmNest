import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/presentation/home_page_view/market_price_widget.dart';
import 'package:agri_flutter/providers/api_provider/marker_price_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/widgets/BaseStateFullWidget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Consumer<MarkerPriceProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                  controller: _commodityController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Commodity (e.g., Potato)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  provider.loadFilteredPrices(
                    state: 'Gujarat', // Fixed to Gujarat
                    commodity:
                    _commodityController.text.isNotEmpty
                        ? _commodityController.text
                        : null,
                  );
                },
                child: const Text('Search'),
              ),
              if (provider.isLoading)
                const CircularProgressIndicator()
              else
                if (provider.errorMessage != null)
                  Text(provider.errorMessage!)
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.prices.length,
                      itemBuilder: (context, index) {
                        return MarketPriceCard(record: provider.prices[index]);
                      },
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
