import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntry {
  String uid;
  String? email;
  String? nickname;
  String? gender;
  int? birthyear;

  UserEntry({
    required this.uid,
    required this.gender,
    this.email,
    this.nickname,
    this.birthyear,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'uid': uid,
    };

    if (email != null) {
      data['email'] = email;
    }
    if (nickname != null) {
      data['nickname'] = nickname;
    }
    if (gender != null) {
      data['gender'] = gender;
    }
    if (birthyear != null) {
      data['birthyear'] = birthyear;
    }

    return data;
  }

  static UserEntry? fromDocumentSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) return null;
    final data = snapshot.data() as Map<String, dynamic>;
    return UserEntry(
      uid: data['uid'],
      gender: data['gender'],
      email: data['email'],
      nickname: data['nickname'],
      birthyear: data['birthyear'],
    );
  }
}
