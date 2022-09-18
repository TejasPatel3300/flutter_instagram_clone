import 'package:flutter/material.dart';

import '../model/user.dart';
import '../resources/auth_manager.dart';

class UserProvider with ChangeNotifier{
  final AuthManager _authManager = AuthManager();

  User? _user;
  User? get user => _user;

  Future<void> refreshUser() async{
    final User? user = await _authManager.getUserDetail();
    _user = user;
    notifyListeners();
  }
}