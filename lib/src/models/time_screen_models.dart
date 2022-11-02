class TimeScreenModels {
  late int year;
  late int month;
  late int day;
  late int hour;
  late int minute;
  late int second;
  late int tradeAvailableDay;

  TimeScreenModels(
      {required this.year,
      required this.month,
      required this.day,
      required this.hour,
      required this.minute,
      required this.second,required this.tradeAvailableDay});

  TimeScreenModels.withOut();
}
