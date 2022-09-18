import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../constants/strings.dart';
import '../data/network/constants.dart';
import '../model/post.dart';
import 'storage_manager.dart';

class FireStoreManager {
  FireStoreManager._internal();

  static final FireStoreManager _instance = FireStoreManager._internal();

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  factory FireStoreManager() {
    return _instance;
  }

  Future<String> uploadPost({
    required String uid,
    required String username,
    required String description,
    required Uint8List file,
    required String profImage,
  }) async {
    String response = Strings.failure;
    try {
      final downloadUrl = await StorageManager()
          .uploadImageToStorage(childName: 'posts', file: file, isPost: true);

      final postId = const Uuid().v1();

      final post = Post(
        uid: uid,
        username: username,
        datePublished: DateTime.now().toUtc().toString(),
        profImage: profImage,
        postUrl: downloadUrl,
        postId: postId,
        description: description,
        likes: [],
      );

      _fireStore.collection('posts').doc(postId).set(post.toJson());
      response = Strings.success;
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<void> likePost({
    required String postId,
    required String userId,
    required List likes,
  }) async {
    try {
      if (likes.contains(userId)) {
        _fireStore.collection('posts').doc(postId).update(
          {
            FirebaseParameters.likes: FieldValue.arrayRemove([userId])
          },
        );
      } else {
        _fireStore.collection('posts').doc(postId).update(
          {
            FirebaseParameters.likes: FieldValue.arrayUnion([userId])
          },
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> postComment({
    required String postId,
    required String userId,
    required String commentText,
    required String profImage,
    required String username,
  }) async {
    try {
      if (commentText.isNotEmpty) {
        final commentId = const Uuid().v1();
        _fireStore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          FirebaseParameters.profImage: profImage,
          FirebaseParameters.username: username,
          FirebaseParameters.postId: postId,
          FirebaseParameters.description: commentText,
          FirebaseParameters.uid: userId,
          FirebaseParameters.datePublished: DateTime.now().toUtc().toString(),
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
