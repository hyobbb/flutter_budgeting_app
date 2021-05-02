class DateHandler {
  static const Map<int, String> month = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };

  static const Map<int, String> monthSpanish = {
    1: 'Enero',
    2: 'Febrero',
    3: 'Marzo',
    4: 'Abril',
    5: 'Mayo',
    6: 'Junio',
    7: 'Julio',
    8: 'Agosto',
    9: 'Septiembre',
    10: 'Octubre',
    11: 'Noviembre',
    12: 'Diciembre',
  };

  static const Map<int, String> monthShort = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };

  static String toText(
    DateTime dateTime, {
    bool shortYear = false,
    bool includeDay = true,
    String join = '-',
  }) {
    return [
      shortYear ? dateTime.year % 100 : dateTime.year,
      dateTime.month.toString().padLeft(2, '0'),
      if (includeDay) dateTime.day.toString().padLeft(2, '0')
    ].join(join);
  }

  static int toInt(DateTime date) {
    return int.parse(date.year.toString() +
        date.month.toString().padLeft(2, '0') +
        date.day.toString().padLeft(2, '0'));
  }

  static int numOfDay(int month, int year) {
    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return 31;
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      case 2:
        if (year % 4 == 0) {
          return 29;
        } else {
          return 28;
        }
      default:
        return 0;
    }
  }
}
