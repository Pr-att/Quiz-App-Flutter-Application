import 'package:flutter/material.dart';

class PlayerScore with ChangeNotifier {
  String? _name;

  String? get name => _name;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }
}

class QuizQuestion with ChangeNotifier {
  String? _amount;
  String? _category;
  String? _difficulty;
  String? _type;
  int currentPage = 0;
  int currentScore = 0;

  get amount => _amount;

  get category => _category;

  get difficulty => _difficulty;

  get type => _type;

  get page => currentPage;

  get score => currentScore;

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
    currentPage = 0;
    currentScore = 0;
    notifyListeners();
  }

  void wrongAnswer() {
    currentScore = currentScore - 1;
    notifyListeners();
  }

  void correctAnswer() {
    currentScore = currentScore + 2;
    notifyListeners();
  }

  void nextPage() {
    currentPage = currentPage + 1;
    notifyListeners();
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage = currentPage - 1;
    }
    notifyListeners();
  }

  void setPage(int page) {
    currentPage = page;
    notifyListeners();
  }
}
