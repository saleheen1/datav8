import 'package:intl/intl.dart';

String? formatDateByMMMDDYY(DateTime? dateTime) {
  if (dateTime == null) return null;
  return DateFormat("MMM dd, yyyy").format(dateTime.toLocal());
}
