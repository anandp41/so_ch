import 'package:intl/intl.dart';

String groupMessageDateAndTime(String time) {
  var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
  final todayDate = DateTime.now();

  final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
  final yesterday =
      DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
  String difference = '';
  final aDate = DateTime(dt.year, dt.month, dt.day);

  if (aDate == today) {
    difference = "Today";
  } else if (aDate == yesterday) {
    difference = "Yesterday";
  } else {
    difference = DateFormat.yMMMd().format(dt).toString();
  }

  return difference;
}
