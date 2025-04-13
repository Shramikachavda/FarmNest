import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:agri_flutter/customs_widgets/custom_icon.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/providers/eventExpense.dart/event_expense_provider.dart';
import 'package:agri_flutter/presentation/calender_view/graph.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/presentation/calender_view/add_event_expense.dart';
import 'package:agri_flutter/services/noti_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/BaseStateFullWidget.dart';

class CalenderView extends BaseStatefulWidget {
  const CalenderView({super.key});

  @override
  State<CalenderView> createState() => _CalenderViewState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/CalenderView";

  @override
  String get routeName => route;
}

class _CalenderViewState extends State<CalenderView> {
  CalendarFormat formatMonth = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
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
    final colorScheme = themeColor(context: context);
    final eventExpenseProvider = Provider.of<EventExpenseProvider>(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => Graph()));
            },
            icon: Icon(Icons.insights, size: 24.sp),
            tooltip: "View Analytics",
          ),
        ],
        title: bodyMediumText("Farm Calendar"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AddEventExpenseDialog(selectedDay),
          );
          if (result == true) {
            eventExpenseProvider.fetchAllData();
          }
        },

        child: Icon(Icons.add, size: 28.sp),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: TableCalendar(
                focusedDay: focusedDay,
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                calendarFormat: formatMonth,
                onFormatChanged: (format) {
                  setState(() {
                    formatMonth = format;
                  });
                },
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                  ),
                  formatButtonDecoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  formatButtonTextStyle: TextStyle(
                    color: colorScheme.onSecondaryContainer,
                    fontSize: 14.sp,
                  ),
                  formatButtonShowsNext: false,
                  headerMargin: EdgeInsets.only(bottom: 12.h),
                ),
                calendarStyle: CalendarStyle(
                  markerSize: 10.sp,
                  selectedTextStyle: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  todayTextStyle: TextStyle(
                    color: colorScheme.onTertiary,
                    fontWeight: FontWeight.bold,
                  ),
                  //   outsideTextStyle: TextStyle(color: colorScheme.primary),
                  defaultTextStyle: TextStyle(color: colorScheme.onSurface),
                  selectedDecoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  tableBorder: TableBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.r)),
                  ),
                ),
                daysOfWeekHeight: 24.h,
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                  ),
                  weekendStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                  ),
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(selectedDay, day);
                },
                onDaySelected: (selectDay, focusDay) {
                  setState(() {
                    selectedDay = selectDay;
                    focusedDay = focusDay;
                  });
                },
                eventLoader: (day) {
                  return eventExpenseProvider.getEventsAndExpensesForDate(day);
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        right: 4.w,
                        bottom: 4.h,
                        child: Container(
                          width: 8.sp,
                          height: 8.sp,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: Consumer<EventExpenseProvider>(
                builder: (context, provider, child) {
                  final events =
                      provider.getEventsAndExpensesForDate(selectedDay) ?? [];

                  if (events.isEmpty) {
                    return Center(
                      child: Text(
                        "No Events or Expenses",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            title: Text(
                              event.title,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4.h),
                                captionStyleText(
                                  event.type == "Expense"
                                      ? "₹${event.amount?.toStringAsFixed(2) ?? '0.00'}"
                                      : event.category,
                                ),
                                if (event.reminder != null)
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.h),
                                    child: Text(
                                      "Reminder: ${DateFormat('dd-MM-yyyy HH:mm').format(event.reminder!)}",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: colorScheme.onSurfaceVariant
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, size: 20.sp),
                              onPressed: () async {
                                await provider.removeEventExpense(event);
                                if (event.reminder != null) {
                                  await NotificationService.cancelNotification(
                                    int.parse(event.id),
                                  );
                                }
                              },
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
      ),
    );
  }
}
