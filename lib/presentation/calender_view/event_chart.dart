import 'package:agri_flutter/providers/eventExpense.dart/event_expense_provider.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/BaseStateFullWidget.dart';
import '../../customs_widgets/reusable.dart';

class EventPieChart extends BaseStatefulWidget {
  const EventPieChart({super.key});

  @override
  _EventPieChartState createState() => _EventPieChartState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/EventPieChart";

  @override
  String get routeName => route;
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
         backgroundColor: themeColor(context: context).surface,
      body: Consumer<EventExpenseProvider>(
        builder: (context, eventExpenseProvider, child) {
          if (isLoading) {
            return Center(child: showLoading(context));
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

  Color _getCategoryColor(String category) {
    switch (category) {
      case "harvesting":
        return Colors.green.shade700; // Represents lush crops being harvested
      case "irrigation":
        return Colors.blue.shade600; // Water-related activity
      case "pesticideApplication":
        return Colors.orange.shade700; // Warning color for pesticides
      case "fertilization":
        return Colors.brown.shade600; // Earthy soil-like tone
      case "equipmentMaintenance":
        return Colors.grey.shade700; // Represents metal tools & machinery
      case "soilTesting":
        return Colors.deepOrange.shade400; // Represents soil analysis labs
      case "livestockCare":
        return Colors.amber.shade700; // Warm, animal-related tone
      case "marketVisit":
        return Colors.teal.shade600; // Vibrant marketplace energy
      case "other":
        return Colors.purple.shade600; // Neutral for miscellaneous tasks
      default:
        return Colors.blueGrey.shade600; // Default fallback color
    }
  }
}
