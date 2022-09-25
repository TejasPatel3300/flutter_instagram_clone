import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/network/constants.dart';

class Post {
  Post({
    required this.uid,
    required this.username,
    required this.postUrl,
    required this.postId,
    required this.datePublished,
    required this.description,
    required this.profImage,
    required this.likes,
  });

  final String uid;
  final String postId;
  final String username;
  final String datePublished;
  final String description;
  final String postUrl;
  final String profImage;
  final List likes;

  Map<String, dynamic> toJson() => {
        FirebaseParameters.username: username,
        FirebaseParameters.uid: uid,
        FirebaseParameters.postId: postId,
        FirebaseParameters.datePublished: datePublished,
        FirebaseParameters.description: description,
        FirebaseParameters.postUrl: postUrl,
        FirebaseParameters.profImage: profImage,
        FirebaseParameters.likes: likes,
      };

  static Post? fromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data() == null) {
      return null;
    }
    final data = snapshot.data() as Map<String, dynamic>;

    return Post(
      username: data[FirebaseParameters.username],
      uid: data[FirebaseParameters.uid],
      datePublished: data[FirebaseParameters.datePublished],
      likes: data[FirebaseParameters.likes],
      description: data[FirebaseParameters.description],
      postId: data[FirebaseParameters.postId],
      postUrl: data[FirebaseParameters.postUrl],
      profImage: data[FirebaseParameters.profImage],
    );
  }
}
