import 'package:flutter/material.dart';

class ItemProvider with ChangeNotifier {
  late bool _value;

  bool get toggleVal => _value;

  void updateValue (bool chipValue) {
    _value = chipValue;
    notifyListeners();
  }
}