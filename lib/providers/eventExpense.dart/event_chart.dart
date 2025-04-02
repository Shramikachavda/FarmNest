import 'package:agri_flutter/providers/eventExpense.dart/event_expense_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventPieChart extends StatefulWidget {
  @override
  _EventPieChartState createState() => _EventPieChartState();
}

class _EventPieChartState extends State<EventPieChart> {
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

          final events = eventExpenseProvider.events;

          // Count events by category
          Map<String, int> eventCounts = {};
          for (var event in events) {
            eventCounts[event.category] =
                (eventCounts[event.category] ?? 0) + 1;
          }

          if (eventCounts.isEmpty) {
            return Center(child: Text("No event data available"));
          }

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: PieChart(
              PieChartData(
                sections:
                    eventCounts.entries.map((entry) {
                      return PieChartSectionData(
                        value: entry.value.toDouble(),
                        title: '${entry.key}\n(${entry.value})',
                        color: _getCategoryColor(entry.key),
                        radius: 80,
                        titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Category Colors
  Color _getCategoryColor(String category) {
    switch (category) {
      case "Harvest":
        return Colors.green;
      case "Irrigation":
        return Colors.blue;
      case "Meetings":
        return Colors.red;
      case "Pest Control":
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }
}
