import 'package:intl/intl.dart';

String getDayOfWeekAndMonth() {
  final now = DateTime.now();
  return DateFormat('EEEE, d MMMM').format(now);
}
