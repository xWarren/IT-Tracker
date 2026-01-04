import 'package:intl/intl.dart';

extension DateFormatExtension on DateTime {

  String toReadableDateTime() {
    return DateFormat('MMMM d, y \'at\' h:mm a').format(this);
  }

  String toReadableTime() {
    final hour = this.hour > 12 ? this.hour - 12 : (this.hour == 0 ? 12 : this.hour);
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
  
  String toReadableDate() {
    final months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return "${months[month - 1]} $day, $year";
  }
}