import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_dashboard/style/colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../dataModel/calendar_model.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<CalendarItem> appointments) {
    this.appointments = appointments;
  }

  // Generate special regions for each event in the month
  List<TimeRegion> getEventRegionsForMonth(DateTime monthStartDate, DateTime monthEndDate) {
    List<TimeRegion> eventRegions = [];
    for (int i = 0; i < appointments!.length; i++) {
      CalendarItem event = getCalendarEvent(i);
      DateTime eventDate = DateTime.parse(event.startDate!);
      if (eventDate.isAfter(monthStartDate) && eventDate.isBefore(monthEndDate)) {
        eventRegions.add(TimeRegion(
          startTime: eventDate,
          endTime: eventDate.add(Duration(hours: 1)), // Adjust duration as needed
          text: event.title!,
          textStyle: TextStyle(color: Colors.black), // Customize text style as needed
          color: Colors.yellow, // Customize region color as needed
        ));
      }
    }
    return eventRegions;
  }

  getCalendarEvent(int index) {
    return appointments![index] as CalendarItem;
  }

  @override
  DateTime getStartTime(int index) {
    final CalendarItem calendarEvent = getCalendarEvent(index);

    DateFormat inputFormat = DateFormat('E, MMM d, y');

    DateTime date;
    try {
      date = inputFormat.parse('2024-05-1');
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
}
class EventDataSource2 extends CalendarDataSource {
  final List<CalendarItem> appointments;
  final DateTime monthStartDate;
  final DateTime monthEndDate;

  EventDataSource2(this.appointments, this.monthStartDate, this.monthEndDate);

  List<CalendarItem> getEventsForMonth(DateTime monthStartDate, DateTime monthEndDate) {
    return appointments.where((appointment) {
      DateTime eventDate = DateTime.parse(appointment.startDate!);
      return eventDate.isAfter(monthStartDate) && eventDate.isBefore(monthEndDate);
    }).toList();
  }

  @override
  DateTime getStartTime(int index) {
    final CalendarItem calendarEvent = appointments[index];
    DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    DateTime date;
    try {
      date = inputFormat.parse(calendarEvent.startDate!);
    } catch (_) {
      date = DateTime.now(); // Set some default date or handle error
    }
    return date;
  }

  @override
  DateTime getEndTime(int index) {
    final CalendarItem calendarEvent = appointments[index];
    DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    DateTime date;
    try {
      date = inputFormat.parse(calendarEvent.endDate!);
    } catch (_) {
      date = DateTime.now(); // Set some default date or handle error
    }
    return date;
  }

  @override
  String getSubject(int index) => appointments[index].title ?? '';

  @override
  Color getColor(int index) => AppColors.buttonColor;
}