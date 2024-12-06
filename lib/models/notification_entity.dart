import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moapp_toto/models/user_entity.dart';

class NotificationEntity {
  String? id;
  final UserEntry? from, to;
  final String? code, title, message, totoId;
  final Timestamp? created;
  final Timestamp? modified;

  NotificationEntity({
    required this.id,
    this.from,
    this.to,
    this.code,
    this.title,
    this.message,
    this.totoId,
    this.created,
    this.modified,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      "from": from?.uid,
      "to": to?.uid,
      "code": code,
      "title": title,
      "message": message,
    };

    if (totoId != null) {
      data['totoId'] = totoId;
    }
    return data;
  }

  static Future<NotificationEntity?> fromDocumentSnapshot(
      DocumentSnapshot snapshot) async {
    if (!snapshot.exists) return null;
    final data = snapshot.data() as Map<String, dynamic>;

    // parse from to data.
    UserEntry? from = data["from"] != null
        ? await UserEntry.getUserByUid(data["from"])
        : null;
    UserEntry? to =
        data["to"] != null ? await UserEntry.getUserByUid(data["to"]) : null;

    if (to == null) {
      print("notification - fromDocumentSnapshot - invalid userTo");
      return null;
    }

    return NotificationEntity(
      id: snapshot.id,
      from: from,
      to: to,
      code: data['code'],
      title: data['title'],
      message: data['message'],
      totoId: data['totoId'],
      created: data['created'],
      modified: data['modified'],
    );
  }

  Future<String> save({markModified = true}) async {
    if (id == null) {
      print("Create Notification!");
      id = (await FirebaseFirestore.instance.collection('notification').add({
        ...toMap(),
        "created": FieldValue.serverTimestamp(),
        "modified": FieldValue.serverTimestamp(),
      }))
          .id;
      return id!;
    } else {
      final docRef =
          FirebaseFirestore.instance.collection('notification').doc(id);
      if (markModified) {
        await docRef.set({...toMap(), "modified": FieldValue.serverTimestamp()},
            SetOptions(merge: true));
      } else {
        await docRef.set(toMap(), SetOptions(merge: true));
      }
      return id!;
    }
  }

  Future delete() async {
    await FirebaseFirestore.instance
        .collection('notification')
        .doc(id)
        .delete();
  }
}
