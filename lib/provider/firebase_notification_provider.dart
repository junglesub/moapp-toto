import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:moapp_toto/models/user_entity.dart';

class FirebaseNotificationProvider with ChangeNotifier {
  late FirebaseMessaging _messaging;
  StreamSubscription<QuerySnapshot>? _allUsersSub;
  String? _token;

  FirebaseNotificationProvider() {
    print("FirebaseNotificationProvider()");
    init();
  }

  Future<void> init() async {
    // document entry
    _messaging = FirebaseMessaging.instance;
    _messaging.
  }

  void refresh() async {}

  Future<void> grantPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<String?> getToken({bool force = false}) async {
    // Retrieve the FCM token
    if (force || _token == null) {
      await grantPermission();
      _token = await _messaging.getToken(
        vapidKey:
            "BDswZhxhHlBee5p4T_IeQsEfYVbpzW-JjJFFVFS1muhmIyiGGbFnil0Ldkm2zPhl2it09hi71e6KmU_azAJQVkE",
      );
    }
    notifyListeners();
    print("FCM Token: $_token");
    return _token;
  }
}
