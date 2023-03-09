import 'package:flutter/material.dart';

class Filter with ChangeNotifier {
  int _value = -1;

  int get value => _value;

  void updateValue (int chipValue) {
    _value = chipValue;
    notifyListeners();
  }

  void resetValue () {
    _value = -1;
  }
}

class VegSelector with ChangeNotifier {
  int _value = -2;

  int get value => _value;

  void updateValue (int chipValue) {
    _value = chipValue;
    notifyListeners();
  }

  void resetValue () {
    _value = -2;
  }
}