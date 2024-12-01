import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moapp_toto/screens/add/location_select_screen.dart';
import 'package:moapp_toto/utils/emotions.dart';

class ToToEntity {
  String? id;
  final String name;
  final String description;
  final String? emotion;
  final LocationResult? location;
  String? imageUrl;
  final String creator;
  final Timestamp? created;
  final Timestamp? modified;
  final List<String> liked;
  final String? aiReaction;
  List<String?>? taggedFriends; // 태그된 친구들 UID 리스트

  String? get imageUrlLink => imageUrl;

  ToToEntity({
    this.id,
    required this.name,
    required this.description,
    required this.creator,
    required this.liked,
    this.created,
    this.modified,
    this.imageUrl,
    this.location,
    this.emotion,
    this.aiReaction,
    this.taggedFriends,
  });

  ToToEntity.withImageFile({
    this.id,
    this.emotion,
    this.location,
    this.aiReaction,
    required this.name,
    required this.description,
    required this.creator,
    required this.created,
    required this.modified,
    required this.liked,
    required dynamic imageFile,
    required this.taggedFriends,
  }) : imageUrl = null {
    // _uploadImageAndSetUrl(imageFile);
  }

  static Future<ToToEntity> createWithImageFile({
    String? id,
    String? emotion,
    LocationResult? location,
    List<String>? taggedFriends,
    required String name,
    required String description,
    required String creator,
    required Timestamp? created,
    required Timestamp? modified,
    required List<String> liked,
    required dynamic imageFile,
  }) async {
    final entity = ToToEntity(
      id: id,
      emotion: emotion,
      location: location,
      taggedFriends: taggedFriends,
      name: name,
      description: description,
      creator: creator,
      created: created,
      modified: modified,
      liked: liked,
    );

    await entity._uploadImageAndSetUrl(imageFile);
    return entity;
  }

  Future<ToToEntity?> _uploadImageAndSetUrl(dynamic imageFile) async {
    id = await save();
    print("Uploading Image with ID $id");

    try {
      final ref = FirebaseStorage.instance.ref().child('toto/$id');

      if (kIsWeb) {
        // Web-specific: Ensure `imageFile` is `Uint8List`
        if (imageFile is Uint8List) {
          await ref.putData(imageFile);
        } else {
          throw 'Invalid file format for web. Expected Uint8List.';
        }
      } else {
        // Non-web: Use File
        if (imageFile is File) {
          await ref.putFile(imageFile);
        } else {
          throw 'Invalid file format for non-web. Expected File.';
        }
      }

      final url = await ref.getDownloadURL();
      imageUrl = url;

      await save(markModified: false);
      return this;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  ToToEntity.empty({required this.creator})
      : id = null,
        name = "",
        description = "",
        liked = [],
        created = null,
        modified = null,
        imageUrl = null,
        emotion = null,
        location = null,
        taggedFriends = [],
        aiReaction = null;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'creator': creator,
      "liked": liked,
      "imageUrl": imageUrl ?? imageUrlLink,
      "location": location != null
          ? GeoPoint(
              location!.coordinates.latitude, location!.coordinates.longitude)
          : null,
      "location_name": location?.placeName,
      "emotion": emotion,
      'taggedFriends': taggedFriends ?? [], // 기본값 빈 리스트
      // 'created': created,
      // 'modified': modified,
    };

    // if (imageUrl != null) {
    //   data['imageUrl'] = imageUrl;
    // }

    return data;
  }

  static ToToEntity fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    GeoPoint? gp = data["location"];

    return ToToEntity(
      id: snapshot.id,
      name: data['name'],
      description: data['description'],
      creator: data['creator'],
      created: data['created'],
      modified: data['modified'],
      imageUrl: data['imageUrl'],
      emotion: data["emotion"],
      taggedFriends: data['taggedFriends'] != null
          ? List<String>.from(data['taggedFriends'])
          : [], // 기본값 빈 리스트
      aiReaction: data["aiReaction"],
      location: gp != null
          ? LocationResult(
              placeName: data["location_name"],
              coordinates: LatLng(gp.latitude, gp.longitude))
          : null,
      liked: data['liked'] != null ? List<String>.from(data['liked']) : [],
    );
  }

  Future<String> save({markModified = true}) async {
    if (id == null) {
      print("Create New!");
      id = (await FirebaseFirestore.instance.collection('toto').add({
        ...toMap(),
        "created": FieldValue.serverTimestamp(),
        "modified": FieldValue.serverTimestamp(),
        "creator": creator
      }))
          .id;
      return id!;
    } else {
      final docRef = FirebaseFirestore.instance.collection('toto').doc(id);
      if (markModified) {
        await docRef.set({...toMap(), "modified": FieldValue.serverTimestamp()},
            SetOptions(merge: true));
      } else {
        await docRef.set(toMap(), SetOptions(merge: true));
      }
      return id!;
    }
  }

  Future<bool> addLike(String? uid) async {
    if (id == null || uid == null || liked.contains(uid)) return false;
    await FirebaseFirestore.instance.collection('toto').doc(id).update({
      'liked': FieldValue.arrayUnion([uid])
    });
    return true;
  }

  Future delete() async {
    // Delete Storage
    final ref = FirebaseStorage.instance.ref().child('toto/$id');
    ref.delete().catchError((_) {});

    // Delete Item
    await FirebaseFirestore.instance.collection('toto').doc(id).delete();
  }

  Future<void> addTaggedFriend(String uid) async {
    taggedFriends ??= []; // null인 경우 빈 리스트로 초기화
    if (!taggedFriends!.contains(uid)) {
      taggedFriends!.add(uid);
      await save(markModified: true); // 변경된 데이터 저장
    }
  }
}
