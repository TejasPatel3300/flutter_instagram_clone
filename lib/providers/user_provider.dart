import 'package:flutter/material.dart';
import 'package:instagram_clone/model/user.dart';
import 'package:instagram_clone/resources/auth_manager.dart';

class UserProvider with ChangeNotifier{
  final AuthManager _authManager = AuthManager();

  User? _user;
  User get user => _user!;

  Future<void> refreshUser() async{
    final User? user = await _authManager.getUserDetail();
    _user = user;
    notifyListeners();
  }
}