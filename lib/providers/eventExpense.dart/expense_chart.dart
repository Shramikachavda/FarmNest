import 'package:agri_flutter/providers/eventExpense.dart/event_expense_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseBarChart extends StatefulWidget {
  @override
  _ExpenseBarChartState createState() => _ExpenseBarChartState();
}

class _ExpenseBarChartState extends State<ExpenseBarChart> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final provider = Provider.of<EventExpenseProvider>(context, listen: false);
    await provider.fetchAllData();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EventExpenseProvider>(
        builder: (context, eventExpenseProvider, child) {
          if (isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final expenses = eventExpenseProvider.expenses;

          // ** Count total amount per expense category **
          Map<String, double> expenseSums = {};
          for (var expense in expenses) {
            expenseSums[expense.category] =
                (expenseSums[expense.category] ?? 0.0) +
                (expense.amount ?? 0.0);
          }

          if (expenseSums.isEmpty) {
            return Center(child: Text("No expense data available"));
          }

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY:
                    (expenseSums.values.reduce((a, b) => a > b ? a : b) + 50)
                        .toDouble(),
                barGroups:
                    expenseSums.entries.map((entry) {
                      return BarChartGroupData(
                        x: expenseSums.keys.toList().indexOf(entry.key),
                        barRods: [
                          BarChartRodData(
                            toY:
                                (entry.value ?? 0.0)
                                    .toDouble(), // ✅ Fixes null issue
                            color: _getCategoryColor(entry.key),
                            width: 16,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      );
                    }).toList(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${value.toInt()}',
                          style: TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final category = expenseSums.keys.elementAt(
                          value.toInt(),
                        );
                        return Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            category,
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${expenseSums.keys.elementAt(group.x)}\n\$${rod.toY.toInt()} spent',
                        TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// **Category Colors**
 Color _getCategoryColor(String category) {
  switch (category) {
    case "Harvesting":
      return Colors.green.shade700; // Represents lush crops being harvested
    case "Irrigation":
      return Colors.blue.shade600; // Water-related activity
    case "Pesticide Application":
      return Colors.orange.shade700; // Warning color for pesticides
    case "Fertilization":
      return Colors.brown.shade600; // Earthy soil-like tone
    case "Equipment Maintenance":
      return Colors.grey.shade700; // Represents metal tools & machinery
    case "Soil Testing":
      return Colors.deepOrange.shade400; // Represents soil analysis labs
    case "Livestock Care":
      return Colors.amber.shade700; // Warm, animal-related tone
    case "Market Visit":
      return Colors.teal.shade600; // Vibrant marketplace energy
    case "Other":
      return Colors.purple.shade600; // Neutral for miscellaneous tasks
    default:
      return Colors.blueGrey.shade600; // Default fallback color
  }
}


}
