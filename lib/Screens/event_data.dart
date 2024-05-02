import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_dashboard/style/colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../dataModel/calendar_model.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<CalendarItem> appointments) {
    this.appointments = appointments;
  }

  getCalendarEvent(int index) {
    // print('appointments ${appointments![index]}');
    return appointments![index] as CalendarItem;
  }

  @override
  DateTime getStartTime(int index) {
    final CalendarItem calendarEvent = getCalendarEvent(index);
    // print('calendarEvent ${calendarEvent.toJson()}');

    DateFormat inputFormat = DateFormat('E, MMM d, y');

    DateTime date;
    try {
      date = inputFormat.parse(calendarEvent.startDate!);
    } catch (_) {
      final DateFormat alternativeFormat = DateFormat('yyyy-MM-dd');
      date = alternativeFormat.parse(calendarEvent.startDate!);
    }

    String customTime = '1:20 AM';
    DateFormat customTimeFormat = DateFormat('hh:mm aa');

    try {
      DateTime customDateTime = customTimeFormat.parse(customTime);

      date = DateTime(
        date.year,
        date.month,
        date.day,
        customDateTime.hour,
        customDateTime.minute,
      );
    } catch (e) {
      print('Error parsing custom time: $e');
    }

    return date;
  }

  @override
  DateTime getEndTime(int index) {
    final CalendarItem calendarEvent = getCalendarEvent(index);
    DateFormat inputFormat = DateFormat('E, MMM d, y');

    DateTime date;
    try {
      date = inputFormat.parse(calendarEvent.startDate ?? '2024-04-15');
    } catch (e) {
      // print(e);
      final DateFormat alternativeFormat = DateFormat('yyyy-MM-dd');
      date = alternativeFormat.parse(calendarEvent.startDate ?? '2024-04-15');
    }

    String customTime = '3:20 AM';
    DateFormat customTimeFormat = DateFormat('hh:mm aa');

    try {
      DateTime customDateTime = customTimeFormat.parse(customTime).add(const Duration(hours: 3));

      date = DateTime(
        date.year,
        date.month,
        date.day,
        customDateTime.hour,
        customDateTime.minute,
      );
    } catch (e) {
      print('Error parsing custom time: $e');
    }

    return date;
  }

  @override
  String getSubject(int index) => getCalendarEvent(index).title ?? '';

  @override
  Color getColor(int index) => AppColors.buttonColor;
}
