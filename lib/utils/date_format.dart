import 'package:cloud_firestore/cloud_firestore.dart';

String? convertTimestampToKoreanDate(Timestamp? timestamp) {
  if (timestamp == null) return null;
  DateTime dateTime = timestamp.toDate();
  int year = dateTime.year;
  int month = dateTime.month;
  int day = dateTime.day;

  return "$year년 ${month.toString().padLeft(2, '0')}월 ${day.toString().padLeft(2, '0')}일";
}

String? convertTimestampToKoreanDateTime(Timestamp? timestamp) {
  if (timestamp == null) return null;
  DateTime dateTime = timestamp.toDate();
  int month = dateTime.month;
  int day = dateTime.day;
  int hour = dateTime.hour;
  int minute = dateTime.minute;

  String period = hour >= 12 ? "오후" : "오전";
  int adjustedHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

  return "${month.toString()}월 ${day.toString()}일 "
      "$period ${adjustedHour.toString()}시 ${minute.toString().padLeft(2, '0')}분";
}

String? getRelativeTime(Timestamp? timestamp) {
  if (timestamp == null) return null;

  final now = DateTime.now();
  final time = timestamp.toDate();
  final difference = now.difference(time);

  if (difference.inMinutes < 1) {
    return '방금 전';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}분 전';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}시간 전';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}일 전';
  } else if (difference.inDays < 30) {
    return '${(difference.inDays / 7).floor()}주 전';
  } else if (difference.inDays < 365) {
    return '${(difference.inDays / 30).floor()}개월 전';
  } else {
    return '${(difference.inDays / 365).floor()}년 전';
  }
}

bool isToday(DateTime? date) {
  if (date == null) return false;
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

int daysPassed(DateTime? startDate) {
  if (startDate == null) return 0;
  final today = DateTime.now();
  final difference =
      today.difference(startDate).inDays + 1; // Including the start day
  return difference;
}

String formatDateToYYYYMMDD(DateTime date) {
  return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}
