import 'package:agri_flutter/core/color_const.dart';
import 'package:agri_flutter/providers/eventExpense.dart/event_expense_provider.dart';
import 'package:agri_flutter/providers/eventExpense.dart/graph.dart';
import 'package:agri_flutter/views/calender_view/add_event_expense.dart';
import 'package:agri_flutter/services/noti_service.dart'; // Import NotiService
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalenderView extends StatefulWidget {
  const CalenderView({super.key});

  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  CalendarFormat formatMonth = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    // Fetch data when calendar opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventExpenseProvider>(
        context,
        listen: false,
      ).fetchAllData().catchError((e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error fetching data: $e")));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventExpenseProvider = Provider.of<EventExpenseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Farm Calendar"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => Graph()));
            },
            icon: Icon(Icons.grain_sharp),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventExpenseDialog(selectedDay),
            ),
          );

          // Refresh events after adding
          if (result == true) {
            eventExpenseProvider.fetchAllData();
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          /// **Table Calendar**
          TableCalendar(
            focusedDay: focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            calendarFormat: formatMonth,
            onFormatChanged: (format) {
              setState(() {
                formatMonth = format;
              });
            },
            headerStyle: const HeaderStyle(
              titleCentered: true,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
              decoration: BoxDecoration(color: ColorConst.green),
              formatButtonShowsNext: false,
            ),
            calendarStyle: CalendarStyle(
              markerSize: 20,
              selectedTextStyle: TextStyle(color: ColorConst.white),
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: ColorConst.green,
                shape: BoxShape.rectangle,
              ),
              tableBorder: TableBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              todayDecoration: BoxDecoration(
                color: ColorConst.green,
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekHeight: 20,
            daysOfWeekVisible: true,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            onDaySelected: (selectDay, focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
            },

            /// **Event Markers**
            eventLoader: (day) {
              return eventExpenseProvider.getEventsAndExpensesForDate(day) ??
                  [];
            },

            /// **Show Event Markers**
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 5,
                    bottom: 5,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: ColorConst.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          SizedBox(height: 5.h),

          /// **List of Events & Expenses**
          Expanded(
            child: Consumer<EventExpenseProvider>(
              builder: (context, provider, child) {
                final events =
                    provider.getEventsAndExpensesForDate(selectedDay) ?? [];

                if (events.isEmpty) {
                  return Center(
                    child: Text(
                      "No Event/Expense",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 10.w,
                        right: 10.w,
                        bottom: 5.h,
                      ),
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: ListTile(
                            title: Text(
                              event.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.type == "Expense"
                                      ? "₹${event.amount?.toStringAsFixed(2) ?? '0.00'}"
                                      : event.category,
                                ),
                                if (event.reminder != null)
                                  Text(
                                    "Reminder: ${DateFormat('dd-MM-yyyy HH:mm').format(event.reminder!)}",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: ColorConst.green,
                              ),
                              onPressed: () async {
                                await provider.removeEventExpense(event);

                                // **Cancel Notification if Exists**
                                if (event.reminder != null) {
                                  await NotificationService.cancelNotification(
                                    int.parse(event.id),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
