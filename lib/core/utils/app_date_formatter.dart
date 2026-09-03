import 'package:intl/intl.dart';

/// Matches the backend's own display convention exactly (see
/// conventions.md §Dates and times): dates as "18 Aug 2026", times as
/// 12-hour **lowercase** "2:30 pm" (`DateFormat` alone gives "2:30 PM"),
/// combined as "18 Aug 2026, 2:30 pm". Every datetime from the API is UTC
/// and must be converted to local (Europe/London) before formatting —
/// `DateTime.toLocal()` handles that given a UTC `DateTime`.
class AppDateFormatter {
  const AppDateFormatter._();

  static String time(DateTime value) => DateFormat('h:mm a').format(value).toLowerCase();

  static String date(DateTime value) => DateFormat('d MMM yyyy').format(value);

  static String weekdayDate(DateTime value) => DateFormat('EEE, d MMM yyyy').format(value);

  static String dateTime(DateTime value) => '${date(value)}, ${time(value)}';
}
