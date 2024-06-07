import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({super.key});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime initialDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${initialDay.year} - ${initialDay.month} - ${initialDay.day}',
            style: TextStyle(fontSize: 20),
          ),
          ElevatedButton(
            onPressed: () async {
              final DateTime? dateTime = await showDatePicker(
                context: context,
                initialDate: initialDay,
                firstDate: DateTime(2000),
                lastDate: DateTime(3000),

              );
              if (dateTime != null) {
                setState(() {
                  initialDay = dateTime;
                });
                final formattedDate = DateFormat('yyyyMMdd').format(dateTime);
              }
            },
            child: Text('Select Date'),
          )
        ],
      ),
    );
  }
}