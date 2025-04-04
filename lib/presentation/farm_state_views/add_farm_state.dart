import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/presentation/farm_state_views/crop_detail_view.dart';
import 'package:agri_flutter/presentation/farm_state_views/live_stock_view.dart';
import 'package:flutter/material.dart';
class AddFarmState extends StatelessWidget {
  final int initialTabIndex; // New parameter for tab selection
  final String? existingCrop; // Optional existing crop to edit
  final String? existingLivestock; // Optional existing livestock to edit

  const AddFarmState({
    super.key, 
    this.initialTabIndex = 0, 
    this.existingCrop, 
    this.existingLivestock,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialTabIndex, // ✅ Set the default tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add your Crop/Livestock"),
          bottom: TabBar(
            indicatorColor: themeColor().primary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: themeColor().primary,
            indicatorAnimation: TabIndicatorAnimation.elastic,
            enableFeedback: true,
            automaticIndicatorColorAdjustment: true,
            dividerHeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.agriculture), text: "Crop Details"), 
              Tab(icon: Icon(Icons.pets), text: "Livestock Details"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CropDetailView(cropId: existingCrop),  // Crop form
            LiveStockDetailView(livestockId: existingLivestock), // Livestock form
          ],
        ),
      ),
    );
  }
}
