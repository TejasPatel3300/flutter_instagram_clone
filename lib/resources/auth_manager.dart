import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/resources/storage_manager.dart';

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
          'email': email,
          'username': userName,
          'bio': bio,
          'uid': cred.user!.uid,
          'followers': [],
          'following': [],
          'photoUrl': photoUrl,
        };

        await _firestore.collection('users').doc(cred.user!.uid).set(data);
        return "success";
      }
      return "failure";
    } catch (e) {
      return e.toString();
    }
  }
}
