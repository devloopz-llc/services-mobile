import 'package:intl/intl.dart';

/// Every amount from the API is an integer number of pence, GBP — never a
/// float, never pre-formatted. Divide by 100 only at the display edge (see
/// conventions.md §Money). This is that edge.
class MoneyFormatter {
  const MoneyFormatter._();

  static final _format = NumberFormat.currency(locale: 'en_GB', symbol: '£');

  static String gbp(int pence) => _format.format(pence / 100);
}
