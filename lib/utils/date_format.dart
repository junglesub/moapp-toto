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

bool isToday(DateTime? date) {
  if (date == null) return false;
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}
