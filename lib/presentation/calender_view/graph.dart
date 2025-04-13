import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/presentation/calender_view/event_chart.dart';
import 'package:agri_flutter/presentation/calender_view/expense_chart.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Graph extends StatelessWidget {
  const Graph({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor(context: context).surface,
      appBar: CustomAppBar(title: "Farm Analytics"),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            Text(
              "Event Statistics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Flexible(child: EventPieChart()), // 📊 Bar Chart for Events
            Divider(),
            Text(
              "Expense Trends",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(child: ExpenseBarChart()), // 📈 Line Chart for Expenses
          ],
        ),
      ),
    );
  }
}
