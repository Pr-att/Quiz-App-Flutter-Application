import 'package:flutter/material.dart';

class PlayerScore with ChangeNotifier {
  String _name = '';
  String get name => _name;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }
}

class QuizQuestion with ChangeNotifier {
  var _amount;
  var _category;
  var _difficulty;
  var _type;

  get amount => _amount;
  get category => _category;
  get difficulty => _difficulty;
  get type => _type;

  void setAmount(amount) {
    _amount = amount;
    notifyListeners();
  }

  void setCategory(category) {
    _category = category;
    notifyListeners();
  }

  void setDifficulty(difficulty) {
    _difficulty = difficulty;
    notifyListeners();
  }

  void setType(type) {
    _type = type;
    notifyListeners();
  }

  void restart() {
    _amount = null;
    _category = null;
    _difficulty = null;
    _type = null;
    notifyListeners();
  }

}