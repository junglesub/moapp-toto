import 'package:flutter/material.dart';

class TotoProvider with ChangeNotifier {
  String _name = '';
  String _email = '';

  String get name => _name;
  String get email => _email;

  void updateUser(String name, String email) {
    _name = name;
    _email = email;
    notifyListeners();
  }
}
