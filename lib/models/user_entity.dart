import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntry {
  String? email;
  String? name;
  String uid;
  String statusMessage;

  UserEntry({
    required this.uid,
    required this.statusMessage,
    this.email,
    this.name,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'uid': uid,
      'status_message': statusMessage,
    };

    if (email != null) {
      data['email'] = email;
    }
    if (name != null) {
      data['name'] = name;
    }

    return data;
  }

  static UserEntry fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserEntry(
      uid: data['uid'],
      statusMessage: data['status_message'],
      email: data['email'],
      name: data['name'],
    );
  }
}
