class CountDownValues {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  CountDownValues(
      {required this.days,
      required this.hours,
      required this.minutes,
      required this.seconds});

  factory CountDownValues.getValues() {
    DateTime nextFriday6PM = getNextFriday6PM();
    Duration difference = nextFriday6PM.difference(DateTime.now());

    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    return CountDownValues(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  static DateTime getNextFriday6PM() {
    DateTime now = DateTime.now();
    int daysToAdd = (DateTime.friday - now.weekday + 7) % 7;
    DateTime nextFriday = now.add(Duration(days: daysToAdd));
    return DateTime(nextFriday.year, nextFriday.month, nextFriday.day, 18, 0);
  }

  Stream<CountDownValues> getCountDownStream() async* {
    for (int i = seconds; seconds >= 0; i--) {
      Duration difference = Duration(seconds: i);

      int days = difference.inDays;
      int hours = difference.inHours % 24;
      int minutes = difference.inMinutes % 60;
      int seconds = difference.inSeconds % 60;

      yield CountDownValues(
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
      );

      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
