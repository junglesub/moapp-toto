import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  String? get imageUrlLink => imageUrl;

  ToToEntity(
      {this.id,
      required this.name,
      required this.description,
      required this.creator,
      required this.liked,
      this.created,
      this.modified,
      this.imageUrl,
      this.location,
      this.emotion});

  ToToEntity.withImageFile({
    this.id,
    this.emotion,
    this.location,
    required this.name,
    required this.description,
    required this.creator,
    required this.created,
    required this.modified,
    required this.liked,
    required File imageFile,
  }) : imageUrl = null {
    _uploadImageAndSetUrl(imageFile);
  }

  Future<ToToEntity?> _uploadImageAndSetUrl(File imageFile) async {
    id = await save();
    try {
      final ref = FirebaseStorage.instance.ref().child('toto/$id');
      await ref.putFile(imageFile);
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
        location = null;

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
      "emotion": emotion
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
    return ToToEntity(
      id: snapshot.id,
      name: data['name'],
      description: data['description'],
      creator: data['creator'],
      created: data['created'],
      modified: data['modified'],
      imageUrl: data['imageUrl'],
      emotion: data["emotion"],
      location: data["location"] != null
          ? LocationResult(
              placeName: data["location_name"],
              coordinates: LatLng(
                  data["location"]["latitude"], data["location"]["longitude"]))
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
}
