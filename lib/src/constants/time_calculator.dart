import 'package:ripper/src/models/time_screen_models.dart';

enum TimeTypes { year, month, day, hour, minute, second }

class TimeCalculator {
  static Future<TimeScreenModels> timeGetter(int tokenValue) async {
    var firstDate = DateTime.fromMillisecondsSinceEpoch(tokenValue);

    var remainingTime = firstDate.difference(DateTime.now());

    Duration remainingDuration = remainingTime;

    var yearMilliseconds = 31622400000;
    var monthMilliseconds = 2678400000;
    var dayMilliseconds = 86400000;
    var hourMilliseconds = 3600000;
    var minuteMilliseconds = 60000;
    var secondMilliseconds = 1000;

    var yearTime = remainingDuration.inMilliseconds / yearMilliseconds;
    var nonYearMod = remainingDuration.inMilliseconds % yearMilliseconds;

    var monthTime = nonYearMod / monthMilliseconds;
    var nonMonthMod = nonYearMod % monthMilliseconds;

    var dayTime = nonMonthMod / dayMilliseconds;
    var nonDayMod = nonMonthMod % dayMilliseconds;

    var hourTime = nonDayMod / hourMilliseconds;
    var nonHourMod = nonDayMod % hourMilliseconds;

    var minuteTime = nonHourMod / minuteMilliseconds;
    var nonMinuteMod = nonDayMod % minuteMilliseconds;

    var secondTime = nonMinuteMod / secondMilliseconds;
    //var nonSecondMod = nonHourMod % secondMilliseconds;

    var tradeAvailableDay = remainingDuration.inDays;

    var sendingScreenData = TimeScreenModels(
        year: yearTime.toInt(),
        month: monthTime.toInt(),
        day: dayTime.toInt(),
        hour: hourTime.toInt(),
        minute: minuteTime.toInt(),
        second: secondTime.toInt(),
        tradeAvailableDay: tradeAvailableDay.toInt());

    return sendingScreenData;
  }
}
