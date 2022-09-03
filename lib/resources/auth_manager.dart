import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:instagram_clone/model/user.dart' as user_model;
import '../constants/strings.dart';
import 'storage_manager.dart';

class AuthManager {
  AuthManager._internal();

  static final AuthManager _instance = AuthManager._internal();

  factory AuthManager() {
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<user_model.User> getUserDetail() async {
    final currentUser = _auth.currentUser;

    DocumentSnapshot snap =
        await _fireStore.collection('users').doc(currentUser!.uid).get();
    return user_model.User.fromSnapshot(snap);
  }

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
        final user_model.User user = user_model.User(
          email: email,
          username: userName,
          bio: bio,
          uid: cred.user!.uid,
          photoUrl: photoUrl ?? '',
          followers: [],
          following: [],
        );

        await _fireStore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
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
      } else {
        response = Strings.enterAllFields;
      }
    } catch (e) {
      response = e.toString();
    }
    return response;
  }
}
