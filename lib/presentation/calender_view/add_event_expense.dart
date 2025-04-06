import 'package:agri_flutter/core/drop_down_value.dart';
import 'package:agri_flutter/customs_widgets/custom_button.dart';
import 'package:agri_flutter/customs_widgets/custom_form_field.dart';
import 'package:agri_flutter/customs_widgets/custom_snackbar.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
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
  DateTime? _selectedReminderTime;
  Categoty? _selectedCategory = Categoty.harvesting;

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

    return SizedBox(
      //  width: MediaQuery.of(context).size.width * 0.8,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Add $_selectedType"),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRadioButton("Event"),
                  _buildRadioButton("Expense"),
                ],
              ),
              SizedBox(height: 15.h),
              CustomFormField(
                hintText: 'Enter your title',
                keyboardType: TextInputType.name,
                label: 'Title',
                textEditingController: _titleController,
              ),

              SizedBox(height: 15.h),
              reusableDropdown<Categoty>(
                label: "Category",
                selectedValue: _selectedCategory,
                items: Categoty.values,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                    if (newValue != Categoty.other) {
                      _customCategoryController.clear();
                    }
                  });
                },
              ),
              SizedBox(height: 15.h),

              if (_selectedCategory == Categoty.other)
                _buildCustomCategoryField(),

              if (_selectedType == "Expense") _buildExpenseField(),

              //    SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50.h,
                      child: ElevatedButton.icon(
                        onPressed: () => _pickReminderTime(context),
                        icon: const Icon(Icons.alarm),
                        label: const Text("Set Reminder"),
                      ),
                    ),
                  ),
                ],
              ),

              if (_selectedReminderTime != null)
                Text(
                  "Reminder: ${_selectedReminderTime!.toLocal().toString().split('.')[0]}",
                ),
              SizedBox(height: 15.h),
              CustomButton(
                onClick: () async => _saveEvent(eventExpenseProvider, context),
                buttonName: "Add",
              ),
            ],
          ),
        ),
      ),
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
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget _buildExpenseField() {
    return Column(
      children: [
        CustomFormField(
          hintText: 'Enter your expense',
          keyboardType: TextInputType.number,
          label: 'Expense',
          textEditingController: _amountController,
        ),
        SizedBox(height: 15.h),
      ],
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
        _selectedCategory == Categoty.other
            ? _customCategoryController.text
            : _selectedCategory!.name;

    if (finalCategory.isEmpty) {
      showCustomSnackBar(context, "Please enter a category");
      return;
    }

    try {
      final event = EventExpense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        amount:
            _selectedType == "Expense"
                ? double.parse(_amountController.text)
                : null,
        category: finalCategory, // Convert enum to string
        date: widget.selectedDate,
        type: _selectedType,
        reminder: _selectedReminderTime,
      );

      await eventExpenseProvider.addEventExpense(event);

      if (_selectedReminderTime != null) {
        await NotificationService.scheduleNotification(
          _titleController.text,
          _selectedReminderTime!,
        );
      }

      showCustomSnackBar(context, "Added successfully");
      Navigator.pop(context, true);
    } catch (e) {
      showCustomSnackBar(context, "Failed to add: $e");
    }
  }
}
