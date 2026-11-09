/// Utility class for formatting dates and times cleanly without external dependencies.
class DateFormatter {
  static const List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> _shortMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Returns a clean formatted date string, e.g. "Monday, Nov 9, 2026"
  static String formatHeaderDate(DateTime date) {
    final weekday = _weekdays[date.weekday - 1];
    final month = _shortMonths[date.month - 1];
    final day = date.day;
    final year = date.year;
    return '$weekday, $month $day, $year';
  }

  /// Returns a human-friendly time stamp, e.g. "03:45 PM"
  static String formatTime(DateTime date) {
    final hour = date.hour == 0
        ? 12
        : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  /// Returns full month name and day, e.g. "November 9"
  static String formatFullMonthDay(DateTime date) {
    final month = _months[date.month - 1];
    return '$month ${date.day}';
  }
}
