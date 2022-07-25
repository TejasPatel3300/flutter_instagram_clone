import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../data/network/constants.dart';
import 'storage_manager.dart';

import '../constants/strings.dart';

class AuthManager {
  AuthManager._internal();

  static final AuthManager _instance = AuthManager._internal();

  factory AuthManager() {
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    required String bio,
    Uint8List? profilePicture,
  }) async {
    String response = Strings.failure;
    try {
      String? photoUrl;
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          userName.isNotEmpty &&
          bio.isNotEmpty) {
        // register user
        final cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (kDebugMode) {
          print(cred.user!.uid);
        }
        // upload profile picture if available
        if (profilePicture != null) {
          photoUrl = await StorageManager().uploadImageToStorage(
            childName: 'profilePic',
            file: profilePicture,
            isPost: false,
          );
        }

        // add user to firestore db
        final data = {
          FirebaseParameters.email: email,
          FirebaseParameters.username: userName,
          FirebaseParameters.bio: bio,
          FirebaseParameters.uid: cred.user!.uid,
          FirebaseParameters.followers: [],
          FirebaseParameters.following: [],
          FirebaseParameters.photoUrl: photoUrl,
        };

        await _firestore.collection('users').doc(cred.user!.uid).set(data);
        response = Strings.success;
      }
      response = Strings.failure;
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String response = Strings.failure;
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        response = Strings.success;
      }else{
        response = Strings.enterAllFields;
      }
    } catch (e) {
      response = e.toString();
    }
    return response;
  }
}
