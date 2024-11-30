import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moapp_toto/models/user_entity.dart';

class AllUsersProvider with ChangeNotifier {
  List<UserEntry?> _allUsers = [];

  List<UserEntry?> get au => _allUsers;

  AllUsersProvider() {
    print("allUserProvider()");
    init();
  }

  Future<void> init() async {
    // document entry
    FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((snapshot) {
      _allUsers = snapshot.docs
          .map((doc) => UserEntry.fromDocumentSnapshot(doc))
          .where((doc) => doc != null)
          .toList();
      print('Products updated, notifying listeners...');
      notifyListeners();
    });
  }
}
