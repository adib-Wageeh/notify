import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getDayOfWeekAndMonth() {
  final now = DateTime.now();
  return DateFormat('EEEE, d MMMM').format(now);
}

String dateTimeToString(DateTime date){
  return DateFormat('dd/MM/yyyy').format(date);
}

String dateTimeToString2(DateTime date) {
  return DateFormat('dd/MM/yyyy, hh:mm a').format(date);
}

String timeOfDayToString(TimeOfDay time) {
  final period = time.hour >= 12 ? 'PM' : 'AM';
  final hour12 = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final hour = hour12.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute $period';
}

DateTime mergeDateAndTime(DateTime date, TimeOfDay time) {
  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}