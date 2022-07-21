String abbreviateWeekday(int weekday) {
  const List<String> daysOfWeek = [
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
  ];

  return daysOfWeek[weekday % 7];
}

DateTime getToday() {
  var now = DateTime.now();
  var today = DateTime(now.year, now.month, now.day);
  return today;
}
