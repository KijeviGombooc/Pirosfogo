class Formatter {
  static const List<String> _monthsShort = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  static const List<String> _monthsLong = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  static const List<String> _daysShort = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];
  static const List<String> _daysLong = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  static String _getTwoDigits(int num) {
    return num < 10 ? "0" + num.toString() : num.toString();
  }

//TODO: replace with padding
  static String _getThreeDigits(int num) {
    return num < 10
        ? "00" + num.toString()
        : num < 100
            ? "0" + num.toString()
            : num.toString();
  }

  static String date(DateTime dateTime, String formatString) {
    return formatString
        .replaceAll("yyyy", dateTime.year.toString())
        .replaceAll("MMMM", _monthsLong[dateTime.month - 1])
        .replaceAll("MMM", _monthsShort[dateTime.month - 1])
        .replaceAll("MM", _getTwoDigits(dateTime.month))
        // .replaceAll("yy", _getTwoDigits(dateTime.month))
        .replaceAll("dddd", _daysLong[dateTime.weekday - 1])
        .replaceAll("ddd", _daysShort[dateTime.weekday - 1])
        .replaceAll("dd", _getTwoDigits(dateTime.day))
        .replaceAll("hh", _getTwoDigits(dateTime.hour))
        .replaceAll("mm", _getTwoDigits(dateTime.minute))
        .replaceAll("ss", _getTwoDigits(dateTime.second))
        .replaceAll("eee", _getThreeDigits(dateTime.millisecond));
  }

  static DateTime parseDate(String dateString) {
    int year = 0;
    int month = 1;
    int day = 1;
    int hour = 0;
    int minute = 0;
    int second = 0;
    int millisecond = 0;
    try {
      year = int.parse(dateString.substring(0, 4));
      month = int.parse(dateString.substring(4, 6));
      day = int.parse(dateString.substring(6, 8));
      hour = int.parse(dateString.substring(8, 10));
      minute = int.parse(dateString.substring(10, 12));
      second = int.parse(dateString.substring(12, 14));
      millisecond = int.parse(dateString.substring(14, 17));
    } catch (e) {}
    return DateTime(
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
    );
  }
}
