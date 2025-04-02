import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/providers/eventExpense.dart/event_expense_provider.dart';
import 'package:agri_flutter/services/noti_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:agri_flutter/models/event_expense.dart';

class AddEventExpenseDialog extends StatefulWidget {
  final DateTime selectedDate;
  const AddEventExpenseDialog(this.selectedDate, {super.key});

  @override
  State<AddEventExpenseDialog> createState() => _AddEventExpenseDialogState();
}

class _AddEventExpenseDialogState extends State<AddEventExpenseDialog> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _customCategoryController = TextEditingController();
  String _selectedType = "Event";
  DateTime? _selectedReminderTime; // Store selected reminder time

  // List of predefined categories
  final List<String> _categories = [
    "Harvesting",
    "Irrigation",
    "Pesticide Application",
    "Fertilization",
    "Equipment Maintenance",
    "Soil Testing",
    "Livestock Care",
    "Market Visit",
    "Other",
  ];
  String? _selectedCategory = "Harvesting"; // Default category

  // Pick reminder time
  Future<void> _pickReminderTime(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedReminderTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventExpenseProvider = Provider.of<EventExpenseProvider>(context);

    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      title: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.cancel),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Radio buttons for selecting Event or Expense
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRadioButton("Event"),
                _buildRadioButton("Expense"),
              ],
            ),
            CustomFormField(
              hintText: 'Enter your title',
              keyboardType: TextInputType.name,
              label: 'Title',
              textEditingController: _titleController,
            ),
            SizedBox(height: 8.h),

            // Category dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              items:
                  _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  if (value != "Other") {
                    _customCategoryController.clear();
                  }
                });
              },
            ),
            SizedBox(height: 8.h),

            if (_selectedCategory == "Other") _buildCustomCategoryField(),

            if (_selectedType == "Expense") _buildExpenseField(),

            // Reminder button
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickReminderTime(context),
                    icon: const Icon(Icons.alarm),
                    label: const Text("Set Reminder"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Display selected reminder time
            if (_selectedReminderTime != null)
              Text(
                "Reminder Set: ${_selectedReminderTime!.toLocal()}",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          onClick: () async => _saveEvent(eventExpenseProvider, context),
          buttonName: "Add",
        ),
      ],
    );
  }

  Widget _buildRadioButton(String value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: _selectedType,
          onChanged: (val) => setState(() => _selectedType = val!),
        ),
        Text(value),
      ],
    );
  }

  Widget _buildCustomCategoryField() {
    return Column(
      children: [
        CustomFormField(
          hintText: 'Enter custom category',
          keyboardType: TextInputType.name,
          label: 'Custom Category',
          textEditingController: _customCategoryController,
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _buildExpenseField() {
    return CustomFormField(
      hintText: 'Enter your expense',
      keyboardType: TextInputType.number,
      label: 'Expense',
      textEditingController: _amountController,
    );
  }

 Future<void> _saveEvent(
  EventExpenseProvider eventExpenseProvider,
  BuildContext context,
) async {
  if (_titleController.text.isEmpty) {
    showCustomSnackBar(context, "Please enter a title");
    return;
  }

  if (_selectedType == "Expense" &&
      (_amountController.text.isEmpty ||
          double.tryParse(_amountController.text) == null)) {
    showCustomSnackBar(context, "Please enter a valid expense amount");
    return;
  }

  String finalCategory =
      _selectedCategory == "Other" ? _customCategoryController.text : _selectedCategory!;

  if (finalCategory.isEmpty) {
    showCustomSnackBar(context, "Please enter a category");
    return;
  }

  try {
    // Add event and get the generated ID
    final event = EventExpense(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate a unique ID
      title: _titleController.text,
      amount: _selectedType == "Expense" ? double.parse(_amountController.text) : null,
      category: finalCategory,
      date: widget.selectedDate,
      type: _selectedType,
      reminder: _selectedReminderTime,
    );

    await eventExpenseProvider.addEventExpense(event);

    // Schedule notification if a reminder is set
    if (_selectedReminderTime != null) {
      await NotificationService.scheduleNotification(
        _titleController.text,
        _selectedReminderTime!,
      );
    }

    showCustomSnackBar(context, "Added successfully");
    Navigator.pop(context, true); // Return true to refresh the calendar
  } catch (e) {
    showCustomSnackBar(context, "Failed to add: $e");
  }
}
}
