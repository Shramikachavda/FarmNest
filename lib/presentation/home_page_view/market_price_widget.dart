import 'package:agri_flutter/providers/api_provider/marker_price_provider.dart';
import 'package:flutter/material.dart';

class MarketPriceWidget extends StatefulWidget {
  const MarketPriceWidget({super.key});

  @override
  State<MarketPriceWidget> createState() => _MarketPriceWidgetState();
}

class _MarketPriceWidgetState extends State<MarketPriceWidget> {
  final MarkerPriceProvider viewModel = MarkerPriceProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: viewModel.loadPrices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No market data available"));
        }

        // Using snapshot data instead of viewModel.prices
        final prices = snapshot.data!;
        return Column(
          children:
              prices.take(2).map((item) {
                final commodityName = item['commodity_name'] ?? 'Unknown';
                final modalPrice = item['modal_price_rs'] ?? 'N/A';
                return Text("$commodityName: ₹$modalPrice/q");
              }).toList(),
        );
      },
    );
  }
}
