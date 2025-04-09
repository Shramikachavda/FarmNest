import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:agri_flutter/utils/text_style_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarketPriceCard extends StatelessWidget {
  final dynamic record;

  const MarketPriceCard({required this.record, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: themeColor().surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              [
                bodySemiLargeExtraBoldText('${record['Market']} Market'),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Commodity: ",
                        style: AppTextStyles.bodyBoldStyle.copyWith(
                          color: themeColor().onSurface,
                        ),
                      ),
                      TextSpan(
                        text: " ${record['Commodity']} (${record['Variety']}",
                        style: AppTextStyles.bodySmallStyle.copyWith(
                          color: themeColor().onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
    
                /*     RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Date: ",
                    style: AppTextStyles.bodyBoldStyle.copyWith(
                      color: themeColor().onSurface,
                    ),
                  ),
                  TextSpan(
                    text: " ${record['Arrival_Date']}",
                    style: AppTextStyles.bodySmallStyle.copyWith(
                      color: themeColor().onSurface,
                    ),
                  ),
                ],
              ),
            ),
    */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Min: ₹${record['Min_Price']}'),
                    Text('Max: ₹${record['Max_Price']}'),
                    Text('Modal: ₹${record['Modal_Price']}'),
                  ],
                ),
              ].separator(SizedBox(height: 5.h)).toList(),
        ),
      ),
    );
  }
}
