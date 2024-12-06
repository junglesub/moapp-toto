import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moapp_toto/models/notification_entity.dart';
import 'package:moapp_toto/models/toto_entity.dart';
import 'package:moapp_toto/models/user_entity.dart';
import 'package:moapp_toto/screens/notification/notification_screen.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationEntity?> _myNotifications = [];

  List<NotificationEntity> get n => _myNotifications
      .where((t) => t != null)
      .cast<NotificationEntity>()
      .toList();

  StreamSubscription<QuerySnapshot>? _myNotiSub;

  NotificationProvider() {
    print("NotificationProvider()");
    // init();
  }

  Future<void> init() async {
    // document entry
  }

  void refresh(String uid) async {
    print("Refresh notification provider with $uid");
    unsub();
    _myNotiSub = FirebaseFirestore.instance
        .collection('notification')
        .where("to", isEqualTo: uid)
        .orderBy("created", descending: true)
        .snapshots()
        .listen((snapshot) async {
      _myNotifications = await Future.wait(snapshot.docs
          .map((doc) => NotificationEntity.fromDocumentSnapshot(doc)));
      print('notification updated, notifying listeners...');
      notifyListeners();
    });
  }

  void unsub() {
    _myNotiSub?.cancel();
  }
}
