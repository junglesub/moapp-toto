import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserEntry {
  String uid;
  String? profileImageUrl;
  String? email;
  String? nickname;
  String? gender;
  int? birthyear;
  int point;
  int ticket;
  // List<String> followers = [];
  List<String> following = [];
  List<String> likedToto = [];

  UserEntry(
      {required this.uid,
      required this.gender,
      this.profileImageUrl,
      this.email,
      this.nickname,
      this.birthyear,
      // this.followers = const [],
      this.following = const [],
      this.likedToto = const [],
      this.point = 0,
      this.ticket = 0});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'uid': uid,
      // "followers": followers,
      "followings": following,
      "likedToto": likedToto,
      "ticket": ticket,
      "point": point
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
    if (profileImageUrl != null) {
      data['profileImageUrl'] = profileImageUrl;
    }

    return data;
  }

  static Future<UserEntry?> getUserByUid(String uid) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return UserEntry.fromDocumentSnapshot(snapshot);
    } catch (e) {
      print("Error fetching user data by uid: $e");
      return null;
    }
  }

  Future<bool> addFollowing(String targetId) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'following': FieldValue.arrayUnion([targetId])
    });
    return true;
  }

  Future<bool> removeFollowing(String targetId) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'following': FieldValue.arrayRemove([targetId])
    });
    return true;
  }

  Future<bool> addLike(String? totoId) async {
    if (totoId == null) return false;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'likedToto': FieldValue.arrayUnion([totoId])
    });
    return true;
  }

  Future<bool> removeLike(String? totoId) async {
    if (totoId == null) return false;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'likedToto': FieldValue.arrayRemove([totoId])
    });
    return true;
  }

  Future<bool> addTicket(int ticket) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'ticket': FieldValue.increment(ticket)});
    return true;
  }

  Future<bool> removeTicket(int ticket) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'ticket': FieldValue.increment(-ticket),
    });
    return true;
  }

  Future<bool> addPoint(int point) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'point': FieldValue.increment(point)});
    return true;
  }

  Future<bool> removePoint(int point) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'point': FieldValue.increment(-point),
    });
    return true;
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
      profileImageUrl: data['profileImageUrl'],
      ticket: data['ticket'] ?? 0,
      point: data['point'] ?? 0,
      // followers:
      //     data['followers'] != null ? List<String>.from(data['followers']) : [],
      following:
          data['following'] != null ? List<String>.from(data['following']) : [],
      likedToto:
          data['likedToto'] != null ? List<String>.from(data['likedToto']) : [],
    );
  }
}

extension UserEntryExtensions on UserEntry {
  Future<void> uploadProfileImage(Uint8List imageBytes) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child("profile_images/$uid.jpg");

      final uploadTask = await imageRef.putData(imageBytes);
      final downloadUrl = await imageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profileImageUrl': downloadUrl,
      });

      profileImageUrl = downloadUrl;

      print("Profile image uploaded and Firestore updated successfully.");
    } catch (e) {
      print("Error uploading profile image: $e");
      throw e;
    }
  }
}
