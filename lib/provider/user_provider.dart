import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moapp_toto/main.dart';
import 'package:moapp_toto/models/user_entity.dart';

class UserProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  User? currentUser;
  UserEntry? ue;
  StreamSubscription<DocumentSnapshot>? _ueSub;

  UserProvider() {
    print("UserProvider()");
    init();
  }

  Future<void> init() async {
    print("UserProvider Init");

    // Watch Auth State
    _auth.authStateChanges().listen((User? user) async {
      currentUser = user;

      if (user != null) {
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        try {
          final docSnapshot = await userDocRef.get();

          if (!docSnapshot.exists) {
            // Create New User

            debugPrint("New User!");
            // Guide to new page
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
                "/signup", (Route<dynamic> route) => false);
          } else {
            navigatorKey.currentState
                ?.pushNamedAndRemoveUntil("/", (Route<dynamic> route) => false);
          }
          // user entry
          _ueSub = userDocRef.snapshots().listen((snapshot) {
            ue = UserEntry.fromDocumentSnapshot(snapshot);
            notifyListeners();
          });
        } catch (error) {
          print('Error fetching user document: $error');
        }
      } else {
        // user is null. Cancel subscription? 유저 관련된 subsciption 만
        _ueSub?.cancel();
      }
    });
  }
}
