import 'package:agri_flutter/core/image.dart';
import 'package:agri_flutter/customs_widgets/custom_icon.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/models/crop_details.dart';
import 'package:agri_flutter/models/live_stock_detail.dart';
import 'package:agri_flutter/providers/farm_state_provider.dart/crop_details_provider.dart';
import 'package:agri_flutter/providers/farm_state_provider.dart/liveStock_provider.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/presentation/farm_state_views/add_farm_state.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FarmStateHomeView extends StatelessWidget {
  const FarmStateHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final liveStockProvider = Provider.of<LivestockProvider>(context);
    final cropDetailsProvider = Provider.of<CropDetailsProvider>(context);

    final combinedList = [
      ...liveStockProvider.liveStockList,
      ...cropDetailsProvider.allCropList,
    ];

    return Scaffold(
      backgroundColor: themeColor(context: context).surface,
      appBar: AppBar(title: bodyMediumText("Farm State")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const AddFarmState()));
        },
        child: Icon(Icons.add, size: 20.sp),
      ),
      body:
          combinedList.isEmpty
              ? Center(child: bodyMediumText("No State Added"))
              : ListView.builder(
                itemCount: combinedList.length,
                itemBuilder: (context, index) {
                  final item = combinedList[index];

                  //Livestock Card
                  if (item is LiveStockDetail) {
                    return _buildLivestockCard(context, item);
                  }
                  //Crop Card
                  else if (item is CropDetails) {
                    return _buildCropCard(context, item);
                  }

                  return const SizedBox();
                },
              ),
    );
  }

  /// 📌 **Livestock Card Widget**
  Widget _buildLivestockCard(BuildContext context, LiveStockDetail item) {
    final liveStockProvider = Provider.of<LivestockProvider>(
      context,
      listen: false,
    );

    return Dismissible(
      key: ObjectKey(item),
      confirmDismiss: (direction) async {
        return await _showDeleteDialog(context, "Remove Livestock?");
      },
      onDismissed: (direction) {
        liveStockProvider.removeLiveStock(item);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 10.w, left: 10.w, bottom: 5.h),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              //  color: themeColor(context: context).cardColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🗓 **Date Row**
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 4.w),
                        Text(
                          DateFormat('dd/MM/yyyy').format(item.vaccinatedDate),
                          style: const TextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => AddFarmState(
                                      initialTabIndex: 1, // Livestock Tab
                                      existingLivestock: item.id, // Pass Data
                                    ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        SizedBox(width: 8.w), // Consistent spacing
                        IconButton(
                          onPressed: () async {
                            bool? confirmDelete = await _showDeleteDialog(
                              context,
                              "Are you sure?",
                            );
                            if (confirmDelete == true) {
                              liveStockProvider.removeLiveStock(item);
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: themeColor(context: context).primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                /// 🐄 **Livestock Name & Age**
                Text(
                  "${item.liveStockName}, ${item.gender} | ${item.age} Years",
                ),
                SizedBox(height: 4.h),

                /// 💉 **Health Status & Type**
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Health Status: ",
                        children: [TextSpan(text: "Vaccinated")],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Type: ",
                        children: [
                          TextSpan(
                            //    text: item.,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 📌 **Crop Card Widget**
  Widget _buildCropCard(BuildContext context, CropDetails item) {
    final cropDetailsProvider = Provider.of<CropDetailsProvider>(
      context,
      listen: false,
    );

    return Dismissible(
      key: ObjectKey(item),
      confirmDismiss: (direction) async {
        return await _showDeleteDialog(context, "Remove Crop?");
      },
      onDismissed: (direction) {
        // cropDetailsProvider.removeCrop(item);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 10.w, left: 10.w, bottom: 5.h),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              //  color: themeColor(context: context).cardColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🌱 **Crop Name & Growth Stage**
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${item.cropName} | ${item.growthStage}"),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => AddFarmState(
                                      initialTabIndex: 0, // Crop Tab
                                      existingCrop: item.id, // Pass Data
                                    ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        SizedBox(width: 8.w), // Consistent spacing
                        IconButton(
                          onPressed: () async {
                            bool? confirmDelete = await _showDeleteDialog(
                              context,
                              "Are you sure?",
                            );
                            if (confirmDelete == true) {cropDetailsProvider.removeCrop(item.id);
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: themeColor(context: context).primary,
                          ), // 🗑 Delete Icon
                        ),
                      ],
                    ),
                  ],
                ),

                //start and harvesting data
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          ImageConst.startDate,
                          height: 20.sp,
                          width: 20.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(DateFormat('dd/MM/yyyy').format(item.startDate)),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          ImageConst.harvestDate,
                          height: 20.sp,
                          width: 20.sp,
                        ),
                        // 🚜 Harvest Date Icon
                        SizedBox(width: 4.w),
                        Text(DateFormat('dd/MM/yyyy').format(item.harvestDate)),
                      ],
                    ),
                  ],
                ),

                //location
                Row(
                  children: [
                    Image.asset(
                      ImageConst.location,
                      height: 20.sp,
                      width: 20.sp,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        "${item.location}",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                //ferti and pesti
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          ImageConst.harvestDate,
                          height: 20.sp,
                          width: 20.sp,
                        ),
                        SizedBox(width: 4.w),
                        smallText(item.fertilizer),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          ImageConst.pesti,
                          height: 20.sp,
                          width: 20.sp,
                        ), // 🐞 Pesticide Icon
                        SizedBox(width: 4.w),
                        smallText(item.pesticide),
                      ],
                    ),
                  ],
                ),
              ].separator(SizedBox(height: 8.h),).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditDeleteButtons(
    BuildContext context, {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: onEdit,
          icon: Icon(Icons.edit, color: themeColor(context: context).primary),
        ),
        SizedBox(width: 8.w), // Consistent spacing
        IconButton(
          onPressed: () async {
            bool? confirmDelete = await _showDeleteDialog(
              context,
              "Are you sure?",
            );
            if (confirmDelete == true) {
              onDelete();
            }
          },
          icon: Icon(Icons.delete, color: themeColor(context: context).primary),
        ),
      ],
    );
  }

  /// ✅ **Reusable Delete Confirmation Dialog**
  Future<bool?> _showDeleteDialog(BuildContext context, String message) {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Confirm Deletion"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  "Delete",
                  style: TextStyle(color: themeColor(context: context).primary),
                ),
              ),
            ],
          ),
    );
  }
}
