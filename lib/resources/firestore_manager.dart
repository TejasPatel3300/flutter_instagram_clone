import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/resources/storage_manager.dart';
import 'package:uuid/uuid.dart';

import '../constants/strings.dart';
import '../model/post.dart';

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
}
