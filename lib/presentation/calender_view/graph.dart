import 'package:agri_flutter/presentation/calender_view/event_chart.dart';
import 'package:agri_flutter/presentation/calender_view/expense_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Graph extends StatelessWidget {
  const Graph({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Farm Analytics")),
      body: Padding(
        padding: EdgeInsets.all(10.r),
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
