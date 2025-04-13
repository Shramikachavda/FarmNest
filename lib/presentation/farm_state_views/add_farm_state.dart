import 'package:agri_flutter/core/image.dart';
import 'package:agri_flutter/customs_widgets/custom_icon.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/presentation/farm_state_views/crop_detail_view.dart';
import 'package:agri_flutter/presentation/farm_state_views/live_stock_view.dart';
import 'package:agri_flutter/utils/navigation/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      initialIndex: initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 80.w,
          leading: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              NavigationUtils.pop();
            },
            child: Padding(
              padding: EdgeInsets.only(
                left: 24.w,
                bottom: 15.h,
                right: 26.w,
                top: 12.h,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: 100.w,
                  color: themeColor(context: context).primary,
                  child: customIcon(context, ImageConst.icBack),
                ),
              ),
            ),
          ),
          title: bodyMediumText("Add your Crop/Livestock"),
          bottom: TabBar(
            indicatorColor: themeColor(context: context).primary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: themeColor(context: context).primary,
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
            CropAdvisorView(existingCrop: existingCrop), // Crop form
            LiveStockDetailView(
              livestockId: existingLivestock,
            ), // Livestock form
          ],
        ),
      ),
    );
  }
}
