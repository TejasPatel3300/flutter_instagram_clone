import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/network/constants.dart';

class User {
  User({
    required this.email,
    required this.username,
    required this.bio,
    required this.uid,
    required this.photoUrl,
    required this.followers,
    required this.following,
  });

  final String email;
  final String username;
  final String bio;
  final String uid;
  final String photoUrl;
  final List followers;
  final List following;

  Map<String, dynamic> toJson() => {
        FirebaseParameters.email: email,
        FirebaseParameters.username: username,
        FirebaseParameters.bio: bio,
        FirebaseParameters.uid: uid,
        FirebaseParameters.followers: followers,
        FirebaseParameters.following: following,
        FirebaseParameters.photoUrl: photoUrl,
      };

  static User? fromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data() == null) {
      return null;
    }
    final data = snapshot.data() as Map<String, dynamic>;

    return User(
      email: data[FirebaseParameters.email],
      username: data[FirebaseParameters.username],
      bio: data[FirebaseParameters.bio],
      uid: data[FirebaseParameters.uid],
      photoUrl: data[FirebaseParameters.photoUrl],
      followers: data[FirebaseParameters.followers],
      following: data[FirebaseParameters.following],
    );
  }
}
