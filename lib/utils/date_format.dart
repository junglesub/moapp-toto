import 'package:cloud_firestore/cloud_firestore.dart';

String? convertTimestampToKoreanDate(Timestamp? timestamp) {
  if (timestamp == null) return null;
  DateTime dateTime = timestamp.toDate();
  int year = dateTime.year;
  int month = dateTime.month;
  int day = dateTime.day;

  return "$year년 ${month.toString().padLeft(2, '0')}월 ${day.toString().padLeft(2, '0')}일";
}
