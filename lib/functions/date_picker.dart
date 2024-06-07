import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future pickFromDateTime({
  required bool pickDate,
  required BuildContext context,
  required TextEditingController? controller,
}) async {
  DateTime pickedDate = DateTime.now();
  final date = await pickDateTime(pickedDate, pickDate: pickDate, context: context);
  if (pickDate) {
    pickedDate = date!;
    controller!.text = toDate(date);
  } else {
    controller!.text = toTime(date!);
  }
}

String toDate(DateTime dateTime) {
  final date = DateFormat('yyyy-MM-dd').format(dateTime);
  return date;
}

String toTime(DateTime dateTime) {
  final date = DateFormat('hh:mm').format(dateTime);
  return date;
}

Future<DateTime?> pickDateTime(DateTime initialDate, {required BuildContext context, required bool pickDate, DateTime? firstDate}) async {
  var lastDate = DateTime.now().year + 16;
  if (pickDate) {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime.now(),
      lastDate: DateTime(lastDate),
    );

    if (date == null) return null;

    final time = Duration(hours: initialDate.hour, minutes: initialDate.minute);

    return date.add(time);
  } else {
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (timeOfDay == null) return null;

    final date = DateTime(initialDate.year, initialDate.month, initialDate.day);
    final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

    return date.add(time);
  }
}
