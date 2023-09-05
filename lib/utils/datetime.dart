// Will be discarded when intl package is used

String formatDate(DateTime dateTime) {
  String day = dateTime.day.toString().padLeft(2, '0');
  String month = getMonthName(dateTime.month);
  String year = dateTime.year.toString();
  String hour = (dateTime.hour % 12).toString().padLeft(2, '0');
  String minute = dateTime.minute.toString().padLeft(2, '0');
  String period = dateTime.hour >= 12 ? 'PM' : 'AM';

  return '$day $month $year, ${hour == "00" ? "12" : hour}:$minute$period';
}

String getMonthName(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return '';
  }
}
