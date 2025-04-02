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
