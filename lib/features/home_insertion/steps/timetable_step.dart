import 'package:flutter/material.dart';
import 'package:wherehome/features/home_insertion/widgets/calendar_picker_insertion.dart';
import 'package:wherehome/features/home_insertion/widgets/timepicker_insertion.dart';

class TimetableStep extends StatelessWidget {
  const TimetableStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Timetable',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        CalendarPickerInputField(
          availableFrom: DateTime.now(),
          availableTo: DateTime.now().add(const Duration(days: 365)),
          onDateSelected: (dateRange) {
            // Handle selected date range
          },
        ),
        const SizedBox(height: 16),
        TimePickerInsertField(
          onFromTimeSelected: (startT) {
            // Handle start time
          },
          onToTimeSelected: (endT) {
            // Handle end time
          },
          onIntervalSelected: (interval) {
            // Handle interval
          },
        ),
      ],
    );
  }
}