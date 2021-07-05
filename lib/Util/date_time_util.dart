import 'package:intl/intl.dart';

class DateTimeUtil {
  static String convertDateTimeToString(
      DateTime inputDateTime, DateFormat format) {
    return format.format(inputDateTime);
  }

  static DateTime convertStringToDateTime(
      String inputString, DateFormat format) {
    return format.parse(inputString);
  }
}
