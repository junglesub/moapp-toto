import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moapp_toto/models/toto_entity.dart';
import 'package:moapp_toto/models/user_entity.dart';

class TotoProvider with ChangeNotifier {
  List<ToToEntity?> _totos = [];

  List<ToToEntity> get t =>
      _totos.where((t) => t != null).cast<ToToEntity>().toList();

  StreamSubscription<QuerySnapshot>? _totoSub;

  TotoProvider() {
    print("totoProvider()");
    init();
  }

  ToToEntity? findId(String id) {
    return _totos
            .where((element) => element != null && element.id == id)
            .isNotEmpty
        ? _totos.firstWhere((element) => element != null && element.id == id)
        : null;
  }

  Future<void> init() async {
    // document entry
    _totoSub = FirebaseFirestore.instance
        .collection('toto')
        .orderBy("created", descending: true)
        .snapshots()
        .listen((snapshot) {
      _totos = snapshot.docs
          .map((doc) => ToToEntity.fromDocumentSnapshot(doc))
          .toList();
      print('totos updated, notifying listeners...');
      notifyListeners();
    });
  }

  void refresh() async {
    _totoSub?.cancel();
    _totoSub = FirebaseFirestore.instance
        .collection('toto')
        .orderBy("created", descending: true)
        .snapshots()
        .listen((snapshot) {
      _totos = snapshot.docs
          .map((doc) => ToToEntity.fromDocumentSnapshot(doc))
          .toList();
      print('totos updated, notifying listeners...');
      notifyListeners();
    });
  }
}
