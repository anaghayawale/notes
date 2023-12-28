import 'package:flutter/material.dart';
import 'package:notes/utils/token_storage.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User(id: '', name: '', email: '', password: '', token: '');

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void logoutUser(){
    TokenStorage.deleteToken();
    _user = User(id: '', name: '', email: '', password: '', token: '');
    notifyListeners();
  }
}
