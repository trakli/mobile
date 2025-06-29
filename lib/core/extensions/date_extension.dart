extension DateTimeExtension on DateTime {
  bool isSameMonthAndYear(DateTime b) {
    return year == b.year && month == b.month;
  }
}
